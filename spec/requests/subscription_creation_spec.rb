require 'spec_helper'

describe "SubscriptionCreation" do
  let(:user) { FactoryGirl.create(:user) }

  context "for a logged in user without a subscription" do
    before :each do
      visit new_session_url
      fill_in "email", with: user.email
      fill_in "password", with: "password"
      click_on "Submit"

      visit new_subscriptions_url(subdomain: 'secure')

      page.should have_content("Subscribe")

      user.should_not be_subscriber
      user.stripe_id.should be_nil

      find(:xpath, "//input[@id='stripeToken']").set token.id
      click_on "Subscribe"
    end

    context "for a valid card", :vcr do
      let :token do
        Stripe::Token.create(
          :card => {
            :number => "4242424242424242",
            :exp_month => 9,
            :exp_year => 2016,
            :cvc => "314",
          },
        )
      end

      it "should create a new subscription" do
        user.reload
        user.should be_subscriber
        user.stripe_id.should be_present
      end
    end

    context "for a card that is declined", :vcr do
      let :token do
        Stripe::Token.create(
          :card => {
            :number => "4000000000000002",
            :exp_month => 9,
            :exp_year => 2016,
            :cvc => "314",
          },
        )
      end

      it "should not create a new subscription for a card that is declined"  do
        user.reload
        user.should_not be_subscriber
        user.stripe_id.should be_nil

        page.should have_content("Subscribe")
        page.should have_content("Your card was declined.")
      end
    end
  end
end
