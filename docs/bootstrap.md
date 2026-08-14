# Bootstrap a New Project

Use this guide to start a new application from Rails Base. It deliberately covers only the safe, repeatable first steps; project naming, deployment settings, credentials, and email configuration are documented separately.

## 1. Create the repository

Prefer GitHub's **Use this template** action. It creates a new repository without the Rails Base commit history.

If you need to clone the repository instead, create a new empty remote first and replace the Git remote:

```bash
git clone <rails-base-repository-url> <your-project-directory>
cd <your-project-directory>
git remote remove origin
git remote add origin <your-new-repository-url>
git push -u origin main
```

Use a project-specific directory name. Do not start application work directly in the Rails Base repository.

## 2. Open the development environment

Open the new repository in VS Code and select **Reopen in Container**. The Dev Container installs the required Ruby version, SQLite, Chrome, and system packages.

After the container is ready, prepare the application:

```bash
bin/setup --skip-server
```

Start the development processes:

```bash
bin/dev
```

Open `http://localhost:3000` and confirm that the home page loads. The administrative area is available at `/admin`.

## 3. Establish the project baseline

Before adding project-specific code:

1. Update the application name by following the [renaming guide](renaming.md).
2. Review the sample users created by `db/seeds.rb`; they are for local development only.
3. Replace or remove sample CRUD entities, translations, images, and company-specific text.
4. Configure credentials and environment variables before connecting external services.
5. Create a branch for the first application change instead of committing directly to `main`.

## 4. Validate the starting point

Run the same checks required by pull requests:

```bash
bin/rubocop
bin/brakeman --no-pager
bin/importmap audit
bin/rails tailwindcss:build
bin/rails db:prepare
bundle exec rspec
```

Fix failures before beginning feature development. This confirms that the new repository starts from a known-good version of Rails Base.

## Next steps

- [Rename the application](renaming.md).
- [Configure credentials, environment variables, and email](configuration.md).
- [Set up local development](development.md).
- Complete the [first deployment checklist](first-deploy.md).
- Complete the [new project delivery checklist](project-delivery.md).
- Read the main [README](../README.md) for administrative CRUD generation and daily development commands.
