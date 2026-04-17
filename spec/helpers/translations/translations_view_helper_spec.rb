require "rails_helper"

RSpec.describe Translations::TranslationsViewHelper, type: :helper do
  describe "#base_translate_view_controller_path" do
    it "builds translation path using controller path" do
      allow(helper).to receive(:translation_view_path).and_return("admin.dogs")
      expect(helper).to receive(:base_translate_view).with("admin.dogs.actions.index.title", {}).and_return("ok")

      expect(helper.base_translate_view_controller_path("actions.index.title")).to eq("ok")
    end
  end

  describe "#translate_view" do
    it "returns controller translation when present" do
      allow(helper).to receive(:base_translate_view_controller_path).and_return("Controller text")

      expect(helper.translate_view("shared.label")).to eq("Controller text")
    end

    it "falls back to application translation when controller translation is blank" do
      allow(helper).to receive(:base_translate_view_controller_path).and_return("")
      allow(helper).to receive(:base_translate_view_application_path).and_return("Fallback text")

      expect(helper.translate_view("shared.label")).to eq("Fallback text")
    end
  end

  describe "#translate_view_actions" do
    it "delegates actions prefix to translate_view" do
      expect(helper).to receive(:translate_view).with("actions.index.title", {}).and_return("Index")

      expect(helper.translate_view_actions("index.title")).to eq("Index")
    end
  end

  describe "#translate_view_shared" do
    it "delegates shared prefix to translate_view" do
      expect(helper).to receive(:translate_view).with("shared.flag", {}).and_return("Shared")

      expect(helper.translate_view_shared("flag")).to eq("Shared")
    end
  end

  describe "#translate_view_index" do
    it "delegates index action path" do
      expect(helper).to receive(:translate_view_actions).with("index.header", {}).and_return("Header")

      expect(helper.translate_view_index("header")).to eq("Header")
    end
  end

  describe "#translate_view_new" do
    it "delegates new action path" do
      expect(helper).to receive(:translate_view_actions).with("new.header", {}).and_return("Header")

      expect(helper.translate_view_new("header")).to eq("Header")
    end
  end

  describe "#translate_view_edit" do
    it "delegates edit action path" do
      expect(helper).to receive(:translate_view_actions).with("edit.header", {}).and_return("Header")

      expect(helper.translate_view_edit("header")).to eq("Header")
    end
  end

  describe "#translate_view_show" do
    it "delegates show action path" do
      expect(helper).to receive(:translate_view_actions).with("show.header", {}).and_return("Header")

      expect(helper.translate_view_show("header")).to eq("Header")
    end
  end

  describe "#translate_view_destroy" do
    it "delegates destroy action path" do
      expect(helper).to receive(:translate_view_actions).with("destroy.header", {}).and_return("Header")

      expect(helper.translate_view_destroy("header")).to eq("Header")
    end
  end

  describe "#translation_view_path" do
    it "builds dotted path from controller class name" do
      allow(helper).to receive(:controller).and_return(Admin::DogsController.new)

      expect(helper.translation_view_path).to eq("admin.dogs")
    end
  end
end
