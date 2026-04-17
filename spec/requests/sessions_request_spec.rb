require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "GET /session/new" do
    it "renders sign in page" do
      get new_session_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /session" do
    let!(:user) { create(:user, password: "123", password_confirmation: "123") }

    it "creates a session and redirects when credentials are valid" do
      expect do
        post session_path, params: { email_address: user.email_address, password: "123" }
      end.to change(Session, :count).by(1)

      expect(response).to redirect_to(root_path(locale: I18n.locale))
      expect(Session.last.user).to eq(user)
    end

    it "redirects back to sign in when credentials are invalid" do
      expect do
        post session_path, params: { email_address: user.email_address, password: "wrong-password" }
      end.not_to change(Session, :count)

      expect(response).to redirect_to(new_session_path(locale: I18n.locale))
      expect(flash[:alert]).to eq("Try another email address or password.")
    end
  end

  describe "DELETE /session" do
    let!(:user) { create(:user, password: "123", password_confirmation: "123") }

    it "terminates current session and redirects to sign in page" do
      sign_in(user)
      current_session = Session.last

      expect do
        delete session_path
      end.to change(Session, :count).by(-1)

      expect(Session.exists?(current_session.id)).to be(false)
      expect(response).to redirect_to(new_session_path(locale: I18n.locale))
    end
  end
end
