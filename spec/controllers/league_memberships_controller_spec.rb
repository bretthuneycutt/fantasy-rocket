require 'spec_helper'

describe LeagueMembershipsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:league) { FactoryGirl.create(:league) }

  describe "POST 'create'" do
    context "if not logged in" do
      it "redirects to sign up page" do
        post :create, :league_id => league.id

        redirect_path = new_user_path(redirect_to: league_path(league))

        expect(response).to redirect_to(redirect_path)
      end
    end

    context "if logged in and not a member" do
      def go!
        post :create, {:league_id => league.id}, {:user_id => user.id}
      end

      it "adds current_user to members" do
        league.members.should_not include(user)

        go!

        league.members.should include(user)
      end

      it "redirects to league page" do
        go!

        expect(response).to redirect_to(league_path(league))
      end
    end

    context "if logged in and already a member" do
      before :each do
        league.members << user
      end

      def go!
        post :create, {:league_id => league.id}, {:user_id => user.id}
      end

      it "adds current_user to members" do
        league.members.should include(user)

        go!

        league.members.should include(user)
      end

      it "redirects to league page" do
        go!

        expect(response).to redirect_to(league_path(league))
      end
    end
  end
end
