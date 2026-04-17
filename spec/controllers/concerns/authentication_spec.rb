require "rails_helper"

RSpec.describe Authentication do
  describe "#authenticated?" do
    it "delegates to resume_session" do
      controller = ApplicationController.new
      allow(controller).to receive(:resume_session).and_return(:active_session)

      expect(controller.send(:authenticated?)).to eq(:active_session)
    end
  end
end
