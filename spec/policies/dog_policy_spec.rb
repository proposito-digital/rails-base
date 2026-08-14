require 'rails_helper'

RSpec.describe DogPolicy, type: :policy do
  let(:record) { build(:dog) }

  it_behaves_like 'admin-only policy'

  describe '.scope' do
    it 'returns all dogs for an admin' do
      dog_a = create(:dog, name: 'Alpha')
      dog_b = create(:dog, name: 'Beta')

      resolved_scope = described_class::Scope.new(build(:user, :admin), Dog).resolve

      expect(resolved_scope).to include(dog_a, dog_b)
    end

    it 'returns no dogs for a regular user' do
      create(:dog)

      resolved_scope = described_class::Scope.new(build(:user), Dog).resolve

      expect(resolved_scope).to be_empty
    end
  end
end
