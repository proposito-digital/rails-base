require 'rails_helper'

describe "integration teste for dog", type: :feature do
  let(:user) { create(:user, :admin, email_address: "auth@example.com") }

  before(:each) do
    sign_in_via_ui user
  end

  it "access index page" do
    dog = create(:dog)
    visit admin_dogs_path
    expect(page).to have_content dog.name
  end

  it "create dog" do
    visit new_admin_dog_path(locale: :"pt-br")
    within("#new_dog") do
      fill_in "dog[name]", with: "Bolt"
      fill_in "dog[age]", with: "5"
    end
    find("input[type='submit']").click
    expect(page).to have_content "foi criado com sucesso."
    expect(page).to have_content "Bolt"
  end

  it "edit dog" do
    dog = create(:dog)
    visit admin_dogs_path
    within("#tr_Dog_#{dog.id}") do
      click_link "Editar"
    end
    within(".edit_dog") do
      fill_in "dog[name]", with: "Scooby"
      fill_in "dog[age]", with: "7"
    end
    find("input[type='submit']").click
    expect(page).to have_content "foi atualizado com sucesso."
    expect(page).to have_content "Scooby"
  end

  it "show dog" do
    dog = create(:dog)
    visit admin_dogs_path
    within("#tr_Dog_#{dog.id}") do
      click_link "Visualizar"
    end
    expect(page).to have_field("dog_name", with: dog.name, disabled: true)
  end

  it "delete dog" do
    deleted_dog = create(:dog, name: "Bolt")
    kept_dog = create(:dog, name: "Rex")
    visit admin_dogs_path
    page.execute_script("document.querySelector('#modal_destroy_#{deleted_dog.id} a[data-turbo-method=\\\"delete\\\"]').click()")
    expect(page).to have_content "foi removido com sucesso."
    expect(page).to have_no_content deleted_dog.name
    expect(page).to have_content kept_dog.name
  end

  it "filter dog" do
    visible_dog = create(:dog, name: "DOG_FILTER_VISIBLE")
    hidden_dog = create(:dog, name: "DOG_FILTER_HIDDEN")

    visit admin_dogs_path
    within("#form_search") do
      fill_in "term", with: visible_dog.name
      find("button[type='submit']").click
    end

    expect(page).to have_css("table tbody tr", text: visible_dog.name)
    expect(page).to have_no_css("table tbody tr", text: hidden_dog.name)
  end

  it "paginate dog" do
    create_list(:dog, 11)
    total_dogs = Dog.count

    visit admin_dogs_path
    expect(page).to have_css("table tbody tr", count: 10)

    visit admin_dogs_path(page: 2)
    expect(page).to have_css("table tbody tr", count: total_dogs - 10)
  end

  it "ordenation dog" do
    names = ("a".."j").to_a
    names.each { |name| create(:dog, name: name) }

    visit admin_dogs_path

    expect(page).to have_css("table tbody tr:first-child", text: "j")

    find("a[href*='sort_column=name'][href*='sort_direction=asc']").click
    expect(page).to have_current_path(admin_dogs_path(locale: :"pt-br", sort_direction: "asc", sort_column: "name"))
    expect(page).to have_css("table tbody tr:first-child", text: "a")

    find("a[href*='sort_column=name'][href*='sort_direction=desc']").click
    expect(page).to have_current_path(admin_dogs_path(locale: :"pt-br", sort_direction: "desc", sort_column: "name"))
    expect(page).to have_css("table tbody tr:first-child", text: "j")
  end
end
