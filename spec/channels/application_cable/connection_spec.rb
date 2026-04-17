require "rails_helper"

RSpec.describe ApplicationCable::Connection, type: :channel do
  subject(:connection) { described_class.allocate }

  describe "#set_current_user" do
    it "assigns current_user from signed session cookie when session exists" do
      user = create(:user)
      user_session = user.sessions.create!(ip_address: "127.0.0.1", user_agent: "RSpec")

      allow(connection).to receive(:cookies).and_return(double(signed: { session_id: user_session.id }))
      allow(connection).to receive(:current_user=) do |value|
        connection.instance_variable_set(:@current_user, value)
      end

      result = connection.send(:set_current_user)

      expect(result).to eq(user)
      expect(connection.instance_variable_get(:@current_user)).to eq(user)
    end

    it "returns nil when no session is found" do
      allow(connection).to receive(:cookies).and_return(double(signed: { session_id: -1 }))

      expect(connection.send(:set_current_user)).to be_nil
    end
  end

  describe "#connect" do
    it "does not reject when set_current_user returns a user" do
      allow(connection).to receive(:set_current_user).and_return(create(:user))
      expect(connection).not_to receive(:reject_unauthorized_connection)

      connection.connect
    end

    it "rejects when set_current_user returns nil" do
      allow(connection).to receive(:set_current_user).and_return(nil)
      expect(connection).to receive(:reject_unauthorized_connection).and_return(:rejected)

      expect(connection.connect).to eq(:rejected)
    end
  end
end
