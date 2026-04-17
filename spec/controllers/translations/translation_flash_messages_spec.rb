require "rails_helper"

RSpec.describe Translations::TranslationFlashMessages do
  subject(:context) { context_class.new }

  let(:context_class) do
    Class.new do
      include Translations::TranslationFlashMessages

      def action_name
        "create"
      end

      def underscore_model_class
        "users"
      end

      def t(_path, **_params)
        ""
      end
    end
  end

  describe "#base_translate_flash" do
    it "uses sub-message key when sub_message is present" do
      expect(context).to receive(:t)
        .with("controllers.admin.users.create.error.password", foo: "bar")
        .and_return("Senha inválida")

      result = context.base_translate_flash("admin.users", "error", { foo: "bar" }, "password")

      expect(result).to eq("Senha inválida")
    end
  end

  describe "#translate_flash" do
    it "returns controller translation when present" do
      expect(context).to receive(:t).with("users.single").and_return("Usuário")
      expect(context).to receive(:translate_controller_path_flash)
        .with("success", hash_including(controller_name: "Usuário", default: ""), nil)
        .and_return("Sucesso customizado")
      expect(context).not_to receive(:translate_generic_flash)

      expect(context.translate_flash("success")).to eq("Sucesso customizado")
    end
  end
end
