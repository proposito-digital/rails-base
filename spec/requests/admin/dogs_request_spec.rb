require "rails_helper"

RSpec.describe "Dogs", type: :request do
  describe "GET /admin/dogs" do
    it "allows an admin" do
      sign_in_as_a_valid_user

      get admin_dogs_path

      expect(response).to have_http_status(:ok)
    end

    it "redirects a regular user to the dashboard" do
      user = create(:user, password: "123", password_confirmation: "123")
      sign_in(user)

      get admin_dogs_path

      expect(response).to redirect_to(root_path(locale: I18n.default_locale))
    end

    it "returns forbidden for a regular user requesting JSON" do
      user = create(:user, password: "123", password_confirmation: "123")
      sign_in(user)

      get admin_dogs_path(format: :json), as: :json

      expect(response).to have_http_status(:forbidden)
    end
  end
end
