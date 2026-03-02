# frozen_string_literal: true

require "rails/generators/resource_helpers"
require "rails/generators"

class Rails::Generators::MyScaffoldControllerGenerator < Rails::Generators::NamedBase # :nodoc:
  include Rails::Generators::ResourceHelpers

  source_root File.expand_path("../../../../templates", __FILE__)

  check_class_collision suffix: "Controller"

  class_option :helper, type: :boolean
  class_option :orm, banner: "NAME", type: :string, required: true,
                      desc: "ORM to generate the controller for"

  argument :attributes, type: :array, default: [], banner: "field:type field:type"

  def admin_path
    "admin"
  end

  def create_controller_files
    template "controller.rb", File.join("app/controllers", admin_path, "#{controller_file_name}_controller.rb")
    # invoke pundit policy generations
    Rails::Generators.invoke("pundit:policy", [ "#{singular_table_name}" ])
  end

  def create_helper_files
    template "helper.rb", File.join("app/helpers", admin_path, "#{controller_file_name}_helper.rb")
  end

  def create_rspec_files
    template "rspec/features/features.rb", File.join("spec/features/", admin_path, "#{controller_file_name}_features_spec.rb")
    template "rspec/request/request_spec.rb", File.join("spec/requests/", admin_path, "#{controller_file_name}_request_spec.rb")

    template "rspec/scaffold/helper_spec.rb", File.join("spec/helpers/", admin_path, "#{controller_file_name}_helper_spec.rb")
    template "rspec/scaffold/routing_spec.rb", File.join("spec/routing", admin_path, "#{controller_file_name}_request_spec.rb")
  end
end
