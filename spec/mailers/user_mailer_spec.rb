require "spec_helper"

describe UserMailer do
  describe "#password_reset" do
    let!(:user) { FactoryGirl.create(:user_with_password_reset_token) }

    subject { UserMailer.password_reset(user) }

    it 'sets the subject correctly' do
      subject.subject.should == "Password Reset"
    end

    it 'sends to the correct recipient' do
      subject.to.should == [user.email]
    end

    it 'sends from the correct sender address' do
      subject.from.should == ['hi@fantasyrocket.com']
    end

    it 'includes link to reset password' do
      subject.body.encoded.should include edit_password_reset_url(user.password_reset_token)
    end
  end

end
