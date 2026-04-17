require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  let(:actor) { build(:user) }
  let(:record) { build(:user) }

  describe ".scope" do
    it "returns all users" do
      user_a = create(:user)
      user_b = create(:user)

      resolved_scope = described_class::Scope.new(actor, User).resolve

      expect(resolved_scope).to include(user_a, user_b)
      expect(resolved_scope.count).to eq(User.count)
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
