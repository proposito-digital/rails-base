module Translations::TranslationFlashMessages
  def base_translate_flash(path, message_type, translate_params = {}, sub_message = nil)
    unless sub_message.present?
      return t("controllers.#{path}.#{action_name}.#{message_type}", **translate_params)
    end
    t("controllers.#{path}.#{action_name}.#{message_type}.#{sub_message}", **translate_params)
  end

  def translate_controller_path_flash(message_type, translate_params = {}, sub_message = nil)
    base_translate_flash("#{translation_controller_path}.", message_type, translate_params, sub_message)
  end

  def translate_generic_flash(message_type, translate_params = {}, sub_message = nil)
    base_translate_flash("generic.", message_type, translate_params, sub_message)
  end

  def translate_flash(message_type, translate_params: {}, sub_message: nil)
    translate_params = translate_params.merge(controller_name: t("#{underscore_model_class}.single"))
    translation = translate_controller_path_flash(message_type, translate_params.merge(default: ""), sub_message)
    unless translation.present?
      return translate_generic_flash(message_type, translate_params, sub_message)
    end
    translation
  end

  def translation_controller_path
    splited_name = self.class.name.underscore.split("/")
    splited_name[splited_name.length-1] = splited_name[splited_name.length-1].gsub("_controller", "")
    splited_name.join(".")
  end
end
