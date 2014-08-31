require "spec_helper"

describe DraftPickModalDecorator do
  let(:draft_pick) { FactoryGirl.create(:draft_pick) }
  let(:request) { double(host: "host") }
  subject { described_class.new(draft_pick, request) }

  its(:url) { should include("h=#{draft_pick.league.hmac}") }
end
