README
===

![Propósito Digital logo](app/assets/images/logo-proposito.png)

This is a project of [Propósito Digital](http://www.proposito.digital) that uses the Ruby on Rails framework with its customizations and its development methodology that serves as the basis for the projects developed by the company

# Roadmap

<iframe src="https://trello.com/b/OJTXEAz7.html" frameBorder="0" width="100%" height="500"></iframe>

# Infrastructure
## Docker https://www.docker.com/

Docker takes away repetitive, mundane configuration tasks and is used throughout the development lifecycle for fast, easy and portable application development – desktop and cloud. Docker’s comprehensive end to end platform includes UIs, CLIs, APIs and security that are engineered to work together across the entire application delivery lifecycle.

To run the project use

~~~bash
$ docker-compose up 
~~~

## Dokku Ready https://dokku.com/

Docker takes away repetitive, mundane configuration tasks and is used throughout the development lifecycle for fast, easy and portable application development – desktop and cloud. Docker’s comprehensive end to end platform includes UIs, CLIs, APIs and security that are engineered to work together across the entire application delivery lifecycle.

## Bumpversion 

works with a file called VERSION in the current directory, the contents of which should be a semantic version number such as "1.2.3 this script will display the current version, automatically suggest a "minor" version update, and ask for input to use the suggestion, or a newly entered value once the new version number is determined, the script will pull a list of changes from git history, prepend this to a file called CHANGES (under the title of the new version number) and create a GIT tag. 

~~~bash
$ . bumpversion.sh
~~~

# Core
## Ruby 3.2.2 https://www.ruby-lang.org/en/

A dynamic, open source programming language with a focus on simplicity and productivity. It has an elegant syntax that is natural to read and easy to write.

## Ruby on Rails 7.1.2 https://rubyonrails.org/

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
## Vue 3.2.31 https://vuejs.org/

An approachable, performant and versatile framework for building web user interfaces.

## Bootstrap 5.3.2 https://getbootstrap.com/

Quickly design and customize responsive mobile-first sites with Bootstrap, the world’s most popular front-end open source toolkit, featuring Sass variables and mixins, responsive grid system, extensive prebuilt components, and powerful JavaScript plugins.

## Bootstrap Icons 1.11.0 https://icons.getbootstrap.com/

Free, high quality, open source icon library with over 1,600 icons. Include them anyway you like—SVGs, SVG sprite, or web fonts. Use them with or without Bootstrap in any project.

# How to use the project
## How to Update dependencies

~~~bash
$ docker-compose run app bundle install
~~~

## How to create a new Entity on the project

### Install and start app and database containers
~~~bash
$ docker-compose up
~~~
### Acess the container app
~~~bash
$  docker exec -it rails-base-app-1 /bin/bash
~~~
### Initialize database and seed it
~~~bash
$  rails proposito:db:init
~~~
### Create a new Entity
~~~bash
$ rails g scaffold Dog name:string age:integer deleted_at:datetime:index
~~~
### Run migration
~~~bash
$ docker-compose run app rails db:migrate
~~~
### At linux change all created files from root to your linux user
~~~bash
sudo chown -R $USER:$USER rails-base/
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

### Edit the lang file and add the translations
~~~ruby
#rails-base/config/locales/pt-BR.yml
pt-BR:
  dogs:
    single: "Cachorro"
      plural: "Cachorros"
~~~

~~~ruby
#rails-base/config/locales/pt-BR.yml
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

See if everythings works =D

If you haver any question send e-mail to contact@proposito.digital .