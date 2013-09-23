require 'spec_helper'

describe Subscription do
  it_behaves_like "a FactoryGirl class"

  subject { FactoryGirl.create(:subscription) }

  context "for a user with a cancelled subscription" do
    let!(:canceled_subsciption) { FactoryGirl.create(:canceled_subscription) }
    subject { FactoryGirl.create(:subscription, user: canceled_subsciption.user) }

    it { should be_persisted }
  end

  it { should_not be_canceled }

  context "that is canceled" do
    subject { FactoryGirl.create(:canceled_subscription) }

    it { should be_canceled }
  end

  describe "#cancel!" do
    it "sets canceled_at to current_time" do
      subject.should_not be_canceled

      subject.cancel!

      subject.should be_canceled
      subject.canceled_at.should < Time.now
      subject.canceled_at.should > 30.seconds.ago
    end
  end

  describe "#expired?" do
    it { should_not be_expired }

    context "that is canceled" do
      subject { FactoryGirl.create(:canceled_subscription) }

      it { should be_expired }
    end

    context "that is canceled and expires in the future" do
      subject { FactoryGirl.create(:canceled_subscription, expires_at: 1.week.from_now) }

      it { should_not be_expired }
    end

    context "that is canceled and already expired" do
      subject { FactoryGirl.create(:canceled_subscription, expires_at: 1.week.ago) }

      it { should be_expired }
    end
  end
end
