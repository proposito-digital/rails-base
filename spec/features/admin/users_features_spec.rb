require 'rails_helper'

describe "integration teste for user", type: :feature do
  let(:user) { create(:user, :admin, email_address: "auth@example.com") }

  around do |example|
    previous_locale = I18n.locale
    I18n.locale = :"pt-br"
    example.run
    I18n.locale = previous_locale
  end

  before(:each) do
    sign_in_via_ui user
  end

  it "access index page" do
    user = create(:user)
    visit admin_users_path
    expect(page).to have_content user.email_address
  end

  it "create user" do
    visit new_admin_user_path(locale: I18n.locale)
    within("#new_user") do
      fill_in "user[email_address]", with: "new_user@example.com"
      fill_in "user[password]", with: "123"
      find("[type='submit']").click
    end
    expect(page).to have_content "foi criado com sucesso."
    expect(page).to have_content "new_user@example.com"
  end

  it "edit user" do
    user = create(:user)
    visit admin_users_path
    within("#tr_User_#{user.id}") do
      click_link "Editar"
    end
    within(".edit_user") do
      fill_in "user[email_address]", with: "edited_user@example.com"
      find("[type='submit']").click
    end
    expect(page).to have_content "foi atualizado com sucesso."
    expect(page).to have_content "edited_user@example.com"
  end

  it "show user" do
    user = create(:user)
    visit admin_users_path
    within("#tr_User_#{user.id}") do
      click_link "Visualizar"
    end
    expect(page).to have_field("user_email_address", with: user.email_address, disabled: true)
  end

  it "deactivate user" do
    target_user = create(:user)
    create_list(:user, 2)
    visit admin_users_path
    page.execute_script("document.querySelector('#modal_destroy_#{target_user.id} a[data-turbo-method=\"delete\"]').click()")
    expect(page).to have_content "foi removido com sucesso."
    expect(page).to have_no_content target_user.email_address
  end

  it "filter user" do
    visible_user = create(:user, email_address: "filter-visible@example.com")
    hidden_user = create(:user, email_address: "filter-hidden@example.com")

    visit admin_users_path
    within("#form_search") do
      fill_in "term", with: visible_user.email_address
      find("button[type='submit']").click
    end

    expect(page).to have_css("table tbody tr", text: visible_user.email_address)
    expect(page).to have_no_css("table tbody tr", text: hidden_user.email_address)
  end

  it "paginate user" do
    create_list(:user, 11)
    total_users = User.count

    visit admin_users_path
    expect(page).to have_css("table tbody tr", count: 10)

    visit admin_users_path(page: 2)
    expect(page).to have_css("table tbody tr", count: total_users - 10)
  end

  it "ordenation user" do
    emails = ("a".."j").to_a.map { |letter| "#{letter}@example.com" }
    emails.each { |email| create(:user, email_address: email) }

    visit admin_users_path

    expect(page).to have_css("table tbody tr:first-child", text: "j@example.com")

    find("a[href*='sort_column=email_address'][href*='sort_direction=asc']").click
    expect(page).to have_current_path(admin_users_path(locale: I18n.locale, sort_direction: "asc", sort_column: "email_address"))
    expect(page).to have_css("table tbody tr:first-child", text: "a@example.com")

    find("a[href*='sort_column=email_address'][href*='sort_direction=desc']").click
    expect(page).to have_current_path(admin_users_path(locale: I18n.locale, sort_direction: "desc", sort_column: "email_address"))
    expect(page).to have_css("table tbody tr:first-child", text: "j@example.com")
  end
end
