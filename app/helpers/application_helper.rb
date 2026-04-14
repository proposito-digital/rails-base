module ApplicationHelper
  include Pundit::Authorization
  include Translations::TranslationsHelper
  include PathHelper
  include PolicyHelper
  include NameHelper

  def sort_link(column, title = nil)
    title ||= column.titleize
    icon_name = params[:sort_direction] == "asc" ? "chevron-down" : "chevron-up"
    sort_direction = params[:sort_direction] == "asc" ? "desc" : "asc"

    label_parts = [ title ]
    if params[:sort_column] == column
      label_parts << ui_icon(icon_name, classes: "ml-1 inline-block size-3 align-text-bottom")
    end

    link_to safe_join(label_parts, " ".html_safe), params.slice(:term, :page).merge(sort_direction: sort_direction, sort_column: column).permit!
  end

  def app_version
    File.read("VERSION").strip + Rails.env[0, 3]
  end

  def action_button(href: nil, style: nil, data_placement: "top", instance: nil, action: nil, title: nil, data_method: nil, icon: nil, context_instance: nil)
    properties = []

    css_class, properties, policy_error = check_policy_to_button(instance, action, properties, href, title, context_instance)

    properties << "data-placement='#{data_placement}'" if data_placement.present?
    properties << "data-method='#{data_method}'" if data_method.present?
    policy_error ? properties << "href='javascript:void(0)'" : properties << "href='#{href}'" if href.present?

    icon_html = icon.present? ? ui_icon(icon, classes: "size-4", style: style) : "".html_safe
    "<a #{css_class} #{properties.join(" ")}>#{icon_html}</a>".html_safe
  end

  def modal_button(icon: nil, instance: nil, action: nil, href: nil, title: nil, style: nil, modal_id: nil, context_instance: nil)
    properties = []

    css_class, properties, policy_error = check_policy_to_button(instance, action, properties, href, title, context_instance)

    if !policy_error
      properties << "data-hs-overlay=\"##{modal_id}\""
      icon_html = icon.present? ? ui_icon(icon, classes: "size-4", style: style) : "".html_safe
      "<a type=\"button\" #{css_class} #{properties.join(" ")}>#{icon_html}</a>".html_safe
    end
  end

  def ui_icon(name, classes: "size-4", style: nil, aria_hidden: true)
    icon_key = normalize_icon_name(name)
    options = {
      class: classes,
      xmlns: "http://www.w3.org/2000/svg",
      viewBox: "0 0 24 24",
      fill: "none",
      stroke: "currentColor",
      "stroke-width": "2",
      "stroke-linecap": "round",
      "stroke-linejoin": "round"
    }
    options[:style] = style if style.present?
    options[:"aria-hidden"] = true if aria_hidden

    tag.svg(**options) { safe_join(icon_paths_for(icon_key)) }
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

  def flash_banner_class(type)
    case flash_type(type)
    when "success"
      "border-emerald-200 bg-emerald-50 text-emerald-800"
    when "warning"
      "border-amber-200 bg-amber-50 text-amber-800"
    when "danger"
      "border-red-200 bg-red-50 text-red-800"
    when "primary"
      "border-blue-200 bg-blue-50 text-blue-800"
    else
      "border-slate-200 bg-slate-50 text-slate-800"
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

  private

  def normalize_icon_name(name)
    key = name.to_s.strip.tr("_", "-")
    key = key.delete_prefix("bi-")

    {
      "box-arrow-right" => "log-out",
      "house-door" => "house",
      "home" => "house",
      "person" => "user",
      "eye-slash" => "eye-off",
      "x-lg" => "x",
      "dog" => "paw-print",
      "paw" => "paw-print",
      "pencil-square" => "square-pen",
      "receipt" => "receipt-text"
    }.fetch(key, key.presence || "circle")
  end

  def icon_paths_for(name)
    case name
    when "activity"
      [ tag.path(d: "M22 12h-2.48a2 2 0 0 0-1.93 1.46l-2.35 8.36a.25.25 0 0 1-.48 0L9.24 2.18a.25.25 0 0 0-.48 0l-2.35 8.36A2 2 0 0 1 4.49 12H2") ]
    when "bell"
      [
        tag.path(d: "M10.268 21a2 2 0 0 0 3.464 0"),
        tag.path(d: "M3.262 15.326A1 1 0 0 0 4 17h16a1 1 0 0 0 .74-1.673C19.41 13.956 18 12.499 18 8A6 6 0 0 0 6 8c0 4.499-1.411 5.956-2.738 7.326")
      ]
    when "chevron-down"
      [ tag.path(d: "m6 9 6 6 6-6") ]
    when "chevron-left"
      [ tag.path(d: "m15 18-6-6 6-6") ]
    when "chevron-right"
      [ tag.path(d: "m9 18 6-6-6-6") ]
    when "chevron-up"
      [ tag.path(d: "m18 15-6-6-6 6") ]
    when "eye"
      [
        tag.path(d: "M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10.75 0 0 1-19.876 0"),
        tag.circle(cx: "12", cy: "12", r: "3")
      ]
    when "eye-off"
      [
        tag.path(d: "M10.733 5.076a10.744 10.744 0 0 1 11.205 6.575 1 1 0 0 1 0 .696 10.747 10.747 0 0 1-1.444 2.49"),
        tag.path(d: "M14.084 14.158a3 3 0 0 1-4.242-4.242"),
        tag.path(d: "M17.479 17.499a10.75 10.75 0 0 1-15.417-5.151 1 1 0 0 1 0-.696 10.75 10.75 0 0 1 4.446-5.143"),
        tag.path(d: "m2 2 20 20")
      ]
    when "house"
      [
        tag.path(d: "M15 21v-8a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v8"),
        tag.path(d: "M3 10a2 2 0 0 1 .709-1.528l7-6a2 2 0 0 1 2.582 0l7 6A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z")
      ]
    when "key"
      [
        tag.path(d: "m15.5 7.5 2.3 2.3a1 1 0 0 0 1.4 0l2.1-2.1a1 1 0 0 0 0-1.4L19 4"),
        tag.path(d: "m21 2-9.6 9.6"),
        tag.circle(cx: "7.5", cy: "15.5", r: "5.5")
      ]
    when "log-out"
      [
        tag.path(d: "m16 17 5-5-5-5"),
        tag.path(d: "M21 12H9"),
        tag.path(d: "M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4")
      ]
    when "paw-print"
      [
        tag.circle(cx: "11", cy: "4", r: "2"),
        tag.circle(cx: "18", cy: "8", r: "2"),
        tag.circle(cx: "20", cy: "16", r: "2"),
        tag.path(d: "M9 10a5 5 0 0 1 5 5v3.5a3.5 3.5 0 0 1-6.84 1.045Q6.52 17.48 4.46 16.84A3.5 3.5 0 0 1 5.5 10Z")
      ]
    when "square-pen"
      [
        tag.path(d: "M12 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"),
        tag.path(d: "M18.375 2.625a1 1 0 0 1 3 3l-9.013 9.014a2 2 0 0 1-.853.505l-2.873.84a.5.5 0 0 1-.62-.62l.84-2.873a2 2 0 0 1 .506-.852z")
      ]
    when "plus"
      [
        tag.path(d: "M5 12h14"),
        tag.path(d: "M12 5v14")
      ]
    when "receipt-text"
      [
        tag.path(d: "M13 16H8"),
        tag.path(d: "M14 8H8"),
        tag.path(d: "M16 12H8"),
        tag.path(d: "M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z")
      ]
    when "search"
      [
        tag.path(d: "m21 21-4.34-4.34"),
        tag.circle(cx: "11", cy: "11", r: "8")
      ]
    when "trash"
      [
        tag.path(d: "M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"),
        tag.path(d: "M3 6h18"),
        tag.path(d: "M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2")
      ]
    when "user"
      [
        tag.path(d: "M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"),
        tag.circle(cx: "12", cy: "7", r: "4")
      ]
    when "x"
      [
        tag.path(d: "M18 6 6 18"),
        tag.path(d: "m6 6 12 12")
      ]
    else
      [ tag.circle(cx: "12", cy: "12", r: "10") ]
    end
  end
end
