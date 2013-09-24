require 'spec_helper'

describe LeaguesController do
  let(:commissioner) { FactoryGirl.create(:user) }

  before(:each) do
    stub_logged_in!(commissioner)
  end

  describe "GET new" do
    it "returns ok" do
      get :new
      expect(response).to be_ok
    end
  end

  describe "POST create" do
    context "with valid parameters" do
      it "redirects to the league path" do
        post :create, 'league' => {
          'name' => "League name",
        }

        expect(response).to redirect_to(league_path(assigns(:league)))
      end

      it "creates an nfl league" do
        post :create, 'league' => {
          'name' => "League name",
        }

        league = assigns(:league)
        league.should be_persisted
        league.sport.should == :nfl
      end

      context "on nba subdomain" do
        before :each do
          @request.host = "nba.test.host"
        end

        it "creates an nba league" do
          post :create, 'league' => {
            'name' => "League name",
          }

          league = assigns(:league)
          league.should be_persisted
          league.sport.should == :nba
        end
      end
    end

    context "with missing name" do
      it "renders the new template with errors" do
        post :create, 'league' => {
          'name' => '',
        }

        expect(response).to render_template("new")
      end
    end
  end

  describe "GET 'show'" do
    let(:league) { FactoryGirl.create(:league) }
    before(:each) { @request.host = "nfl.test.host" }


    context "with incorrect hmac" do
      it "returns 404" do
        get :show, :id => league.id, :h => "incorrect-hmac"

        response.should be_not_found
      end
    end

    context "with correct hmac" do
      it "renders page successfully" do
        get :show, :id => league.id, :h => league.hmac

        response.should be_ok
        expect(response).to render_template("pre_draft")
        assigns(:league).should == league
      end
    end

    context "for an NBA league" do
      let(:league) { FactoryGirl.create(:nba_league) }

      it "redirects to the right subdomain if on the wrong subdomain" do
        get :show, :id => league.id, :h => league.hmac

        expect(response).to redirect_to(league_url(league))
      end

      it "renders the page if on the right subdomain" do
        @request.host = "nba.test.host"

        get :show, :id => league.id, :h => league.hmac

        response.should be_ok
        expect(response).to render_template("pre_draft")
        assigns(:league).should == league
      end
    end
  end

  describe "GET 'show' before draft with member parameter" do
    render_views
    before(:each) { @request.host = "nfl.test.host" }

    let(:league) { FactoryGirl.create(:league, commissioner: commissioner) }
    let(:member) { FactoryGirl.create(:user) }

    context "for a member" do
      before :each do
        league.members << member
      end

      it "displays the draft_pick modal" do
        get :show, id: league.id, h: league.hmac, member: member.id

        response.body.should include "You've joined #{league.name}"
      end
    end

    context "for a non-member" do
      it "does not display the draft_pick modal" do
        get :show, id: league.id, h: league.hmac, member: member.id

        response.body.should_not include "You've joined #{league.name}"
      end
    end
  end

  describe "GET 'show' during draft with draft_pick parameter" do
    render_views
    before(:each) { @request.host = "nfl.test.host" }

    let(:league) { FactoryGirl.create(:league, commissioner: commissioner) }
    let(:draft_pick) { league.draft_picks.first }

    before :each do
      league.members << FactoryGirl.create(:user)
      DraftGenerator.new(league).generate_picks!
    end

    context "for a selected draft_pick" do
      before :each do
        draft_pick.pick_team(NFLTeam::ARIZONA_CARDINALS)
      end

      it "displays the draft_pick modal" do
        get :show, id: league.id, h: league.hmac, draft_pick: draft_pick.id

        response.body.should include "You picked the Arizona Cardinals 1st"
      end
    end

    context "for an unselected draft_pick" do
      it "does not display the draft_pick modal" do
        get :show, id: league.id, h: league.hmac, draft_pick: draft_pick.id

        response.body.should_not include "You picked the Arizona Cardinals 1st"
      end
    end
  end
end
