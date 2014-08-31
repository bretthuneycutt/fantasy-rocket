require "spec_helper"

describe SeasonMailer do
  let(:user) { FactoryGirl.create(:user) }
  let!(:league) { FactoryGirl.create(:league) }
  let!(:new_league) { FactoryGirl.create(:league, previous: league) }

  describe "#start_email" do
    before :each do
      league.members << user
      league.reload
    end

    subject { SeasonMailer.new_season(league) }

    it 'sets the subject correctly' do
      subject.subject.should == "2014 season: #{league.name}!"
    end

    it 'sends to the correct recipient' do
      subject.to.should == league.members.map(&:email)
    end

    it 'sends from the correct sender address' do
      subject.from.should == ['hi@fantasyrocket.com']
    end

    it 'includes league url in the body' do
      subject.body.encoded.should include league_url(new_league, h: new_league.hmac, subdomain: new_league.subdomain)
    end
  end
end
