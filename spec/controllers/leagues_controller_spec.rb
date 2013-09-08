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
      it "renders the new template with errors" do
        post :create, 'league' => {
          'name' => "League name",
        }

        expect(response).to redirect_to(league_path(assigns(:league)))
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
      end
    end
  end
end
