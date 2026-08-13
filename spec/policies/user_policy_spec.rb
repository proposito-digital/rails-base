require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  let(:record) { build(:user) }

  it_behaves_like 'admin-only policy'

  describe '.scope' do
    it 'returns all users for an admin' do
      user_a = create(:user)
      user_b = create(:user)

      resolved_scope = described_class::Scope.new(build(:user, :admin), User).resolve

      expect(resolved_scope).to include(user_a, user_b)
    end

    it 'returns no users for a regular user' do
      create(:user)

      resolved_scope = described_class::Scope.new(build(:user), User).resolve

      expect(resolved_scope).to be_empty
    end
  end
end