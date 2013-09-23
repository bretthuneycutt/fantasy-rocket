shared_examples "endpoint that requires logged in user" do
  context "if logged out" do
    it "returns 404" do
      go!

      response.should be_not_found
    end
  end
end
