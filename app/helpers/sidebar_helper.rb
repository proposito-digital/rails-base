# frozen_string_literal: true

module SidebarHelper
  def menu_active?(current_menu, text = false)
    if controller_name.to_sym == current_menu[:url][:controller].to_sym
      return "active" if text

      true
    end
  end

  def mobile_navbar_title
    active_menu = Array(@menu).find { |menu_item| menu_item[:active] }
    return active_menu[:name] if active_menu&.dig(:name).present?

    translated_title = t("#{controller_name}.plural", default: "")
    return translated_title if translated_title.present?

    controller_name.humanize
  end
end
