# frozen_string_literal: true

require "rails/generators/resource_helpers"
require "rails/generators"

class Rails::Generators::MyScaffoldControllerGenerator < Rails::Generators::NamedBase # :nodoc:
  include Rails::Generators::ResourceHelpers

  source_root File.expand_path("../../../../templates", __FILE__)
  ADMIN_NAMESPACE = "admin"
  ROUTES_PATH = "config/routes.rb"

  check_class_collision suffix: "Controller"

  class_option :orm, banner: "NAME", type: :string, required: true,
                      desc: "ORM to generate the controller for"

  argument :attributes, type: :array, default: [], banner: "field:type field:type"

  def create_controller_files
    template "controller.rb.tt", File.join("app/controllers", ADMIN_NAMESPACE, "#{controller_file_name}_controller.rb")
    Rails::Generators.invoke("pundit:policy", [ policy_name ], behavior: behavior)
    remove_file(File.join("app/policies", ADMIN_NAMESPACE, "#{policy_name}_policy.rb")) if behavior == :revoke
  end

  def create_helper_files
    template "helper.rb.tt", File.join("app/helpers", ADMIN_NAMESPACE, "#{controller_file_name}_helper.rb")
  end

  def create_rspec_files
    template "rspec/features/features.rb.tt", File.join("spec/features/", ADMIN_NAMESPACE, "#{controller_file_name}_features_spec.rb")
    template "rspec/request/request_spec.rb.tt", File.join("spec/requests/", ADMIN_NAMESPACE, "#{controller_file_name}_request_spec.rb")

    template "rspec/scaffold/helper_spec.rb.tt", File.join("spec/helpers/", ADMIN_NAMESPACE, "#{controller_file_name}_helper_spec.rb")
    template "rspec/scaffold/routing_spec.rb.tt", File.join("spec/routing", ADMIN_NAMESPACE, "#{controller_file_name}_request_spec.rb")
  end

  def normalize_admin_route
    route_line = "resources :#{file_name.pluralize}"
    routes_content = File.read(ROUTES_PATH)
    updated_routes = routes_content.gsub(/^\s*#{Regexp.escape(route_line)}\s*$\n?/, "")

    if behavior == :invoke
      admin_namespace_regex = /^\s*namespace :#{ADMIN_NAMESPACE} do\s*$/
      namespaced_route_regex = /^\s{4}#{Regexp.escape(route_line)}\s*$/

      if updated_routes.match?(admin_namespace_regex)
        unless updated_routes.match?(namespaced_route_regex)
          updated_routes.sub!(admin_namespace_regex) { |match| "#{match}\n    #{route_line}" }
        end
      else
        namespace_block = "  namespace :#{ADMIN_NAMESPACE} do\n    #{route_line}\n  end\n"
        draw_regex = /^Rails\.application\.routes\.draw do\s*$/

        updated_routes.sub!(draw_regex) { |match| "#{match}\n#{namespace_block}" }
      end
    end

    File.write(ROUTES_PATH, updated_routes) if updated_routes != routes_content
  end

  private

  def policy_name
    controller_file_name.singularize
  end
end
