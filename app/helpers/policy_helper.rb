module PolicyHelper
  def check_policy_to_button(instance, action, properties, href, title, context_instance = nil)
    if instance.present? && action.present?
      policy_error = check_policy_error(instance: instance, action: action)
      policy_error = check_policy_error(instance: context_instance, action: action) if context_instance.present?
    else
      policy_error = false
    end

    if policy_error
      properties << "title='#{policy_error}'" if policy_error.present?
      css_class = "class='btn-icon disabled'"
    else
      properties << "title='#{title}'" if title.present?
      css_class = "class='btn-icon'"
    end
    [ css_class, properties, policy_error ]
  end

  def check_policy(instance: nil, action: nil)
    begin
      policy(instance).send(action)
    rescue Pundit::NotAuthorizedError => e
      false
    end
  end

  def check_policy_error(instance: nil, action: nil)
    begin
      if policy(instance).send(action)
        false
      else
        (t "#{instance.class.to_s.underscore + "_policy"}.#{action}", scope: "pundit", default: :default)
      end
    rescue Pundit::NotAuthorizedError => e
      policy_name = e.policy.class.to_s.underscore
      t "#{policy_name}.#{e.query}", scope: "pundit", default: :default
    end
  end
end
