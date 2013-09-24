require 'spec_helper'

describe LeagueMembershipsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:league) { FactoryGirl.create(:league) }

  describe "POST 'create'" do
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

        expect(response).to redirect_to(league_url(league, member: user.id))
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

        expect(response).to redirect_to(league_url(league, member: user.id))
      end
    end
  end
end
