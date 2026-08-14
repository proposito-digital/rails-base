require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  let(:record) { build(:user) }

  it_behaves_like 'admin-only policy'

  describe '.scope' do
    it 'returns active users for an admin' do
      active_user = create(:user)
      deactivated_user = create(:user, deleted_at: Time.current)

      resolved_scope = described_class::Scope.new(build(:user, :admin), User).resolve

      expect(resolved_scope).to include(active_user)
      expect(resolved_scope).not_to include(deactivated_user)
    end

    it 'returns no users for a regular user' do
      create(:user)

      resolved_scope = described_class::Scope.new(build(:user), User).resolve

      expect(resolved_scope).to be_empty
    end
  end
end
