require 'spec_helper'

describe League do
  it_behaves_like "a FactoryGirl class"

  subject { FactoryGirl.build(:league) }

  it "adds the commissionser as a member after create" do
    subject.save!

    subject.members.should include subject.commissioner
  end
end
