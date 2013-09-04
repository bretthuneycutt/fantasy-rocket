require 'spec_helper'

describe HMAC do
  describe ".id" do
    it "returns correct hmac key" do
      HMAC.id("1").should == "e2a832"
    end
  end
end
