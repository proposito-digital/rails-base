# Migrating from SQLite to PostgreSQL

Use this guide when Rails Base has outgrown its default SQLite production setup. This is an infrastructure and application-configuration migration, not a routine deploy. The repository currently includes SQLite only; it does not ship a PostgreSQL adapter, connection configuration, or data-transfer tool.

Plan the migration before the application needs multiple writers, high availability, or managed database recovery. See [SQLite in production](sqlite-production.md) for the signals that should trigger this work.

## 1. Define the target operation

Before changing the application, agree on:

- the PostgreSQL provider or self-managed host;
- the database version, region, availability, backup, and recovery requirements;
- the connection, TLS, credential, and network-access model;
- an acceptable migration window and data-write strategy;
- the owner of the cutover and rollback decision.

Use a managed provider when its backup, monitoring, access control, and point-in-time recovery capabilities meet the application's operational needs.

## 2. Prepare a staging migration

Assign the application and infrastructure changes to the appropriate specialists. At minimum, the migration requires:

1. Adding the PostgreSQL adapter dependency.
2. Adding production connection configuration without committing credentials.
3. Providing the database host and connection settings through the deployment environment.
4. Provisioning an empty PostgreSQL database and restricted application credentials.
5. Rehearsing a data transfer from a production-like SQLite backup.
6. Running migrations and the full application test suite against PostgreSQL in staging.

Keep SQLite production running while the staging rehearsal is validated. Do not point production at PostgreSQL until the application can connect, migrate, read, and write correctly in staging.

## 3. Plan data transfer and cutover

Choose a migration method that preserves the application's required records and relationships. Test it with a copy of production data first.

For the production cutover:

1. Take and verify an off-server backup of the complete SQLite `storage/` directory.
2. Put the application into a planned maintenance window or otherwise prevent new writes.
3. Take a final SQLite backup after writes stop.
4. Transfer the primary application data to PostgreSQL using the rehearsed method.
5. Run Rails migrations against PostgreSQL.
6. Deploy the PostgreSQL configuration and restart the application.
7. Verify login, critical reads and writes, jobs, and application logs before reopening writes.

The Solid Cache, Solid Queue, and Solid Cable databases are separate SQLite files in the default setup. Decide explicitly whether each service remains SQLite-backed, moves to PostgreSQL, or is replaced by another supported backend. Do not assume moving the primary database migrates those services.

## 4. Validate and monitor

After staging and production cutovers, verify:

- the application connects only with its intended restricted credential;
- pending migrations are clear;
- login, password reset, administrative CRUD, jobs, and cache-dependent flows work;
- database errors, connection exhaustion, and query latency are monitored;
- PostgreSQL backups and a restore procedure are configured and tested.

Keep the final SQLite backup until the new production deployment is stable and the rollback window has closed.

## Rollback boundary

A rollback after accepting new writes in PostgreSQL requires a separate reverse data-migration plan. Do not treat `bin/kamal rollback` alone as a database rollback. If validation fails before new writes are accepted, return to the previous SQLite deployment and preserve the evidence needed to diagnose the failed cutover.

## Completion checklist

- [ ] PostgreSQL infrastructure, access controls, and backups are provisioned.
- [ ] The application adapter and production connection configuration have been reviewed.
- [ ] A production-like migration has passed in staging.
- [ ] The cutover, validation, and rollback owners are assigned.
- [ ] A final SQLite backup is stored off-server before production cutover.
- [ ] PostgreSQL restore has been tested outside production.