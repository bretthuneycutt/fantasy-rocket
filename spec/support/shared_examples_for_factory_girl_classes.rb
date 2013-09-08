shared_examples "a FactoryGirl class" do
  def factory
    FactoryGirl.build(described_class.to_s.underscore.to_sym)
  end

  context "an instantiated factory" do
    subject { factory }
    it { should be_valid }
  end

  context "two factories that are saved" do
    let(:model1) { factory.tap(&:save!) }
    let(:model2) { factory.tap(&:save!) }

    it "are persisted" do
      model1.should be_persisted
      model2.should be_persisted
    end
  end
end
