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
end
