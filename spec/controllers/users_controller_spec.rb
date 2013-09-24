require 'spec_helper'

describe UsersController do
  before(:each) { request.env['HTTPS'] = 'on' }

  describe "POST create" do
    context "with valid parameters" do
      it "redirects to create a new league" do
        post :create, 'user' => {
          'name' => "Peter GeGe",
          'email' => 'peter@geegee.com',
          'password' => 'password',
          'password_confirmation' => 'password',
        }

        expect(response).to redirect_to(new_league_url)
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

  describe "GET 'edit'" do
    def go!
      get :edit
    end

    it_behaves_like "endpoint that requires logged in user"

    context "when logged in" do
      let(:user) { FactoryGirl.create(:user) }
      before(:each) { request.cookies[:auth_token] = user.auth_token }

      it "renders the edit page" do
        go!

        response.should render_template(:edit)
      end
    end
  end

  describe "PUT 'update'" do
    def go!(options = {})
      put :update, user: options
    end

    it_behaves_like "endpoint that requires logged in user"

    context "when logged in" do
      let(:user) { FactoryGirl.create(:user) }
      before(:each) { request.cookies[:auth_token] = user.auth_token }

      context "with invalid email" do
        let(:options) { {email: "invalid"} }

        it "renders edit template" do
          go!(options)

          response.should render_template(:edit)
        end

        it "does not update the user" do
          old_email = user.email

          go!(options)

          user.reload.email.should == old_email
        end

        it "displays errors" do
          go!(options)

          assigns(:current_user).errors.should_not be_empty
        end
      end

      context "with valid email and name values and empty string password and confirmation" do
        let(:options) { {name: "Rudy Poo", email: "rudy@poo.com", password: "", password_confirmation: ""} }

        it "updates email and name values" do
          go!(options)

          user.reload
          user.name.should == "Rudy Poo"
          user.email.should == "rudy@poo.com"
        end

        it "does not change the password" do
          user.authenticate("password").should be_true

          go!(options)

          user.reload.authenticate("password").should be_true
        end

        it "redirects to the root url" do
          go!(options)

          response.should redirect_to root_url
        end
      end

      context "with new password values" do
        let(:options) { {password: "yoyoyoyo", password_confirmation: "yoyoyoyo"} }

        it "updates the password" do
          user.authenticate("yoyoyoyo").should be_false

          go!(options)

          user.reload.authenticate("yoyoyoyo").should be_true
        end
      end
    end
  end
end
