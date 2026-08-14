# Credentials, Environment Variables, and Email

Rails Base keeps application secrets in encrypted Rails credentials and injects the master key into production through Kamal. Keep secrets out of Git, source code, `.env` files committed to the repository, and `.kamal/secrets`.

## Credentials

Edit encrypted credentials locally:

```bash
EDITOR="code --wait" bin/rails credentials:edit
```

This command changes `config/credentials.yml.enc`. The file is safe to commit; the corresponding `config/master.key` is not.

Store production secrets in the deployment platform's secret manager. Kamal receives the master key through `.kamal/secrets`, which reads it from the local file or from a password-manager integration. Never replace that command with a raw key.

### Example SMTP credentials

Add only the values needed by the chosen provider:

```yml
smtp:
  user_name: "smtp-user"
  password: "smtp-password"
```

Do not use the example values in this guide in a real project.

## Environment variables

The current deployment configuration expects these secrets:

| Variable | Purpose | Where it is configured |
| --- | --- | --- |
| `RAILS_MASTER_KEY` | Decrypts Rails credentials in production. | `.kamal/secrets` and `config/deploy.yml` |
| `KAMAL_REGISTRY_PASSWORD` | Authenticates the container registry. | `.kamal/secrets` |
| `RAILS_LOG_LEVEL` | Optional production log verbosity. | `config/deploy.yml` |
| `APP_HOST` | Production domain used for allowed hosts and mailer links. | `config/deploy.yml` |

Use encrypted credentials for application secrets that Rails reads. Use environment variables for deployment-provided values and operational configuration. Document every new variable in this file or the project's deployment documentation.

## Email in development

Development uses file delivery. Password-reset emails are written locally instead of being sent to a real address. The default URL host is `localhost:3000`.

This is intentional: it allows authentication flows to be tested safely without SMTP credentials.

## Configure SMTP for production

In `config/environments/production.rb`:

1. Replace `example.com` in `config.action_mailer.default_url_options` with the production domain.
2. Uncomment the SMTP settings block.
3. Set `config.action_mailer.delivery_method = :smtp`.
4. Consider setting `config.action_mailer.raise_delivery_errors = true` after the provider is verified.

The existing SMTP block reads the username and password from Rails credentials:

```ruby
config.action_mailer.smtp_settings = {
  user_name: Rails.application.credentials.dig(:smtp, :user_name),
  password: Rails.application.credentials.dig(:smtp, :password),
  address: "smtp.example.com",
  port: 587,
  authentication: :plain
}
```

Replace the address, port, authentication method, and TLS settings with the values required by the selected provider. Send a password-reset email in a staging environment before the first production deploy.

## Verification checklist

Before deploying:

- Confirm `config/master.key` is not committed.
- Confirm `RAILS_MASTER_KEY` is available to Kamal.
- Confirm the production URL host is the real domain.
- Send a password-reset email from staging.
- Confirm messages do not expose passwords, tokens, or credentials in logs.
