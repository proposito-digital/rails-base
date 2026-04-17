require "rails_helper"

RSpec.describe Admin::BaseHelper, type: :helper do
  describe "#admin_index_no_results_search_message" do
    it "builds no-results message using plural model translation" do
      allow(helper).to receive(:model_plural_translation).and_return("Users")
      expect(helper).to receive(:translate_view_index).with("no_results_search", model_name: "users").and_return("Nenhum resultado")

      expect(helper.admin_index_no_results_search_message).to eq("Nenhum resultado")
    end
  end
end
