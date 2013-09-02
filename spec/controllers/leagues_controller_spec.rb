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

        expect(response).to redirect_to("/")
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
end
