require "rails_helper"

RSpec.describe NameHelper, type: :helper do
  describe "#singular_model_name" do
    it "returns singular form from controller path" do
      allow(helper).to receive(:params).and_return(ActionController::Parameters.new(controller: "admin/users"))
      helper.singleton_class.define_method(:singularize) { |value| value.singularize }

      expect(helper.singular_model_name).to eq("user")
    end
  end

  describe "#model_plural_name_to_sort" do
    it "returns slash-safe plural model name" do
      namespaced_model = Class.new
      stub_const("Admin::Widget", namespaced_model)
      helper.instance_variable_set(:@model, Admin::Widget)

      expect(helper.model_plural_name_to_sort).to eq("admin_widgets")
    end
  end

  describe "#custom_model_singular_translation" do
    it "translates singular key for provided model name" do
      expect(helper).to receive(:t).with("admin/user.single").and_return("Usuário")

      expect(helper.custom_model_singular_translation("admin/user")).to eq("Usuário")
    end
  end

  describe "#custom_model_plural_translation" do
    it "translates plural key for provided class-like model name" do
      expect(helper).to receive(:t).with("admin/users.plural").and_return("Usuários")

      expect(helper.custom_model_plural_translation("Admin::User")).to eq("Usuários")
    end
  end

  describe "#model_column_names_only" do
    it "returns only requested columns from model" do
      helper.instance_variable_set(:@model, User)

      expect(helper.model_column_names_only(%w[email_address password_digest])).to match_array(%w[email_address password_digest])
    end
  end

  describe "#model_singular_name_to_translate" do
    it "falls back to underscored class name when model_name is unavailable" do
      legacy_class = Class.new
      stub_const("LegacyEntity", legacy_class)

      expect(helper.model_singular_name_to_translate(LegacyEntity.new)).to eq("legacy_entity")
    end
  end
end
