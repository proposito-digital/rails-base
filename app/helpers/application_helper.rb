module ApplicationHelper
  include Pundit::Authorization
  include Translations::TranslationsHelper
  include PathHelper
  include PolicyHelper
  include NameHelper

  def sort_link(column, title = nil)
      title ||= column.titleize
      icon = params[:sort_direction] == "asc" ?  "bi bi-chevron-down" :  "bi bi-chevron-up"
      sort_direction = params[:sort_direction] == "asc" ? "desc" : "asc"
      show_icon = params[:sort_column] == column ? "<span class='#{icon}'></span>" : ""
      link_to "#{title} #{show_icon}".html_safe, params.slice(:term, :page).merge(sort_direction: sort_direction, sort_column: column).permit!
  end

  def app_version
    file = File.read("VERSION") + Rails.env[0, 3]
  end

  def action_button(href: nil, style: nil, data_placement: "top", instance: nil, action: nil, title: nil, data_method: nil, data_toggle: nil, data_target: nil, icon: nil, context_instance: nil)
    properties = []

    css_class, properties, policy_error = check_policy_to_button(instance, action, properties, href, title, context_instance)

    properties << "data-placement='#{data_placement}'" if data_placement.present?
    properties << "data-method='#{data_method}'" if data_method.present?
    properties << "data-toggle='#{data_toggle}'" if data_toggle.present?
    properties << "data-target='##{data_target}'" if data_target.present?
    policy_error ? properties << "href='javascript:void(0)'" : properties << "href='#{href}'" if href.present?

    i = []
    i << "class='#{icon}'" if icon.present?
    i << "style='#{style}'" if style.present?
    "<a #{css_class} #{properties.join(" ")}><i #{i.join(" ")}></i></a>".html_safe
  end

  def modal_button(icon: nil, instance: nil, action: nil, href: nil, title: nil, style: nil, modal_id: nil, context_instance: nil)
    properties = []

    css_class, properties, policy_error = check_policy_to_button(instance, action, properties, href, title, context_instance)

    if not policy_error
      properties << "data-bs-toggle=\"modal\" data-bs-target=\"##{modal_id}\""
      i = []
      i << "class='#{icon}'" if icon.present?
      i << "style='#{style}'" if style.present?
      "<a type=\"button\" #{css_class} #{properties.join(" ")}><i #{i.join(" ")}></i></a>".html_safe
    end
  end

  def instance_attributes_only(instance, attributes_names)
    instance.attributes.select { |attribute| attributes_names.include? attribute }
  end

  def hours_options
    [ "00:00", "00:15", "00:30", "00:45", "01:00", "01:15", "01:30", "01:45", "02:00", "02:15", "02:30", "02:45",
      "03:00", "03:15", "03:30", "03:45", "04:00", "04:15", "04:30", "04:45", "05:00", "05:15", "05:30", "05:45",
      "06:00", "06:15", "06:30", "06:45", "07:00", "07:15", "07:30", "07:45", "08:00", "08:15", "08:30", "08:45",
      "09:00", "09:15", "09:30", "09:45", "10:00", "10:15", "10:30", "10:45", "11:00", "11:15", "11:30", "11:45",
      "12:00", "12:15", "12:30", "12:45", "13:00", "13:15", "13:30", "13:45", "14:00", "14:15", "14:30", "14:45",
      "15:00", "15:15", "15:30", "15:45", "16:00", "16:15", "16:30", "16:45", "17:00", "17:15", "17:30", "17:45",
      "18:00", "18:15", "18:30", "18:45", "19:00", "19:15", "19:30", "19:45", "20:00", "20:15", "20:30", "20:45",
      "21:00", "21:15", "21:30", "21:45", "22:00", "22:15", "22:30", "22:45", "23:00", "23:15", "23:30", "23:45" ]
  end

  def present(model, presenter_class = nil)
    begin
      klass = presenter_class || "#{model.class}Presenter".constantize
    rescue NameError
      klass = ApplicationPresenter
    end
    klass.new(model, self)
    # yield(presenter) if block_given?
  end

  def flash_type(type)
    case type
    when "success"
      "success"
    when "alert"
      "warning"
    when "error"
      "danger"
    when "danger"
      "danger"
    when "notice"
      "primary"
    else
      ""
    end
  end

  def markdown(text)
    options = %i[
      hard_wrap autolink no_intra_emphasis tables fenced_code_blocks
      disable_indented_code_blocks strikethrough lax_spacing space_after_headers
      quote footnotes highlight underline no_images
      ]
      Markdown.new(text, *options).to_html.html_safe
  end
end
