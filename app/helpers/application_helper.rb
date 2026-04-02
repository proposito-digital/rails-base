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
    file = File.read("VERSION") + Rails.env[0, 3]
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

    {
      "box-arrow-right" => "log-out",
      "house-door" => "home",
      "person" => "user",
      "eye-slash" => "eye-off",
      "x-lg" => "x",
      "dog" => "paw"
    }.fetch(key, key.presence || "circle")
  end

  def icon_paths_for(name)
    case name
    when "activity"
      [ tag.path(d: "M22 12h-4l-3 9-6-18-3 9H2") ]
    when "bell"
      [
        tag.path(d: "M15 17h5l-1.4-1.4A2 2 0 0 1 18 14.2V11a6 6 0 1 0-12 0v3.2c0 .53-.21 1.04-.59 1.41L4 17h5"),
        tag.path(d: "M9 17a3 3 0 0 0 6 0")
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
        tag.path(d: "M2.458 12C3.732 7.943 7.523 5 12 5s8.268 2.943 9.542 7c-1.274 4.057-5.065 7-9.542 7S3.732 16.057 2.458 12Z"),
        tag.circle(cx: "12", cy: "12", r: "3")
      ]
    when "eye-off"
      [
        tag.path(d: "m3 3 18 18"),
        tag.path(d: "M10.73 5.08A10.43 10.43 0 0 1 12 5c4.48 0 8.27 2.94 9.54 7a10.6 10.6 0 0 1-2.35 3.95"),
        tag.path(d: "M6.61 6.62A10.42 10.42 0 0 0 2.46 12C3.73 16.06 7.52 19 12 19c1.54 0 3-.35 4.3-.97"),
        tag.path(d: "M9.88 9.88A3 3 0 0 0 14.12 14.12")
      ]
    when "home"
      [
        tag.path(d: "M3 10.5 12 3l9 7.5"),
        tag.path(d: "M5 9.5V21h14V9.5")
      ]
    when "key"
      [
        tag.circle(cx: "7.5", cy: "15.5", r: "2.5"),
        tag.path(d: "M10 13l10-10"),
        tag.path(d: "M17 6l3 3"),
        tag.path(d: "M14 9l3 3")
      ]
    when "log-out"
      [
        tag.path(d: "M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"),
        tag.path(d: "M16 17l5-5-5-5"),
        tag.path(d: "M21 12H9")
      ]
    when "paw"
      [
        tag.path(d: "M4.5 9.5c1.38 0 2.5-1.34 2.5-3s-1.12-3-2.5-3S2 4.84 2 6.5s1.12 3 2.5 3Z"),
        tag.path(d: "M19.5 9.5c1.38 0 2.5-1.34 2.5-3s-1.12-3-2.5-3-2.5 1.34-2.5 3 1.12 3 2.5 3Z"),
        tag.path(d: "M8.5 13.5c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2Z"),
        tag.path(d: "M15.5 13.5c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2Z"),
        tag.path(d: "M12 21c-3 0-5.5-2.5-5.5-4.5 0-2 1.8-3.5 3.5-3.5 1 0 2 .5 2 .5s1-.5 2-.5c1.7 0 3.5 1.5 3.5 3.5S15 21 12 21Z")
      ]
    when "pencil-square"
      [
        tag.path(d: "M12 20h9"),
        tag.path(d: "M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4Z")
      ]
    when "plus"
      [
        tag.path(d: "M12 5v14"),
        tag.path(d: "M5 12h14")
      ]
    when "receipt"
      [
        tag.path(d: "M4 2h16v20l-3-2-2 2-2-2-2 2-2-2-2 2-3-2z"),
        tag.path(d: "M8 7h8"),
        tag.path(d: "M8 11h8"),
        tag.path(d: "M8 15h5")
      ]
    when "search"
      [
        tag.circle(cx: "11", cy: "11", r: "8"),
        tag.path(d: "m21 21-4.3-4.3")
      ]
    when "trash"
      [
        tag.path(d: "M3 6h18"),
        tag.path(d: "M8 6V4h8v2"),
        tag.path(d: "M19 6l-1 14H6L5 6"),
        tag.path(d: "M10 11v6"),
        tag.path(d: "M14 11v6")
      ]
    when "user"
      [
        tag.circle(cx: "12", cy: "7", r: "4"),
        tag.path(d: "M4 21a8 8 0 0 1 16 0")
      ]
    when "x"
      [
        tag.path(d: "M18 6 6 18"),
        tag.path(d: "m6 6 12 12")
      ]
    else
      [ tag.circle(cx: "12", cy: "12", r: "9") ]
    end
  end
end
