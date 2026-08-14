require "rails_helper"

RSpec.describe DashboardPolicy, type: :policy do
  let(:record) { :dashboard }

  it "allows an authenticated user to access the dashboard" do
    policy = described_class.new(build(:user), record)

    expect(policy.menu?).to be(true)
    expect(policy.index?).to be(true)
  end

  it "denies an unauthenticated user" do
    policy = described_class.new(nil, record)

    expect(policy.menu?).to be(false)
    expect(policy.index?).to be(false)
  end
end
