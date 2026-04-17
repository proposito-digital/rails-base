require 'rails_helper'

RSpec.describe DogPolicy, type: :policy do
  let(:actor) { build(:user) }
  let(:record) { build(:dog) }

  describe ".scope" do
    it "returns all dogs" do
      dog_a = create(:dog, name: "Alpha")
      dog_b = create(:dog, name: "Beta")

      resolved_scope = described_class::Scope.new(actor, Dog).resolve

      expect(resolved_scope).to include(dog_a, dog_b)
      expect(resolved_scope.count).to eq(Dog.count)
    end
  end

  describe "permissions" do
    subject(:policy) { described_class.new(actor, record) }

    it "allows show" do
      expect(policy.show?).to be(true)
    end

    it "allows create" do
      expect(policy.create?).to be(true)
    end

    it "allows update" do
      expect(policy.update?).to be(true)
    end

    it "allows destroy" do
      expect(policy.destroy?).to be(true)
    end
  end
end
