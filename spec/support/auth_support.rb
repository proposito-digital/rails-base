module AuthSupport
  def sign_in(user)
    post session_path, params: { email_address: user.email_address, password: user.password }
  end

  def sign_in_as_a_valid_user
    user = FactoryBot.create(:user)
    post session_path, params: { email_address: user.email_address, password: user.password }
  end

  def sign_in_via_ui(user)
    visit new_session_path
    fill_in "email_address", with: user.email_address
    fill_in "password", with: "123"
    click_button type: "submit"
  end

  def sign_out
    delete session_path
  end
end
