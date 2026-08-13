require "rails_helper"

RSpec.describe "Admin dashboard", type: :request do
  it "allows a regular user to access the dashboard" do
    user = create(:user, password: "123", password_confirmation: "123")
    sign_in(user)

    get root_path

    expect(response).to have_http_status(:ok)
  end

  it "redirects an unauthenticated user to sign in" do
    get root_path

    expect(response).to redirect_to(new_session_path(locale: I18n.default_locale))
  end
end
