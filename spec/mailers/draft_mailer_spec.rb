require "spec_helper"

describe DraftMailer do
  let(:user) { FactoryGirl.create(:user) }
  let(:league) { FactoryGirl.create(:league) }

  describe "#start_email" do
    before :each do
      league.members << user
      DraftGenerator.new(league).generate_picks!
    end

    subject { DraftMailer.start_email(user.id, league.id) }

    it 'sets the subject correctly' do
      subject.subject.should == "Your NFL Wins Pool draft has started! #{league.draft.current_picker.name} is up!"
    end

    it 'sends to the correct recipient' do
      subject.to.should == [user.email]
    end

    it 'sends from the correct sender address' do
      subject.from.should == ['hi@fantasyrocket.com']
    end

    it 'includes league url in the body' do
      subject.body.encoded.should include league_url(league)
    end
  end
end
