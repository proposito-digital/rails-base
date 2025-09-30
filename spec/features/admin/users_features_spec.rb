require 'rails_helper'

describe "integration teste for user", :type => :feature do
  let(:user) { create(:user) }

  before(:each) do
    sign_in user
  end

  it "access index page" do
    user = create(:user)
    visit admin_users_path  
    expect(page).to have_content user.name
  end

  it "create user" do
    visit admin_users_path
    click_link 'Adicionar'
    within("#new_user") do
      fill_in 'user[name]', with: '#change_here'
    end
    click_button 'Salvar'
    expect(page).to have_content 'foi criado com sucesso.'
  end

  it "edit user" do
    user = create(:user)
    visit admin_users_path
    within("#tr_User_#{user.id}") do
      click_link 'Editar'
    end
    within(".edit_user") do
      fill_in'user[name]', with: '#change_here'
    end    
    click_button 'Salvar'
    expect(page).to have_content 'foi atualizado com sucesso.'
  end

  it "show user" do
    user = create(:user)
    visit admin_users_path
    within("#tr_User_#{user.id}") do
      click_link 'Visualizar'
    end
    expect(page).to have_xpath("//input[@value='#{user.name}']") 
  end

  it "delete user" do
    create_list(:user, 2)
    users = User.all()
    visit admin_users_path
    within("#tr_User_#{users.first.id}") do
      find("a[title='Remover']").click
    end
    within("#modal_destroy_#{users.first.id}") do 
      click_link('Remover')
    end
    expect(page).to have_content 'foi removido com sucesso.'
  end

  xit "filter user" do
    Capybara.current_driver = :poltergeist
    create_list(:user, 3)
    users = User.all()
    visit admin_users_path
    within("#form_search") do
      fill_in 'term' , with: users.last.name
    end
    find("input[name=term]").native.send_keys :enter
    expect(page).to have_no_content users.first.name
    Capybara.use_default_driver 
  end

  it "paginate user" do
    create_list(:user, 11)
    users = User.all()

    visit admin_users_path
    
    find('#page_next').click
    expect(page).to have_content users.first.name

    find('#page_previous').click
    expect(page).to have_no_content users.first.name
  end

  it "ordenation user" do
    names = ('a'..'j').to_a.map{|letter| {name: letter} }
    names.map { |name| create(:user, name) }
    users = User.all()

    visit admin_users_path

    expect(page).to have_css("table tbody tr:first-child td:first-child", text: 'j')

    click_link 'Name' #change_here
    expect(page).to have_current_path(admin_users_path(sort_direction: 'asc', sort_column: 'users.name'))
    expect(page).to have_css("table tbody tr:first-child td:first-child", text: 'a')
    
    click_link 'Name' #change_here
    expect(page).to have_current_path(admin_users_path(sort_direction: 'desc', sort_column: 'users.name'))
    expect(page).to have_css("table tbody tr:first-child td:first-child", text: 'j')
    
  end

end