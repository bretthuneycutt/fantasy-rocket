require 'spec_helper'

describe User do
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
end
