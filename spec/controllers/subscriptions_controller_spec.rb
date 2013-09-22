require 'spec_helper'

shared_examples "endpoint that requires logged in user" do
  context "if logged out" do
    it "returns 404" do
      go!

      response.should be_not_found
    end
  end
end

describe SubscriptionsController do
  before(:each) { request.env['HTTPS'] = 'on' }

  describe "GET 'new'" do
    def go!(options = {})
      get :new, options
    end

    it_behaves_like "endpoint that requires logged in user"

    context "when logged in" do
      let(:user) { FactoryGirl.create(:user) }
      before(:each) { request.cookies[:auth_token] = user.auth_token }

      it "renders template" do
        go!

        response.should render_template(:new)
      end

      it "instantiate subscription" do
        go!

        assigns(:subscription).should be_a Subscription
        assigns(:subscription).should_not be_persisted
      end

      context "if user already has a subscription" do
        before(:each) { user.create_subscription! }

        it "redirects to root_url" do
          go!

          response.should redirect_to(root_url)
        end

        it "redirects to specific URL if specified" do
          league = FactoryGirl.create(:league)

          go!(redirect_to: league_url(league))

          response.should redirect_to(league_url(league))
        end
      end
    end
  end

  describe "POST 'create'" do
    def go!(options = {})
      post :create, options
    end

    it_behaves_like "endpoint that requires logged in user"

    context "when logged in" do
      let(:user) { FactoryGirl.create(:user) }
      before(:each) { request.cookies[:auth_token] = user.auth_token }

      context "with valid stripeToken" do
        let(:options) { {stripeToken: "valid-token"} }

        before :each do
          Stripe::Customer.stub(:create).with({
              :description => user.id,
              :email => user.email,
              :card => "valid-token",
          }) do
            o = Object.new
            o.stub(:id) { "stripe_id" }
            o
          end

          Stripe::Charge.stub(:create).with({
            :customer => "stripe_id",
            :amount => 250,
            :description => 'Fantasy Rocket Monthly Subscription',
            :currency => "usd",
          })
        end

        it "saves stripe customer ID to user" do
          user.stripe_id.should be_nil

          go!(options)

          user.reload.stripe_id.should == "stripe_id"
        end

        it "charges the customer" do
          Stripe::Charge.should_receive(:create).with({
            :customer => "stripe_id",
            :amount => 250,
            :description => 'Fantasy Rocket Monthly Subscription',
            :currency => "usd",
          })

          go!(options)
        end

        it "creates a subscription for the current_user" do
          user.subscription.should be_nil

          go!(options)

          user.reload.subscription.should_not be_nil
        end

        it "redirects to the root_url" do
          go!(options)

          response.should redirect_to(root_url)
        end

        it "redirects to specific URL if specified" do
          league = FactoryGirl.create(:league)

          go!(options.merge(redirect_to: league_url(league)))

          response.should redirect_to(league_url(league))
        end
      end
    end
  end
end
