require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsBase
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    #
    # The default locale is :pt-br and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join("my", "locales", "*.{rb,yml}").to_s]
    config.i18n.available_locales = [ :en, "pt-br" ]
    config.i18n.default_locale = "pt-br"

    config.generators do |g|
      g.scaffold_controller :my_scaffold_controller
      g.template_engine nil
      g.helper nil
      g.test_framework :rspec, request_specs: false
      g.stylesheets  false
      g.javascripts  false
    end
  end
end
