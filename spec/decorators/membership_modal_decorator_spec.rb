require "spec_helper"

describe MembershipModalDecorator do
  let(:membership) { FactoryGirl.create(:league_membership) }
  let(:request) { double(host: "host") }
  subject { described_class.new(membership, request) }

  its(:url) { should include("h=#{membership.league.hmac}") }
end
