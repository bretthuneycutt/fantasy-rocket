require 'spec_helper'

describe League do
  it_behaves_like "a FactoryGirl class"

  subject { FactoryGirl.build(:league, id: 100) }

  it "adds the commissionser as a member after create" do
    subject.save!

    subject.members.should include subject.commissioner
  end

  its(:hmac) { should == "e1ebb8" }

  describe "#add_member" do
    before(:each) { subject.save! }
    let(:user) { FactoryGirl.create(:user) }

    context "when user is already a member" do
      it "does not add the member a second time" do
        subject.members << user

        subject.members.should include user

        subject.add_member(user)

        subject.members.should include user
        subject.members.select {|m| m == user}.size.should == 1
      end
    end

    context "when member limit has been reached" do
      it "does not add the member" do
        (League::MEMBER_LIMIT - 1).times { subject.members << FactoryGirl.create(:user) }

        subject.add_member(user)

        subject.members.should_not include user
      end
    end

    context "when user is not member and limit has not been reached" do
      it "adds member" do
        subject.members.should_not include user

        subject.add_member(user)

        subject.members.should include user
      end
    end
  end

  context "for NFL" do
    subject { FactoryGirl.build(:nfl_league, id: 100) }

    its(:team_class) { should == NFLTeam }
  end

  context "for NBA" do
    subject { FactoryGirl.build(:nba_league, id: 100) }

    its(:team_class) { should == NBATeam }
  end

  describe "#default_tweet" do
    subject { FactoryGirl.create(:league) }
    let(:member) { FactoryGirl.create(:user) }
    before :each do
      subject.members << member
      Standing.any_instance.stub(:rank) { 2 }
    end

    it "returns sentence with ranking" do
      subject.default_tweet(member).should == "I'm 2nd in my NFL wins pool"
    end
  end

  context "when a win hasn't been registered" do
    it { should_not be_season_started }
  end

  context "when a win has been registered" do
    before(:each) { FactoryGirl.create(:regular_season_game) }

    it { should be_season_started }
  end
end
