require 'rails_helper'

RSpec.describe User, type: :model do
  it "normalizes email_address before validation" do
    user = create(:user, email_address: "  USER@Example.COM  ")

    expect(user.email_address).to eq("user@example.com")
  end

  it "removes sessions when the user is destroyed" do
    user = create(:user)
    session = user.sessions.create!(ip_address: "127.0.0.1", user_agent: "RSpec")

    expect { user.destroy }.to change(Session, :count).by(-1)
    expect(Session.exists?(session.id)).to be(false)
  end
end
