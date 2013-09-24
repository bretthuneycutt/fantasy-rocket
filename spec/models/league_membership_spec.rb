require 'spec_helper'

describe LeagueMembership do
  it_behaves_like "a FactoryGirl class"

  subject { FactoryGirl.create(:league_membership) }

  its(:default_tweet) { should == "I joined #{subject.league.name} #winspool"}
end
