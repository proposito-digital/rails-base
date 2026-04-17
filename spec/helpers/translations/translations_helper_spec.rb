require "rails_helper"

RSpec.describe Translations::TranslationsHelper, type: :helper do
  describe "#translate_view_home" do
    it "delegates home action path to translate_view_actions" do
      expect(helper).to receive(:translate_view_actions).with("home.title", {}).and_return("Início")

      expect(helper.translate_view_home("title")).to eq("Início")
    end
  end

  describe "#translate_view_application_shared" do
    it "delegates shared application path to base application translator" do
      expect(helper).to receive(:base_translate_view_application_path).with("shared.empty_state.", {}).and_return("Sem dados")

      expect(helper.translate_view_application_shared("empty_state")).to eq("Sem dados")
    end
  end

  describe "#meet_status_translation" do
    it "translates meet status from fixed key namespace" do
      expect(helper).to receive(:t).with("en.activerecord.attributes.meet.statuses.scheduled").and_return("Agendado")

      expect(helper.meet_status_translation("scheduled")).to eq("Agendado")
    end
  end
end
