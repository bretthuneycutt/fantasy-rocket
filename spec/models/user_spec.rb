require 'spec_helper'

describe User do
  it_behaves_like "a FactoryGirl class"

  it "downcases email on create" do
    user = FactoryGirl.create(:user, email: "EXAMPLE@EXAMPLE.com")
    user.email.should == "example@example.com"
  end
end
