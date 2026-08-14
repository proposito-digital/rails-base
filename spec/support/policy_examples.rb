require 'rails_helper'

RSpec.shared_examples 'admin-only policy' do
  let(:record) { build(described_class.name.delete_suffix('Policy').underscore) }
  let(:admin) { build(:user, :admin) }
  let(:regular_user) { build(:user) }

  it 'allows every administrative action for an admin' do
    policy = described_class.new(admin, record)

    expect(policy.menu?).to be(true)
    expect(policy.index?).to be(true)
    expect(policy.show?).to be(true)
    expect(policy.create?).to be(true)
    expect(policy.update?).to be(true)
    expect(policy.destroy?).to be(true)
  end

  it 'denies every administrative action for a regular user' do
    policy = described_class.new(regular_user, record)

    expect(policy.menu?).to be(false)
    expect(policy.index?).to be(false)
    expect(policy.show?).to be(false)
    expect(policy.create?).to be(false)
    expect(policy.update?).to be(false)
    expect(policy.destroy?).to be(false)
  end
end
