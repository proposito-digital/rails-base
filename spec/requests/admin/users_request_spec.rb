require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /admin/users" do
    before do
      sign_in_as_a_valid_user
    end

    it "renders the page" do
      get admin_users_path
      expect(response).to have_http_status(200)
    end

    it "switches to english when locale=en" do
      get admin_users_path(locale: :en)

      expect(response).to have_http_status(200)
      expect(response.body).to include("Logout")
      expect(response.body).to include("/session?locale=en")
    end

    it "falls back to default locale when locale is invalid" do
      get admin_users_path(locale: :es)

      expect(response).to have_http_status(200)
      expect(response.body).to include("Sair")
      expect(response.body).to include("/session?locale=pt-br")
    end
  end

  describe "POST /admin/users" do
    let!(:auth_user) { create(:user, :admin, password: "123", password_confirmation: "123") }

    before do
      sign_in(auth_user)
    end

    it "renders new with unprocessable_entity when HTML params are invalid" do
      post admin_users_path, params: {
        user: {
          email_address: "invalid_user@example.com",
          password: "new-pass-123",
          password_confirmation: "different-pass-123"
        }
      }

      expect(response).to have_http_status(422)
    end

    it "returns validation errors with unprocessable_entity when JSON params are invalid" do
      post admin_users_path(format: :json), params: {
        user: {
          email_address: "invalid_json_user@example.com",
          password: "new-pass-123",
          password_confirmation: "different-pass-123"
        }
      }, as: :json

      expect(response).to have_http_status(422)
      expect(response.media_type).to eq("application/json")
      expect(JSON.parse(response.body)).to include("password_confirmation")
    end
  end

  describe "PATCH /admin/users/:id" do
    let!(:auth_user) { create(:user, :admin, password: '123', password_confirmation: '123') }
    let!(:target_user) { create(:user, password: 'old-pass-123', password_confirmation: 'old-pass-123') }

    before do
      sign_in(auth_user)
    end

    it "keeps the current password when password fields are blank" do
      old_digest = target_user.password_digest

      patch admin_user_path(target_user), params: {
        user: {
          email_address: target_user.email_address,
          password: '',
          password_confirmation: ''
        }
      }

      expect(response).to have_http_status(302)
      expect(target_user.reload.password_digest).to eq(old_digest)
      expect(User.authenticate_by(email_address: target_user.email_address, password: 'old-pass-123')).to eq(target_user)
    end

    it "updates the password when password and confirmation are provided" do
      patch admin_user_path(target_user), params: {
        user: {
          email_address: target_user.email_address,
          password: 'new-pass-123',
          password_confirmation: 'new-pass-123'
        }
      }

      expect(response).to have_http_status(302)
      expect(User.authenticate_by(email_address: target_user.email_address, password: 'new-pass-123')).to eq(target_user.reload)
    end

    it "renders edit with unprocessable_entity when HTML params are invalid" do
      patch admin_user_path(target_user), params: {
        user: {
          email_address: target_user.email_address,
          password: "new-pass-123",
          password_confirmation: "different-pass-123"
        }
      }

      expect(response).to have_http_status(422)
    end

    it "returns validation errors with unprocessable_entity when JSON params are invalid" do
      patch admin_user_path(target_user, format: :json), params: {
        user: {
          email_address: target_user.email_address,
          password: "new-pass-123",
          password_confirmation: "different-pass-123"
        }
      }, as: :json

      expect(response).to have_http_status(422)
      expect(response.media_type).to eq("application/json")
      expect(JSON.parse(response.body)).to include("password_confirmation")
    end
  end

  describe "DELETE /admin/users/:id" do
    let!(:auth_user) { create(:user, :admin, password: "123", password_confirmation: "123") }

    before do
      sign_in(auth_user)
    end

    it "deactivates the user and terminates their sessions" do
      target_user = create(:user, password: "123", password_confirmation: "123")
      target_user.sessions.create!(user_agent: "Test", ip_address: "127.0.0.1")

      expect do
        delete admin_user_path(target_user)
      end.not_to change(User, :count)

      expect(response).to redirect_to(admin_users_path(locale: I18n.locale))
      expect(target_user.reload.deleted_at).to be_present
      expect(target_user.sessions).to be_empty
    end

    it "does not allow an administrator to deactivate their own account" do
      expect do
        delete admin_user_path(auth_user)
      end.not_to change(User, :count)

      expect(response).to redirect_to(admin_users_path(locale: I18n.locale))
      expect(auth_user.reload.deleted_at).to be_nil
      expect(flash[:alert]).to eq(I18n.t("authentication.users.cannot_deactivate_self"))
    end
  end
end
