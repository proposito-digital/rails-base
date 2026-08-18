# Be sure to restart your server when you modify this file.

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.base_uri :self
    policy.connect_src :self
    policy.font_src :self, :data, "https://cdn.jsdelivr.net", "https://fonts.cdnfonts.com", "https://fonts.gstatic.com"
    policy.form_action :self
    policy.frame_ancestors :self
    policy.img_src :self, :data
    policy.object_src :none
    policy.script_src :self
    policy.style_src :self, :unsafe_inline, "https://cdn.jsdelivr.net", "https://fonts.cdnfonts.com", "https://fonts.googleapis.com"
  end

  config.content_security_policy_nonce_generator = ->(_request) { SecureRandom.base64(16) }
  config.content_security_policy_nonce_directives = %w[script-src]
end
