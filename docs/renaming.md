# Rename Rails Base for a New Project

Rename Rails Base before the first deployment. Use one lowercase, hyphen-free identifier for infrastructure values, such as `client_portal`, and one PascalCase constant for the Rails module, such as `ClientPortal`.

> These steps describe a new application. If the application has already been deployed, changing the Kamal service or storage volume can create a second deployment or disconnect it from existing SQLite data. Plan and test that migration first.

## 1. Choose the names

| Purpose | Example |
| --- | --- |
| Repository and directory | `client-portal` |
| Rails module | `ClientPortal` |
| Kamal service | `client_portal` |
| Docker image | `your-registry/client_portal` |
| Persistent volume | `client_portal_storage` |

## 2. Rename the Rails module

In `config/application.rb`, replace:

```ruby
module RailsBase
```

with the project module:

```ruby
module ClientPortal
```

Keep the file name unchanged. Restart the Rails server after this change.

## 3. Rename deployment resources

In `config/deploy.yml`, update all project-specific values:

```yml
service: client_portal
image: your-registry/client_portal

volumes:
  - "client_portal_storage:/rails/storage"
```

Also update any commented accessory host examples that use the old service name, such as `rails_base-db`.

## 4. Rename local container and PWA metadata

Update these values so local tooling and installable-app metadata identify the new project:

- `.devcontainer/compose.yaml`: the top-level `name`.
- `.devcontainer/devcontainer.json`: the `name`.
- `app/views/pwa/manifest.json.erb`: `name`, `short_name`, and `description`.
- `Dockerfile`: the example image and container names in the introductory comments.

## 5. Confirm there are no remaining references

From the project root, search for the original module and infrastructure name:

```bash
grep -RIn --exclude-dir=.git --exclude-dir=vendor -e RailsBase -e rails_base .
```

Review every result. Replace project-specific names, but leave generic documentation alone when it is still accurate.

## 6. Validate the renamed application

Run the standard checks:

```bash
bin/setup --skip-server
bin/rubocop
bin/brakeman --no-pager
bin/rails db:prepare
bundle exec rspec
```

Then rebuild the Dev Container. Before production, confirm the Kamal image name, service name, hosts, domain, registry credentials, and persistent volume.
