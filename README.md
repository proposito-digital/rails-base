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

If the command above fails with a "Permission denied" error, run the command below to fix the permissions and try again:

~~~bash
$ chmod +x ./bin/dev
~~~

this run Procfile.dev fit at root directory and will run:

~~~
web: bin/rails server -p 3000
css: bin/rails tailwindcss:watch
~~~

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

## Tailwind CSS https://tailwindcss.com/

A utility-first CSS framework for quickly building modern interfaces directly in your markup.

## Preline UI https://preline.co/

A Tailwind CSS component library used in this project for interactive UI patterns like dropdowns, collapse and overlays, initialized through Importmap.

## SVG Icons (rails_icons + Lucide)

This project uses [`rails_icons`](https://github.com/Rails-Designer/rails_icons) with `lucide` as the default icon library.

Use icons in views with:

~~~erb
<%= icon "search", class: "size-4" %>
~~~

### How to add a new icon

1. Choose an icon name from https://lucide.dev/icons (example: `circle-check`).
2. Download only that SVG into the project icon folder:

    ~~~bash
    ICON=circle-check
    curl -Ls "https://raw.githubusercontent.com/lucide-icons/lucide/main/icons/${ICON}.svg" \\
      -o "app/assets/svg/icons/lucide/outline/${ICON}.svg"
    ~~~

3. Use it in ERB:

    ~~~erb
    <%= icon "circle-check", class: "size-4" %>
    ~~~

### Notes

- The icon preview route is available at `/rails_icons` and is configured by:

~~~ruby
# config/routes.rb
mount RailsIcons::Engine, at: "/rails_icons"
~~~
- To sync the full Lucide library again (1500+ files), run:

~~~bash
bin/rails generate rails_icons:sync --library=lucide
~~~

# How to use the project
## How to Update dependencies

~~~bash
$ bundle install
~~~

## How to create a new entity (CRUD admin)

### 1) Initialize database and seed data
~~~bash
$ bin/rails proposito:db:init
~~~

### 2) Generate scaffold (without namespace)
~~~bash
$ bin/rails generate scaffold Bird name:string age:integer deleted_at:datetime:index
~~~

Use only the entity name (`Dog`, `Bird`, `User`, etc.).  
Do **not** generate with namespace (avoid `admin/bird`), because that creates namespaced models/factories (`app/models/admin/bird.rb`, `app/models/admin.rb`, `spec/factories/admin/...`) and increases maintenance complexity.

This project uses `my_scaffold_controller` automatically (`config/application.rb`), so the scaffold is wired to the admin area.

### 3) Run migration
~~~bash
$ bin/rails db:migrate
~~~

### 4) What is generated by scaffold here
Running scaffold for `Bird` generates, among others:

- `db/migrate/*_create_birds.rb`
- `app/models/bird.rb`
- `app/controllers/admin/birds_controller.rb`
- `app/helpers/admin/birds_helper.rb`
- `app/policies/bird_policy.rb`
- `spec/factories/birds.rb`
- `spec/models/bird_spec.rb`
- `spec/policies/bird_policy_spec.rb`
- `spec/features/admin/birds_features_spec.rb`
- `spec/requests/admin/birds_request_spec.rb`
- `spec/helpers/admin/birds_helper_spec.rb`
- `spec/routing/admin/birds_request_spec.rb`

Routes are normalized by generator to stay in admin namespace:

~~~ruby
namespace :admin do
  resources :birds
end
~~~

### 5) Add translations required by CRUD
Minimum translation keys:

~~~yml
# config/locales/pt-BR.yml
pt-br:
  birds:
    single: "Pássaro"
    plural: "Pássaros"
  activerecord:
    attributes:
      bird:
        name: "Nome"
        age: "Idade"
~~~

~~~yml
# config/locales/en.yml
en:
  birds:
    single: "Bird"
    plural: "Birds"
  activerecord:
    attributes:
      bird:
        name: "Name"
        age: "Age"
~~~

Notes:

- Sidebar labels use `t("<plural>.plural")` (example: `t("birds.plural")`).
- Form/table labels use `activerecord.attributes.<model>.<attribute>`.
- Generic view texts and flash messages already have base fallbacks in `views.application.*` and `controllers.generic.*`.

### 6) Add item to sidebar (with icon and policy)
Edit `app/controllers/concerns/sidebar_concerns.rb`:

~~~ruby
{
  name: t("birds.plural"),
  icon: "bird",
  policy: :bird,
  url: { controller: "birds", action: "index" },
  active: controller_path == "admin/birds"
}
~~~

Important:

- `icon` must be a valid Lucide icon name used by `rails_icons`.
- `policy(menu_item[:policy]).menu?` is checked in sidebar rendering, so keep a valid policy (example: `BirdPolicy`).

### 7) How to add icon specifically for sidebar
1. Choose icon name in https://lucide.dev/icons (example: `bird`, `paw-print`, `square-pen`).
2. If icon is not available in project, download SVG:

    ~~~bash
    ICON=bird
    curl -Ls "https://raw.githubusercontent.com/lucide-icons/lucide/main/icons/${ICON}.svg" \
      -o "app/assets/svg/icons/lucide/outline/${ICON}.svg"
    ~~~

3. Use this name in sidebar item (`icon: "bird"`).
4. Preview icon library in `/rails_icons`.

### 8) Review generated tests and factories
- Update generated factory values in `spec/factories/*`.
- Feature template has placeholders (`#change_here`) for manual adjustments in form filling.
- Keep request/routing/helper specs generated by scaffold.

### 9) Run tests
~~~bash
$ bundle exec rspec
~~~

### 10) Access admin page
~~~
url: localhost:3000/admin
user: test@test.com
password: test@123
or
user: dev@dev.com
password: test@123
~~~

If you have any question send e-mail to contact@proposito.digital .
