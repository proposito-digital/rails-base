module Translations::TranslationsSelectHelper
  def get_language_name(locale)
    t("language_name", locale: locale)
  end

  def get_locale_flag_icon(locale)
    t("flag_icon", locale: locale)
  end
end
