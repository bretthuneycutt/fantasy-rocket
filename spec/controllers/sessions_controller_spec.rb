require 'spec_helper'

describe SessionsController do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'" do
    let!(:user) { FactoryGirl.create(:user) }

    context "with valid email and password" do
      it "redirects to the home page" do
        post :create, {
          'email' => user.email,
          'password' => "password",
        }

        expect(response).to redirect_to("/")
      end
    end

    context "with invalid password" do
      it "renders the new template with errors" do
        post :create, {
          'email' => user.email,
          'password' => "invalid-password",
        }

        expect(response).to render_template("new")
      end

    end
  end
end
