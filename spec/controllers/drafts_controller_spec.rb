require 'spec_helper'

describe DraftsController do
  let(:league) { FactoryGirl.create(:league) }

  describe "POST 'create'" do
    context "by non-commissioner" do
      it "does not change the draft status" do
        status = league.draft.status

        post :create, {:league_id => league.id}

        league.reload.draft.status.should == status
      end

      it "redirects to the league page" do
        post :create, :league_id => league.id

        expect(response).to redirect_to(league_path(league))
      end
    end

    context "by commissioner if draft has already been completed" do
      before :each do
        DraftGenerator.new(league).generate_picks!
        league.draft_picks.each_with_index { |dp, i| dp.update_attribute(:team_id, i) }
      end

      it "does not change the draft status" do
        status = league.draft.status

        post :create, {:league_id => league.id}, {:user_id => league.commissioner_id}

        league.reload.draft.status.should == status
      end

      it "redirects to the league page" do
        post :create, {:league_id => league.id}, {:user_id => league.commissioner_id}

        expect(response).to redirect_to(league_path(league))
      end
    end

    context "by commissioner if draft hasn't been started" do
      it "starts the draft" do
        league.draft.status.should == :not_started

        post :create, {:league_id => league.id}, {:user_id => league.commissioner_id}

        league.reload.draft.status.should == :in_progress
      end

      it "redirects to the league page" do
        post :create, {:league_id => league.id}, {:user_id => league.commissioner_id}

        expect(response).to redirect_to(league_path(league))
      end
    end
  end
end
