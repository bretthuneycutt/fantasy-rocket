require 'spec_helper'

describe UsersController do
  describe "POST create" do
    context "with valid parameters" do
      it "renders the new template with errors" do
        post :create, 'user' => {
          'name' => "Peter GeGe",
          'email' => 'peter@geegee.com',
          'password' => 'password',
          'password_confirmation' => 'password',
        }

        expect(response).to redirect_to(new_league_path)
      end
    end

    context "with missing name and password" do
      it "renders the new template with errors" do
        post :create, 'user' => {
          'email' => 'peter@geegee.com',
        }

        expect(response).to render_template("new")
      end
    end
  end
end
