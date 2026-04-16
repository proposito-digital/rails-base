module Admin::BaseHelper
  def admin_index_visible_attributes
    @admin_index_visible_attributes ||= model_column_names.excluding("id", "deleted_at", "password_digest").take(5)
  end

  def admin_index_empty_state_title
    translate_view_index("no_instances", model_name: model_plural_translation.downcase)
  end

  def admin_index_empty_state_description
    translate_view_index("new_instance", model_name: model_singular_translation.downcase)
  end

  def admin_index_empty_state_button_label
    translate_view_index("new_button", model_name: model_singular_translation)
  end

  def admin_index_no_results_search_message
    translate_view_index("no_results_search", model_name: model_plural_translation.downcase)
  end

  def admin_index_description
    translate_view_index("description", model_name: model_plural_translation.downcase)
  end

  def admin_index_search_term
    params[:term].to_s
  end

  def admin_index_search_applied?
    admin_index_search_term.strip.present?
  end

  def admin_index_has_instances?
    @instances.present?
  end

  def admin_index_display_value(raw_value)
    case raw_value
    when ActiveSupport::TimeWithZone
      translate_datetime_format_default(raw_value, "dt_at")
    when true
      translate_view_shared("yes_display")
    when false
      translate_view_shared("no_display")
    else
      raw_value.presence || "-"
    end
  end
end
