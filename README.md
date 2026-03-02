README
===

![Propósito Digital logo](app/assets/images/logo-proposito.png)

This is a project of [Propósito Digital](http://www.proposito.digital) that uses the Ruby on Rails framework with its customizations and its development methodology that serves as the basis for the projects developed by the company

# Roadmap

## Changing for Clickup

# Devcontainer
This project use Devcontainer, just open the project folder in a VS Code and open in Devcontainer mode.

# Run the project

In terminal use run the project for development with this command:

~~~bash
$ ./bin/dev
~~~

this run Procfile.dev fit at root directory and will run:

web: bin/rails server -p 3000
css: bin/rails dartsass:watch


# Infrastructure
## Docker https://www.docker.com/

Docker takes away repetitive, mundane configuration tasks and is used throughout the development lifecycle for fast, easy and portable application development – desktop and cloud. Docker’s comprehensive end to end platform includes UIs, CLIs, APIs and security that are engineered to work together across the entire application delivery lifecycle.

## Bumpversion 

works with a file called VERSION in the current directory, the contents of which should be a semantic version number such as "1.2.3 this script will display the current version, automatically suggest a "minor" version update, and ask for input to use the suggestion, or a newly entered value once the new version number is determined, the script will pull a list of changes from git history, prepend this to a file called CHANGES (under the title of the new version number) and create a GIT tag. 

~~~bash
$ . bumpversion.sh
~~~

# Core
## Ruby 3.4.8 https://www.ruby-lang.org/en/

A dynamic, open source programming language with a focus on simplicity and productivity. It has an elegant syntax that is natural to read and easy to write.

## Ruby on Rails 8.1.2 https://rubyonrails.org/

Rails has united and cultivated a strong tribe around a wide set of heretical thoughts about the nature of programming and programmers. Understanding these thoughts will help you understand the design of the framework.

## The bests Ruby Gems https://rubygems.org/

RubyGems.org is the Ruby community’s gem hosting service. Instantly publish your gems and then install them. Use the API to find out more about available gems. Become a contributor and improve the site yourself.

See Gemfile at root of project.

## Importmaps https://github.com/rails/importmap-rails

Import maps let you import JavaScript modules using logical names that map to versioned/digested files – directly from the browser. So you can build modern JavaScript applications using JavaScript libraries made for ES modules (ESM) without the need for transpiling or bundling. This frees you from needing Webpack, Yarn, npm, or any other part of the JavaScript toolchain. All you need is the asset pipeline that's already included in Rails.

how to import a js npm library example:

~~~bash
$ importmap pin vue@2.6.11
~~~

check the file config/importmap.rb

# Frontend and Interface

## Hotwired https://hotwired.dev/

Hotwire is an alternative approach to building modern web applications without using much JavaScript by sending HTML instead of JSON over the wire. This makes for fast first-load pages, keeps template rendering on the server, and allows for a simpler, more productive development experience in any programming language, without sacrificing any of the speed or responsiveness associated with a traditional single-page application.

## Bootstrap 5.3.8 https://getbootstrap.com/

Quickly design and customize responsive mobile-first sites with Bootstrap, the world’s most popular front-end open source toolkit, featuring Sass variables and mixins, responsive grid system, extensive prebuilt components, and powerful JavaScript plugins.

## Bootstrap Icons 1.13.1 https://icons.getbootstrap.com/

Free, high quality, open source icon library with over 1,600 icons. Include them anyway you like—SVGs, SVG sprite, or web fonts. Use them with or without Bootstrap in any project.

# How to use the project
## How to Update dependencies

~~~bash
$ bundle install
~~~

## How to create a new Entity on the project

### Initialize database and seed it
~~~bash
$ rails proposito:db:init
~~~
### Create a new Entity
~~~bash
$ rails g scaffold Dog name:string age:integer deleted_at:datetime:index
~~~
### Run migration
~~~bash
$ rails db:migrate
~~~
### At linux change all created files from root to your linux user
~~~bash
sudo chown -R linux_user_name:linux_user_name rails-base/
~~~
### If you want add fields to filter in controller
~~~ruby
# app/controllers/admin/dogs_contoller.rb
def filter_fields
  ['dogs.name', 'dogs.age']
end
~~~
### Go to routes.rb and put the resources into the admin namespace
~~~ruby
#config/routes.rb
namespace :admin do
  resources :dogs
end
~~~

### Edit the locales file and add the translations
~~~ruby
#rails_base\config\locales\pt-BR.yml
pt-BR:
  dogs:
    single: "Cachorro"
      plural: "Cachorros"
~~~

~~~ruby
#rails_base\config\locales\pt-BR.yml
pt-BR:
  activerecord:
    attributes:
      dog:
        name: "Nome"
        age: "Idade"
~~~

### Edit Factory Girl file to add Faker to fields
~~~ruby
#spec/factories/dog.rb
FactoryBot.define do
  factory :dog do
    name { Faker::Name.unique.name }
    age { rand(100) }
    deleted_at {  }
  end
end
~~~
### Add entity to show in the sidebar menu
~~~ruby
# app/controllers/concerns/sidebar_concerns.rb
{
  name: 'Cachorros',
  icon: 'bi bi-house-heart',
  policy: :dog,
  url: { controller: 'dogs', action: 'index' }
}
~~~
### Make changes in features test file. Search for the tag #change_here and make the changes
~~~ruby
# spec/features/dogs_features_spec.rb
~~~
### Run tests
~~~bash
$ rspec
~~~
### Acess administrative page
~~~
url: localhost:3000\admin
user: test@test.com
password: test@123
or
user: dev@dev.com
password: test@123
~~~


If you haver any question send e-mail to contact@proposito.digital .