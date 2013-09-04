require 'spec_helper'

describe UsersController do
  describe "POST create" do
    context "with valid parameters" do
      it "redirects to create a new league" do
        post :create, 'user' => {
          'name' => "Peter GeGe",
          'email' => 'peter@geegee.com',
          'password' => 'password',
          'password_confirmation' => 'password',
        }

        expect(response).to redirect_to(new_league_path)
      end

      context "with league_id specified" do
        let(:league) { FactoryGirl.create(:league) }

        context "with valid hmac" do
          it "adds the created user to the league" do
            post :create, {
              'league_id' => league.id,
              'h' => league.hmac,
              'user' => {
                'name' => "Peter GeGe",
                'email' => 'peter@geegee.com',
                'password' => 'password',
                'password_confirmation' => 'password',
              },
            }

            league.members.should include assigns(:user)
          end
        end

        context "with invalid hmac" do
          it "does not add the created user to the league" do
            post :create, {
              'league_id' => league.id,
              'user' => {
                'name' => "Peter GeGe",
                'email' => 'peter@geegee.com',
                'password' => 'password',
                'password_confirmation' => 'password',
              },
            }

            league.members.should_not include assigns(:user)
          end
        end
      end

      context "and redirect_to specified" do
        it "redirects to specified path" do
          post :create, 'redirect_to' => '/', 'user' => {
            'name' => "Peter GeGe",
            'email' => 'peter@geegee.com',
            'password' => 'password',
            'password_confirmation' => 'password',
          }

          expect(response).to redirect_to('/')
        end
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
