require "rails_helper"

RSpec.describe PasswordsMailer, type: :mailer do
  describe "#reset" do
    let(:user) { create(:user) }

    it "builds the reset email with expected headers and body" do
      mail = described_class.reset(user)

      expect(mail.subject).to eq("Reset your password")
      expect(mail.to).to eq([ user.email_address ])
      expect(mail.from).to eq([ "from@example.com" ])
      expect(mail.body.encoded).to include("this password reset page")
      expect(mail.body.encoded).to include("/passwords/")
      expect(mail.body.encoded).to include("/edit")
    end
  end
end
