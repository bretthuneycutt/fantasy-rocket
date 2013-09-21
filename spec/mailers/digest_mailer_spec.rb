require "spec_helper"

describe DigestMailer do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:league) { FactoryGirl.create(:league) }
  let(:week) { 1 }

  before :each do
    league.members << user
    DraftGenerator.new(league).generate_picks!

    FactoryGirl.create(:draft_pick, league: league, member: user, team_id: 1)
    FactoryGirl.create(:regular_season_game, winner_id: 1, week: 1)
  end

  describe "#weekly_summary" do
    subject { DigestMailer.weekly_summary(week, league) }

    it 'sets the subject correctly' do
      subject.subject.should == "Week #{week} standings - #{league.name}"
    end

    it 'sends to the correct recipient' do
      subject.to.size.should == 2
      subject.to.should == league.members.map(&:email)
    end

    it 'sends from the correct sender address' do
      subject.from.should == ['hi@fantasyrocket.com']
    end

    it 'includes league url in the body' do
      subject.body.encoded.should include league_url(league, h: league.hmac, subdomain: league.subdomain)
    end

    it 'includes the current pool standings' do
      subject.body.encoded.should include "1. #{user.name} - 1 win"
      subject.body.encoded.should include "2. #{league.commissioner.name} - 0 wins"
    end
  end
end
