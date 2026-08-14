# Rails Base

![Propósito Digital logo](app/assets/images/logo-proposito.png)

A reusable Ruby on Rails foundation for starting new Propósito Digital applications. It includes authentication, an administrative area, authorization, internationalization, testing, a Hotwire/Tailwind interface, and a quality pipeline integrated with GitHub Actions.

## Table of contents

- [Included](#included)
- [Prerequisites](#prerequisites)
- [Quick start](#quick-start)
- [Bootstrap a new project](docs/bootstrap.md)
- [Rename a project](docs/renaming.md)
- [Configure credentials and email](docs/configuration.md)
- [Set up local development](docs/development.md)
- [Decide whether SQLite is suitable for production](docs/sqlite-production.md)
- [First deployment checklist](docs/first-deploy.md)
- [New project delivery checklist](docs/project-delivery.md)
- [Development](#development)
- [Local access](#local-access)
- [Creating an administrative CRUD](#creating-an-administrative-crud)
- [Icons](#icons)
- [Quality and local validation](#quality-and-local-validation)
- [Infrastructure and deployment](#infrastructure-and-deployment)
- [Updating dependencies and version](#updating-dependencies-and-version)
- [References](#references)

## Included

- Ruby 3.4.8 and Rails 8.1.3.
- SQLite, Solid Cache, Solid Queue, and Solid Cable.
- Session-based authentication and password reset.
- An administrative area with CRUD, pagination, search, and sorting.
- Pundit for authorization and Pagy for pagination.
- RSpec, FactoryBot, Capybara, and SimpleCov for testing.
- Hotwire, Importmap, Tailwind CSS, Preline, and Lucide icons.
- Dev Container, Docker, Kamal, GitHub Actions, Dependabot, RuboCop, and Brakeman.

## Prerequisites

The recommended way to work on this project is with the VS Code Dev Container. It installs Ruby, system dependencies, SQLite, and Selenium.

1. Open the project folder in VS Code.
2. Select **Reopen in Container** when VS Code prompts you.
3. Wait for `bin/setup --skip-server` to finish.

> Without the Dev Container, install the Ruby version specified in `.ruby-version`, Bundler, SQLite, Google Chrome, and the dependencies required to compile native gems.

## Quick start

Inside the Dev Container, prepare or update the environment:

```bash
bin/setup --skip-server
```

Start the development server and the CSS watcher:

```bash
bin/dev
```

The command runs `Procfile.dev`:

```text
web: bin/rails server -p 3000
css: bin/rails tailwindcss:watch
```

The application is available at `http://localhost:3000`.

## Development

### Database and sample data

To create, migrate, and seed the development database:

```bash
bin/rails rails_base:db:init
```

The development seed creates the users documented below. To apply migrations only, run:

```bash
bin/rails db:migrate
```

### Local access

The administrative area is available at `http://localhost:3000/admin`.

| Email | Password |
| --- | --- |
| `test@test.com` | `test@123` |
| `dev@dev.com` | `test@123` |

These credentials exist only in development. Never use them in production.

## Creating an administrative CRUD

The project automatically configures the `my_scaffold_controller` generator, which creates controllers in the administrative area and their related test files.

### 1. Generate the entity

Use only the entity name, without a namespace:

```bash
bin/rails generate scaffold Bird name:string age:integer deleted_at:datetime:index
```

Avoid `admin/bird`: it creates namespaced models and factories and adds unnecessary maintenance. The command above generates, among other files:

- a migration and model;
- an `Admin` controller and helper;
- a Pundit policy;
- factory and model, policy, feature, request, helper, and routing specs.

### 2. Run the migration

```bash
bin/rails db:migrate
```

The generator normalizes the route into the administrative area:

```ruby
namespace :admin do
  resources :birds
end
```

### 3. Add translations

Add the entity name and its attributes in `config/locales/pt-BR.yml` and `config/locales/en.yml`:

```yml
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
```

```yml
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
```

Sidebar labels use `birds.plural`; form and table fields use `activerecord.attributes.bird.<attribute>`.

### 4. Add the menu item

Edit `app/controllers/concerns/sidebar_concerns.rb`:

```ruby
{
  name: t("birds.plural"),
  icon: "bird",
  policy: :bird,
  url: { controller: "birds", action: "index" },
  active: controller_path == "admin/birds"
}
```

The policy must exist because the menu checks `policy(menu_item[:policy]).menu?` before rendering the item.

### 5. Review generated files

Before finishing, review the factory, policy, permitted parameters, feature specs, and translations. Feature templates include `#change_here` markers for form-specific adjustments.

## Icons

The project uses `rails_icons` with the Lucide library:

```erb
<%= icon "search", class: "size-4" %>
```

To add a single icon, download its SVG to the local library:

```bash
ICON=circle-check
curl -Ls "https://raw.githubusercontent.com/lucide-icons/lucide/main/icons/${ICON}.svg" \
  -o "app/assets/svg/icons/lucide/outline/${ICON}.svg"
```

The icon preview is available at `/rails_icons`. To synchronize the entire Lucide library, run:

```bash
bin/rails generate rails_icons:sync --library=lucide
```

## Quality and local validation

Run the following commands inside the Dev Container before opening a pull request. They mirror the GitHub Actions checks.

### Code style

```bash
bin/rubocop
```

### Security

```bash
bin/brakeman --no-pager
bin/importmap audit
```

### Build assets and run tests

```bash
bin/rails tailwindcss:build
bin/rails db:prepare
bundle exec rspec
```

### Run every check

```bash
bin/rubocop && \
  bin/brakeman --no-pager && \
  bin/importmap audit && \
  bin/rails tailwindcss:build && \
  bin/rails db:prepare && \
  bundle exec rspec
```

The `main` branch is protected: pull requests can be merged only after the security, lint, and test checks pass in GitHub Actions.

## Infrastructure and deployment

- `Dockerfile` defines the production image.
- `.devcontainer/` contains the reproducible development environment.
- `config/deploy.yml` contains the Kamal configuration.
- `.kamal/secrets` defines the secret names required for deployment.

Before the first deployment, configure the service name, image, servers, and domain in `config/deploy.yml`. Configure `RAILS_MASTER_KEY` and any other credentials through the production environment's secret manager.

The default configuration uses SQLite on a persistent volume. Before deploying, define a backup and restore strategy; for applications needing higher concurrency or high availability, evaluate PostgreSQL. See [SQLite in production](docs/sqlite-production.md) for decision criteria, backup expectations, and migration signals.

## Updating dependencies and version

To install the versions declared in the Gemfile:

```bash
bundle install
```

To update a specific dependency:

```bash
bundle update gem-name
```

To create a new semantic version, update `CHANGES`, and create a Git tag:

```bash
. bumpversion.sh
```

## References

- [Ruby](https://www.ruby-lang.org/)
- [Ruby on Rails](https://rubyonrails.org/)
- [Hotwire](https://hotwired.dev/)
- [Tailwind CSS](https://tailwindcss.com/)
- [Importmap](https://github.com/rails/importmap-rails)
- [Kamal](https://kamal-deploy.org/)

Questions: contact@proposito.digital.