require "rails_helper"

RSpec.describe Admin::BaseController do
  subject(:base_controller) { described_class.new }

  before do
    base_controller.instance_variable_set(:@model, User)
  end

  describe "default filter fields" do
    it "returns model columns except forbidden ones and is reused by filter_fields" do
      columns = base_controller.send(:default_filter_columns)

      expect(columns).to include("email_address")
      expect(columns).not_to include("id", "deleted_at", "created_at", "updated_at", "password_digest")
      expect(base_controller.send(:filter_fields)).to eq(columns)
    end
  end

  describe "default sort fields" do
    it "returns model columns except forbidden ones and is reused by sort_fields" do
      columns = base_controller.send(:default_sort_fields)

      expect(columns).to include("email_address", "created_at", "updated_at")
      expect(columns).not_to include("id", "deleted_at", "password_digest")
      expect(base_controller.send(:sort_fields)).to eq(columns)
    end
  end

  describe "default params" do
    it "returns an empty permitted params list" do
      expect(base_controller.send(:default_params_permited)).to eq([])
    end
  end
end
