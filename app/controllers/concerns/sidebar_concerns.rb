require "active_support/concern"

module SidebarConcerns
  extend ActiveSupport::Concern
  include Translations::TranslationsViewHelper

   included do
    def set_menu
      @menu = [
      {
        name: translate_view_application_shared("sidebar_menu.home"),
        icon: "bi bi-house-door",
        policy: :dashboard,
        url: { controller: "dashboard", action: "index" },
        active: controller_path == "admin/dashboard"
      },
      {
        name: t("users.plural"),
        icon: "bi bi-person",
        policy: :user,
        url: { controller: "users", action: "index" },
        active: controller_path == "admin/users"
      },
      {
        name: t("dogs.plural"),
        icon: "bi bi-dog",
        policy: :dog,
        url: { controller: "dogs", action: "index" },
        active: controller_path == "admin/dogs"
      }
        # Submenu Example
        # {
        #   name: translate_view_application_shared("sidebar_menu.home"),
        #   icon: "bi bi-house-door",
        #   policy: :dashboard,
        #   url: { controller: "dashboard", action: "index" },
        #   id_collapse: "tenant-collapse",
        #   active: (controller_path == "admin/users" || controller_path == "admin/users"),
        #   items: [
        #       {
        #         name: t("users.plural"),
        #         icon: "bi bi-person",
        #         policy: :user,
        #         url: { controller: "users", action: "index" },
        #         active: controller_path == "admin/users"
        #       },
        #       {
        #         name: t("users.plural"),
        #         icon: "bi bi-person",
        #         policy: :user,
        #         url: { controller: "users", action: "index" },
        #         active: controller_path == "admin/users"
        #       }
        #   ]
        # }
      ]
    end
  end
end
