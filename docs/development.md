# Local Development

This guide describes the supported development environment for Rails Base. The recommended path is the VS Code Dev Container because it provides the same Ruby, SQLite, and browser-testing dependencies used by the project.

## Dev Container (recommended)

1. Install Docker and VS Code with the **Dev Containers** extension.
2. Open the project directory in VS Code.
3. Select **Reopen in Container**.
4. Wait for the post-create command to finish. It runs:

```bash
bin/setup --skip-server
```

The container exposes the application on port 3000 and provides a Selenium Chrome service for feature specs.

If dependencies, migrations, or configuration change, run the setup command again:

```bash
bin/setup --skip-server
```

## Manual setup

When a Dev Container is not available, install:

- the Ruby version declared in `.ruby-version`;
- Bundler;
- SQLite;
- Google Chrome and the browser-driver dependencies used by Selenium;
- build tools required by native gems.

Then run:

```bash
bin/setup --skip-server
```

Manual environments are not the primary support target, so prefer the container when browser tests or system libraries cause problems.

## Run the application

Start Rails and the Tailwind watcher together:

```bash
bin/dev
```

The application is available at `http://localhost:3000`. The administrative area is at `http://localhost:3000/admin`.

To run only Rails:

```bash
bin/rails server
```

## Database and sample data

Prepare the database after pulling changes or switching branches:

```bash
bin/rails db:prepare
```

Reset local data only when it is safe to discard it:

```bash
bin/rails db:reset
bin/rails db:seed
```

The project also provides a development initialization task:

```bash
bin/rails rails_base:db:init
```

It creates, migrates, and seeds the local database. The seeded accounts are documented in the main [README](../README.md).

## Daily validation

Before opening a pull request, run the commands in [Quality and local validation](../README.md#quality-and-local-validation). They match the checks required by GitHub Actions.

Useful focused commands:

```bash
bundle exec rspec spec/requests
bundle exec rspec spec/features
bin/rubocop -a
bin/brakeman --no-pager
```

Use `bin/rubocop -a` for safe automatic corrections. Use `bin/rubocop -A` only after reviewing the broader changes it may make.

## Common recovery steps

- Dependencies changed: run `bin/setup --skip-server`.
- A migration is pending: run `bin/rails db:prepare`.
- CSS changes are not updating: restart `bin/dev`.
- Feature specs cannot reach Chrome: reopen or rebuild the Dev Container, then rerun the specs.
