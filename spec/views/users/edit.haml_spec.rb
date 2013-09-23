require 'spec_helper'

describe "users/edit" do
  before(:each) { view.stub(:current_user) { user } }
  let(:user) { FactoryGirl.create(:user) }

  context "when current_user is not a subscriber" do
    it "links to new_subscriptions_path" do
      render

      rendered.should include "Subscribe", new_subscriptions_url
    end
  end

  context "when current_user has an active subscription" do
    let!(:subscription) { FactoryGirl.create(:subscription, user: user) }

    it "links to cancel subscription" do
      render

      render.should include "Cancel subscription", subscriptions_url
    end

    it "does not link to new subscription" do
      render

      rendered.should_not include "Subscribe", new_subscriptions_url
    end
  end

  context "when current_user has credit card details on file" do
    it "displays credit card details (credit card type, last 4 digits, billing date)"

  end
end
