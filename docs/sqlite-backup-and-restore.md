# Backing Up and Restoring SQLite Production Data

Rails Base stores SQLite production data under `storage/`. Kamal persists that directory through the volume declared in `config/deploy.yml`. The volume is required for the application to survive container replacement, but it remains attached to the production server and is not a backup.

This guide defines the minimum operational procedure. It intentionally does not prescribe a backup command because Rails Base does not include a backup provider, scheduler, or remote-storage integration. Each project must choose and implement one.

## What to back up

Back up the complete `storage/` directory, including:

- the primary application database: `production.sqlite3`;
- Solid Cache, Solid Queue, and Solid Cable databases;
- local Active Storage files, when the application uses local disk storage.

Keep the backup outside the production server, such as encrypted object storage or another controlled backup system. A copy on the same server does not protect against server loss.

## Define the backup procedure

Before production launch, record the project-specific procedure in its operations documentation:

1. **Owner:** the team or service responsible for creating and checking backups.
2. **Schedule and retention:** how often backups run, how long they are kept, and how old the newest successful backup may be.
3. **Destination and encryption:** where encrypted copies live and who can access them.
4. **Consistency method:** how the application and SQLite files are kept consistent while a backup is made.
5. **Alerting:** how failed jobs or stale backups reach the responsible team.

A backup tool must copy the data safely while SQLite may be receiving writes. Select and test a consistency method suitable for the chosen tool; do not copy live database files casually during application activity.

## Restore procedure

Perform every first restore in a non-production environment. Do not overwrite production data as an experiment.

1. Identify the backup timestamp and confirm it is complete and decryptable.
2. Create an isolated environment with the same application version and expected storage layout.
3. Stop application processes that could access or write the restored data.
4. Restore the complete `storage/` directory to the persistent storage location.
5. Start the application and run the required migrations only after confirming they match the restored release.
6. Verify application records, local uploads, jobs, and critical authentication flows.
7. Record the result, duration, and any corrective action.

For a production recovery, use the same tested procedure during a planned maintenance window. Preserve the failed or current data until the recovery owner has approved replacement.

## Restore testing cadence

Test restoration before launch, after changing backup tooling or storage, and on a regular schedule appropriate to the product's recovery requirements. A successful backup is not sufficient evidence; only a successful restore proves that data can be recovered.

## Related guides

- [SQLite in production](sqlite-production.md) explains when this database strategy is appropriate.
- [First deployment checklist](first-deploy.md) includes the required launch checks.
- [Migrating from SQLite to PostgreSQL](sqlite-to-postgresql.md) describes the next database strategy when SQLite no longer fits.