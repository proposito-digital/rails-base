require 'rails_helper'

RSpec.describe Admin::DogsHelper, type: :helper do
  describe "#admin_index_display_value" do
    it "translates booleans using shared labels" do
      expect(helper).to receive(:translate_view_shared).with("yes_display").and_return("Sim")
      expect(helper.admin_index_display_value(true)).to eq("Sim")

      expect(helper).to receive(:translate_view_shared).with("no_display").and_return("Não")
      expect(helper.admin_index_display_value(false)).to eq("Não")
    end

    it "returns dash for blank values" do
      expect(helper.admin_index_display_value(nil)).to eq("-")
      expect(helper.admin_index_display_value("")).to eq("-")
    end
  end

  describe "#admin_index_search_applied?" do
    it "returns false when no term is provided" do
      allow(helper).to receive(:params).and_return(ActionController::Parameters.new)

      expect(helper.admin_index_search_applied?).to be(false)
    end
  end
end
