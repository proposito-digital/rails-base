require "rails_helper"

RSpec.describe Translations::TranslationsViewHelper do
  subject(:context) { context_class.new }

  let(:context_class) do
    Class.new do
      include Translations::TranslationsViewHelper
      attr_accessor :controller

      def t(path, **_params)
        path
      end
    end
  end

  before do
    context.controller = Admin::DogsController.new
  end

  describe "#base_translate_view_controller_path" do
    it "builds translation path using controller namespace" do
      allow(context).to receive(:translation_view_path).and_return("admin.dogs")
      expect(context).to receive(:base_translate_view).with("admin.dogs.actions.index.title", {}).and_return("ok")

      expect(context.base_translate_view_controller_path("actions.index.title")).to eq("ok")
    end
  end

  describe "#translate_view" do
    it "returns controller translation when present" do
      allow(context).to receive(:base_translate_view_controller_path).and_return("Controller text")

      expect(context.translate_view("shared.label")).to eq("Controller text")
    end

    it "falls back to application translation when controller translation is blank" do
      allow(context).to receive(:base_translate_view_controller_path).and_return("")
      allow(context).to receive(:base_translate_view_application_path).and_return("Fallback text")

      expect(context.translate_view("shared.label")).to eq("Fallback text")
    end
  end

  describe "wrappers" do
    it "delegates actions and shared wrappers" do
      expect(context).to receive(:translate_view).with("actions.index.title", {}).and_return("Index")
      expect(context.translate_view_actions("index.title")).to eq("Index")

      expect(context).to receive(:translate_view).with("shared.badge", {}).and_return("Shared")
      expect(context.translate_view_shared("badge")).to eq("Shared")
    end

    it "delegates index/new/edit/show/destroy wrappers" do
      expect(context).to receive(:translate_view_actions).with("index.header", {}).and_return("Header")
      expect(context.translate_view_index("header")).to eq("Header")

      expect(context).to receive(:translate_view_actions).with("new.header", {}).and_return("Header")
      expect(context.translate_view_new("header")).to eq("Header")

      expect(context).to receive(:translate_view_actions).with("edit.header", {}).and_return("Header")
      expect(context.translate_view_edit("header")).to eq("Header")

      expect(context).to receive(:translate_view_actions).with("show.header", {}).and_return("Header")
      expect(context.translate_view_show("header")).to eq("Header")

      expect(context).to receive(:translate_view_actions).with("destroy.header", {}).and_return("Header")
      expect(context.translate_view_destroy("header")).to eq("Header")
    end
  end

  describe "#translation_view_path" do
    it "builds dotted path from controller class name" do
      expect(context.translation_view_path).to eq("admin.dogs")
    end
  end
end
