require 'spec_helper'

describe PasswordResetsController do
  before(:each) { request.env['HTTPS'] = 'on' }

  describe "POST 'create'" do
    context "if the user exists" do
      let!(:user) { FactoryGirl.create(:user) }

      it "generates password token" do
        user.password_reset_token.should be_nil
        user.password_reset_sent_at.should be_nil

        post :create, {email: user.email}

        user.reload
        user.password_reset_token.should_not be_nil
        user.password_reset_sent_at.should > 1.minute.ago
        user.password_reset_sent_at.should < Time.now
      end

      it "emails the user" do
        post :create, {email: user.email}

        email = ActionMailer::Base.deliveries.last
        email.to.should == [user.email]
        email.subject.should == "Password Reset"
      end
    end

    it "redirects to the root_url" do
      post :create, email: "random@example.com"

      expect(response).to redirect_to(root_url)
    end
  end

  describe "GET 'edit'" do
    context "when the password_reset_token exists" do
      let!(:user) { FactoryGirl.create(:user_with_password_reset_token) }

      it "displays the edit template" do
        get :edit, id: user.password_reset_token

        expect(response).to render_template('edit')
      end
    end

    context "when the password_reset_token does not exist" do
      it "returns 404" do
        get :edit, id: "random-token"

        response.should be_not_found
      end
    end
  end

  describe "PUT 'update'" do
    context "for user with valid reset token" do
      let!(:user) { FactoryGirl.create(:user_with_password_reset_token) }

      it "resets the password" do
        put :update, id: user.password_reset_token, user: {
          password: "new-password",
          password_confirmation: "new-password",
        }

        user.reload.authenticate("new-password").should be_truthy
      end

      it "redirects to the root url" do
        put :update, id: user.password_reset_token, user: {
          password: "new-password",
          password_confirmation: "new-password",
        }

        expect(response).to redirect_to(root_url)
      end

      context "with invalid password" do
        it "renders edit page" do
          put :update, id: user.password_reset_token, user: {
            password: "new-password",
            password_confirmation: "invalid",
          }

          expect(response).to render_template(:edit)
        end
      end
    end

    context "for user with expired reset token" do
      let!(:user) { FactoryGirl.create(:user_with_password_reset_token, password_reset_sent_at: 12.hours.ago) }

      it "does not update the password" do
        put :update, id: user.password_reset_token, user: {
          password: "new-password",
          password_confirmation: "new-password",
        }

        user.reload.authenticate("new-password").should be_falsey
      end

      it "redirects to new_password_reset path" do
        put :update, id: user.password_reset_token, user: {
          password: "new-password",
          password_confirmation: "new-password",
        }

        expect(response).to redirect_to(new_password_reset_url)
      end
    end
  end
end
