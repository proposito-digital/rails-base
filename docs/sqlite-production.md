# SQLite in Production

Rails Base uses SQLite by default in every environment. In production, the primary application database and the databases used by Solid Cache, Solid Queue, and Solid Cable are stored under `storage/`. Kamal mounts that directory at `/rails/storage` on a persistent Docker volume configured in `config/deploy.yml`.

SQLite is a deliberate default for a small, single-server Rails application. It keeps the first deployment simple, but it is not the right database for every workload.

## When SQLite is a good production choice

SQLite is appropriate when all of the following are true:

- The application runs on one web server.
- Write traffic is low to moderate, without many concurrent writes.
- Short maintenance windows are acceptable.
- High availability and automatic database failover are not requirements.
- The team can monitor the server and restore a tested backup when needed.

Typical examples include internal tools, small customer portals, early-stage products, and applications with mostly read-oriented traffic.

## What the persistent volume contains

The default Kamal volume persists the entire `storage/` directory, not only the primary database. It includes:

- `production.sqlite3`, the primary application database;
- `production_cache.sqlite3`, Solid Cache data;
- `production_queue.sqlite3`, Solid Queue data;
- `production_cable.sqlite3`, Solid Cable data;
- locally stored Active Storage files, if the application uses local disk storage.

Changing the volume name when creating a project is important to prevent collisions between applications. Persisting the volume is necessary for normal operation, but it is not a backup strategy.

## Backup and restore expectations

Before the first deployment, define a backup process that copies the persistent data **off the production server**. The process should include the complete `storage/` directory so that the primary database, Solid databases, and local uploads stay consistent with the chosen recovery plan.

Document these operational details for each project:

1. Who owns the backup process and where backups are stored.
2. How often backups run and how long they are retained.
3. How to restore a backup without overwriting production data first.
4. When the restore procedure was last tested in a non-production environment.

Test a restore before relying on SQLite in production. A Docker volume surviving a container restart does not protect against server loss, accidental deletion, corrupted data, or an unsuccessful deployment.

## When to move to PostgreSQL

Plan a PostgreSQL migration when one or more of these signals appears:

- The application needs multiple web servers or separate job servers that write concurrently.
- Database lock contention, slow writes, or queue delays become visible in monitoring or logs.
- The product requires high availability, replicas, managed backups, point-in-time recovery, or database-level access controls.
- The data volume or query workload exceeds what one server can reliably handle.
- The team needs managed operational tooling that is better supported by a PostgreSQL provider.

Rails Base does not include a PostgreSQL production configuration by default. Treat the migration as a planned infrastructure change: provision the database, add the adapter and connection configuration, migrate data, validate in staging, rehearse rollback, and only then switch production traffic.

## Decision checklist

Use SQLite only after confirming:

- [ ] The application will initially run on a single server.
- [ ] The persistent volume has a project-specific name.
- [ ] Backups are stored outside the server.
- [ ] A restore has been tested outside production.
- [ ] The team has agreed on the conditions that trigger a PostgreSQL migration.

For the full launch sequence, use the [first deployment checklist](first-deploy.md). See [backing up and restoring SQLite production data](sqlite-backup-and-restore.md) for the operational recovery procedure, and [migrating from SQLite to PostgreSQL](sqlite-to-postgresql.md) for the recommended migration path.