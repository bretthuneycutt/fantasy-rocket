require 'spec_helper'

describe DraftPicksController do
  let!(:previous_pick) { FactoryGirl.create(:draft_pick, league: pick.league, team_id: 1) }
  let(:pick) { FactoryGirl.create(:draft_pick) }

  describe "PUT 'update'" do
    context "for someone not the picker" do
      it "returns 403" do
        put :update, :id => pick.id, :team_id => 24

        expect(response).to be_forbidden
      end

      it "does not update the pick" do
        pick.should_not be_selected

        put :update, :id => pick.id, :team_id => 24

        pick.reload.should_not be_selected
      end
    end

    context "for the picker" do
      context "for an unavailable team" do
        it "does not update the pick" do
          pick.should_not be_selected

          put :update, {:id => pick.id, :team_id => 1}, {:user_id => pick.member_id}

          pick.reload.should_not be_selected
        end

        it "redirects to the draft page" do
          put :update, {:id => pick.id, :team_id => 1}, {:user_id => pick.member_id}

          expect(response).to redirect_to(league_path(pick.league))
        end
      end

      context "for an available team" do
        it "updates the pick" do
          pick.should_not be_selected

          put :update, {:id => pick.id, :team_id => 2}, {:user_id => pick.member_id}

          pick.reload
          pick.should be_selected
          pick.team_id.should == 2
        end

        it "redirects to the draft page" do
          put :update, {:id => pick.id, :team_id => 2}, {:user_id => pick.member_id}

          expect(response).to redirect_to(league_path(pick.league))
        end
      end
    end
  end
end
