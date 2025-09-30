require 'rails_helper'

describe "integration teste for dog", :type => :feature do
  let(:user) { create(:user) }

  before(:each) do
    sign_in user
  end

  it "access index page" do
    dog = create(:dog)
    visit admin_dogs_path  
    expect(page).to have_content dog.name
  end

  it "create dog" do
    visit admin_dogs_path
    click_link 'Adicionar'
    within("#new_dog") do
      fill_in 'dog[name]', with: '#change_here'
      fill_in 'dog[age]', with: '#change_here'
    end
    click_button 'Salvar'
    expect(page).to have_content 'foi criado com sucesso.'
  end

  it "edit dog" do
    dog = create(:dog)
    visit admin_dogs_path
    within("#tr_Dog_#{dog.id}") do
      click_link 'Editar'
    end
    within(".edit_dog") do
      fill_in'dog[name]', with: '#change_here'
      fill_in'dog[age]', with: '#change_here'
    end    
    click_button 'Salvar'
    expect(page).to have_content 'foi atualizado com sucesso.'
  end

  it "show dog" do
    dog = create(:dog)
    visit admin_dogs_path
    within("#tr_Dog_#{dog.id}") do
      click_link 'Visualizar'
    end
    expect(page).to have_xpath("//input[@value='#{dog.name}']") 
  end

  it "delete dog" do
    create_list(:dog, 2)
    dogs = Dog.all()
    visit admin_dogs_path
    within("#tr_Dog_#{dogs.first.id}") do
      find("a[title='Remover']").click
    end
    within("#modal_destroy_#{dogs.first.id}") do 
      click_link('Remover')
    end
    expect(page).to have_content 'foi removido com sucesso.'
  end

  xit "filter dog" do
    Capybara.current_driver = :poltergeist
    create_list(:dog, 3)
    dogs = Dog.all()
    visit admin_dogs_path
    within("#form_search") do
      fill_in 'term' , with: dogs.last.name
    end
    find("input[name=term]").native.send_keys :enter
    expect(page).to have_no_content dogs.first.name
    Capybara.use_default_driver 
  end

  it "paginate dog" do
    create_list(:dog, 11)
    dogs = Dog.all()

    visit admin_dogs_path
    
    find('#page_next').click
    expect(page).to have_content dogs.first.name

    find('#page_previous').click
    expect(page).to have_no_content dogs.first.name
  end

  it "ordenation dog" do
    names = ('a'..'j').to_a.map{|letter| {name: letter} }
    names.map { |name| create(:dog, name) }
    dogs = Dog.all()

    visit admin_dogs_path

    expect(page).to have_css("table tbody tr:first-child td:first-child", text: 'j')

    click_link 'Name' #change_here
    expect(page).to have_current_path(admin_dogs_path(sort_direction: 'asc', sort_column: 'dogs.name'))
    expect(page).to have_css("table tbody tr:first-child td:first-child", text: 'a')
    
    click_link 'Name' #change_here
    expect(page).to have_current_path(admin_dogs_path(sort_direction: 'desc', sort_column: 'dogs.name'))
    expect(page).to have_css("table tbody tr:first-child td:first-child", text: 'j')
    
  end

end