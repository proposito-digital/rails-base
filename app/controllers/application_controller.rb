class ApplicationController < ActionController::Base
  include Authentication

  before_action :set_locale

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def default_url_options
    { locale: I18n.locale }
  end

  private

    def set_locale
      I18n.locale = extract_locale_from_params || I18n.default_locale
    end

    def extract_locale_from_params
      return if params[:locale].blank?

      requested_locale = params[:locale].to_s.tr("_", "-").downcase

      I18n.available_locales.find do |available_locale|
        available_locale.to_s.tr("_", "-").downcase == requested_locale
      end
    end
end
