# New Project Delivery Checklist

Use this checklist when a project created from Rails Base is ready to be handed to a client, team, or maintainer. It complements the [first deployment checklist](first-deploy.md).

## Project identity and scope

- [ ] Replace the Rails Base name, logo, PWA metadata, sample copy, and company-specific references.
- [ ] Remove unused sample entities, routes, translations, images, and menu items.
- [ ] Confirm the application name, repository description, domain, and support contact.
- [ ] Confirm the user roles and administrative access match the project requirements.

## Product and data

- [ ] Remove development-only users and credentials from the production environment.
- [ ] Review seed data and make sure it cannot create unwanted production records.
- [ ] Confirm forms, validation messages, empty states, and error pages.
- [ ] Confirm the configured locales and translations are complete for the intended audience.
- [ ] Verify accessibility basics: labels, keyboard navigation, focus order, and contrast.

## Quality and security

- [ ] Run RuboCop, Brakeman, Importmap audit, asset build, database preparation, and RSpec.
- [ ] Confirm GitHub Actions is required and green for the release commit.
- [ ] Review authorization for every administrative resource and JSON endpoint.
- [ ] Confirm password reset, login rate limiting, session expiry, and deactivated-user behavior.
- [ ] Confirm production hosts, HTTPS, cookies, and security headers have been reviewed.
- [ ] Confirm secrets are not committed and access to the secret manager is limited.

## Operations and deployment

- [ ] Complete the [first deployment checklist](first-deploy.md).
- [ ] Confirm database backup, restore, retention, and ownership.
- [ ] Confirm log access, health checks, error monitoring, and alert ownership.
- [ ] Confirm the rollback procedure and the person responsible for using it.
- [ ] Record the deployed version, release date, domain, and infrastructure provider.

## Documentation and handoff

- [ ] Update the README with project-specific setup and development instructions.
- [ ] Document required third-party accounts, integrations, and environment variables.
- [ ] Document administration tasks: user management, backup, deployment, and recovery.
- [ ] Share access using the team's approved password manager; do not send credentials in chat or source control.
- [ ] Identify the maintenance owner and support contact.

## Final acceptance

- [ ] Run the core user journey in production or staging.
- [ ] Obtain confirmation that the project is ready for handoff.
- [ ] Archive the release notes and outstanding known issues.
