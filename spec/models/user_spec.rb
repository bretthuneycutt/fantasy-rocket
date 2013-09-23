require 'spec_helper'

describe User do
  subject { FactoryGirl.create(:user) }

  it_behaves_like "a FactoryGirl class"

  it "downcases email on create" do
    user = FactoryGirl.create(:user, email: "EXAMPLE@EXAMPLE.com")
    user.email.should == "example@example.com"
  end

  it "strips email on create" do
    user = FactoryGirl.create(:user, email: "example@example.com  ")
    user.email.should == "example@example.com"
  end

  it "generates a unique user token on create" do
    user1 = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user)

    user1.auth_token.length.should >= 22
    user2.auth_token.length.should >= 22
    user1.auth_token.should_not == user2.auth_token
  end

  describe "#assimilate_user!" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:other_user) { FactoryGirl.create(:user) }
    let!(:league) { FactoryGirl.create(:league, commissioner: other_user) }
    let(:league_membership) { league.league_memberships.first }
    let!(:draft_pick) { FactoryGirl.create(:draft_pick, league: league, member: other_user) }

    it "reassigns all commissionerships, memberships and draft picks" do
      league.commissioner.should == other_user
      league_membership.member.should == other_user
      draft_pick.member.should == other_user

      user.assimilate_user!(other_user)

      league.reload.commissioner.should == user
      league_membership.reload.member.should == user
      draft_pick.reload.member.should == user
    end

    it "destroys other user" do
      other_user.should_not be_destroyed

      user.assimilate_user!(other_user)

      other_user.should be_destroyed
    end
  end

  context "with multiple cancelled subscriptions" do
    let!(:canceled1) { FactoryGirl.create(:subscription, user: subject, canceled_at: 1.year.ago) }
    let!(:canceled2) { FactoryGirl.create(:subscription, user: subject, canceled_at: 1.day.ago) }
    let!(:canceled3) { FactoryGirl.create(:subscription, user: subject, canceled_at: 6.months.ago) }

    its(:canceled_subscription) { should == canceled2 }
  end

  describe "#subsciber?" do
    it { should_not be_subscriber }

    context "with a subscription" do
      let!(:subscription) { FactoryGirl.create(:subscription, user: subject) }

      it { should be_subscriber }
    end

    context "with a canceled subscription" do
      let!(:canceled_subscription) { FactoryGirl.create(:canceled_subscription, user: subject) }

      it { should_not be_subscriber }
    end

    context "with a canceled subscription that ends in the future" do
      let!(:canceled_subscription) { FactoryGirl.create(:canceled_subscription, user: subject, expires_at: 1.week.from_now) }

      it { should be_subscriber }
    end

    context "with a canceled subscription that ended in the past" do
      let!(:canceled_subscription) { FactoryGirl.create(:canceled_subscription, user: subject, expires_at: 1.week.ago) }

      it { should_not be_subscriber }
    end
  end
end
