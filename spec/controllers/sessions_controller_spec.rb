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
      it "logs in the user" do
        post :create, {
          'email' => user.email,
          'password' => "password",
        }

        cookies[:auth_token].should == user.auth_token
      end

      it "redirects to the home page" do
        post :create, {
          'email' => user.email,
          'password' => "password",
        }

        expect(response).to redirect_to("/")
      end

      context "and redirect_to specified" do
        it "redirects to specified path" do
          post :create, {
            'redirect_to' => '/leagues/1',
            'email' => user.email,
            'password' => "password",
          }

          expect(response).to redirect_to('/leagues/1')
        end
      end
    end

    context "with valid email of different case" do
      let!(:user) { FactoryGirl.create(:user, email: "example@example.com") }

      it "logs in the user" do
        post :create, {
          'email' => "EXAMPLE@EXAMPLE.COM",
          'password' => "password",
        }

        cookies[:auth_token].should == user.auth_token
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

  describe "DELETE 'destory" do
    let!(:user) { FactoryGirl.create(:user) }

    before :each do
      post :create, email: user.email, password: 'password'
    end

    it "logs out the user" do
      cookies[:auth_token].should == user.auth_token

      delete :destroy, id: 'current'

      cookies[:auth_token].should be_nil
    end
  end
end
