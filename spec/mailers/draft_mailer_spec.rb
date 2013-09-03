require "spec_helper"

describe DraftMailer do
  let(:user) { FactoryGirl.create(:user) }
  let(:league) { FactoryGirl.create(:league) }

  describe "#start_email" do
    subject { DraftMailer.start_email(user.id, league.id) }

    it 'sets the subject correctly' do
      # TODO test DraftEmailSubject class
      subject.subject.should == "FantasyRocket draft update"
    end

    it 'sends to the correct recipient' do
      subject.to.should == [user.email]
    end

    it 'sends from the correct sender address' do
      subject.from.should == ['hi@fantasyrocket.com']
    end

    it 'assigns @user, @league, @draft' do
      subject.body.encoded.should match(user)
      subject.body.encoded.should match(league)
      subject.body.encoded.should match(league.draft)
    end

    it 'includes league url in the body' do
      subject.body.encoded.should include league_url(league)
    end
  end
end
