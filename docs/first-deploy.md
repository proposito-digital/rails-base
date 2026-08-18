# First Deployment Checklist

Use this checklist before deploying a new Rails Base application to production with Kamal. Complete every item in a staging environment first whenever possible.

## Application identity

- [ ] Rename the Rails module, Kamal service, Docker image, Dev Container, and PWA metadata.
- [ ] Replace the placeholder server address, `APP_HOST`, and domain in `config/deploy.yml`.
- [ ] Set the container registry username and image name.
- [ ] Confirm the DNS record for the production domain points to the deployment server.
- [ ] Confirm the proxy and certificate configuration matches the hosting provider.

## Secrets and email

- [ ] Keep `config/master.key` out of Git.
- [ ] Make `RAILS_MASTER_KEY` available to the deployment process.
- [ ] Make `KAMAL_REGISTRY_PASSWORD` available to the deployment process.
- [ ] Configure Rails credentials for the selected SMTP provider.
- [ ] Replace the production mailer host placeholder with the real domain.
- [ ] Send and receive a password-reset email in staging.

## Data and storage

- [ ] Choose the production database strategy: SQLite on a persistent volume or an external PostgreSQL database. Review [SQLite in production](sqlite-production.md) before choosing SQLite.
- [ ] If using SQLite, set a unique persistent-volume name in `config/deploy.yml`.
- [ ] Configure backups outside the server for the persistent volume. Follow [backing up and restoring SQLite production data](sqlite-backup-and-restore.md).
- [ ] Test restoring a backup in a non-production environment and record the result.
- [ ] Confirm migrations complete successfully against the production database. If using PostgreSQL, follow [the migration guide](sqlite-to-postgresql.md).

## Build and deploy

- [ ] Run the local quality checks: RuboCop, Brakeman, Importmap audit, asset build, database preparation, and RSpec.
- [ ] Confirm GitHub Actions is green on the commit being deployed.
- [ ] Log in to the container registry from the deployment environment.
- [ ] Run a dry-run or deploy to staging with Kamal.
- [ ] Deploy production with `bin/kamal deploy`.
- [ ] Monitor the deployment output until the new version is healthy.

## Post-deployment verification

- [ ] Open the application over HTTPS and check the home page.
- [ ] Check the health endpoint at `/up`.
- [ ] Sign in with a controlled administrator account.
- [ ] Confirm a regular user cannot access administrative CRUD pages.
- [ ] Create, edit, and deactivate a non-critical test record.
- [ ] Trigger and receive a password-reset email.
- [ ] Check application logs for unexpected errors.
- [ ] Confirm the backup job or procedure can access the persistent data.

## Rollback readiness

- [ ] Record the deployed image tag or Git commit.
- [ ] Confirm the team knows how to run `bin/kamal rollback`.
- [ ] Keep the previous release available until post-deployment verification is complete.
- [ ] Do not remove the persistent volume during rollback.

## Handoff

- [ ] Record the production domain, server ownership, registry, backup location, and secret-management owner.
- [ ] Document any project-specific operational commands.
- [ ] Confirm the support contact and incident path.
