require "spec_helper"

describe DraftMailer do
  let(:user) { FactoryGirl.create(:user) }
  let(:league) { FactoryGirl.create(:league) }

  describe "#start_email" do
    before :each do
      league.members << user
      DraftGenerator.new(league).generate_picks!
    end

    subject { DraftMailer.start_email(user, league) }

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

  describe "#pick_made_email" do
    before :each do
      league.members << user
      DraftGenerator.new(league).generate_picks!
      league.draft.current_pick.pick_team(Team::ARIZONA_CARDINALS)
    end

    subject { DraftMailer.pick_made_email(user, league) }

    it 'sets the subject correctly' do
      subject.subject.should == "Arizona Cardinals has been selected! #{league.draft.current_picker.name} is up!"
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

  describe "#draft_complete_email" do
    before :each do
      league.members << user
      DraftGenerator.new(league).generate_picks!
      league.draft.picks.each_with_index do |pick, i|
        pick.pick_team(i + 1)
      end
    end

    subject { DraftMailer.draft_complete_email(user, league) }

    it 'sets the subject correctly' do
      subject.subject.should == "Draft for #{league.name} is now complete!"
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
