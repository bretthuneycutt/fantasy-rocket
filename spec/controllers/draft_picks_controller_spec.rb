require 'spec_helper'

describe DraftPicksController do
  let(:league) { pick.league }
  let!(:previous_pick) { FactoryGirl.create(:draft_pick, league: league, team_id: 1, order: 0) }
  let(:pick) { FactoryGirl.create(:draft_pick, order: 1) }

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

          expect(response).to redirect_to(league_path(pick.league, show_drafted: true))
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

          expect(response).to redirect_to(league_path(pick.league, show_drafted: true))
        end

        context "if it's the last pick" do
          it "sends the draft-complete email to all members" do
            league.members.each do |m|
              DraftCompleteMailerWorker.should_receive(:perform_async).with(m.id, league.id)
            end

            put :update, {:id => pick.id, :team_id => 2}, {:user_id => pick.member_id}
          end
        end

        context "if it's not the last pick" do
          let!(:next_pick) { FactoryGirl.create(:draft_pick, league: league, order: 2) }

          it "sends the pick-made email to all members" do
            league.members.each do |m|
              DraftPickMadeMailerWorker.should_receive(:perform_async).with(m.id, league.id)
            end

            put :update, {:id => pick.id, :team_id => 2}, {:user_id => pick.member_id}
          end
        end

      end
    end
  end
end
