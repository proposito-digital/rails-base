module AuthSupport
  def sign_in(user)
    post session_path, params: { email_address: user.email_address, password: user.password }
  end

  def sign_in_as_a_valid_user
    user = FactoryBot.create(:user, :admin)
    post session_path, params: { email_address: user.email_address, password: user.password }
  end

  def sign_in_via_ui(user)
    visit new_session_path(locale: I18n.locale)
    fill_in "email_address", with: user.email_address
    fill_in "password", with: (user.password || "123")
    click_button "Sign in"
    expect(page).to have_current_path(root_path, ignore_query: true)
  end

  def sign_out
    delete session_path
  end
end
