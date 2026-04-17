require 'rails_helper'

RSpec.describe Admin::UsersHelper, type: :helper do
  describe "#admin_index_search_term" do
    it "returns the search term from params" do
      allow(helper).to receive(:params).and_return(ActionController::Parameters.new(term: "john@example.com"))

      expect(helper.admin_index_search_term).to eq("john@example.com")
    end
  end

  describe "#admin_index_search_applied?" do
    it "returns true when term is present" do
      allow(helper).to receive(:params).and_return(ActionController::Parameters.new(term: "john@example.com"))

      expect(helper.admin_index_search_applied?).to be(true)
    end

    it "returns false when term is blank" do
      allow(helper).to receive(:params).and_return(ActionController::Parameters.new(term: "   "))

      expect(helper.admin_index_search_applied?).to be(false)
    end
  end
end
