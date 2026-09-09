# Changelog

## 2026-09-09

- Changed mandates to reference `clients.client_id` and instalments to reference `mandates.mandate_id`, allowing business references to change independently of relationships.
- Added `instalment_number`, with uniqueness enforced per mandate using `(mandate_id, instalment_number)`.
- Added a `mandate_id` foreign key to presentments and populated it for all eight sample presentments.
- Expanded sample data to eight mandates and twenty instalments, including multiple mandates per client and numbered instalments per mandate.
- Updated mandate status values to `ACTIVE`, `COMPLETE`, `INVALID` and `CANCELLED`.
- Updated sample instalment statuses to cover `COMPLETE`, `INCOMPLETE`, `RESCHEDULED`, `ACTIVE`, `CANCELLED` and `INVALID`.
- Updated sample inserts to resolve generated IDs through lookups rather than hard-coded numeric IDs.
- Added an investigation query joining client, mandate, payment stream, frequency, instalment and presentment details, with a combined client name and distinct status aliases.
- Validated the revised schema and sample data in an isolated PostgreSQL transaction, including reference changes and matching presentment/instalment mandates; rolled back the test without updating existing tables.

## 2026-09-03

- Added database architecture documentation for the payments operations demo.
- Updated rebuild instructions to show portable PostgreSQL commands first.
- Added a local Windows `psql.exe` example for machines where PostgreSQL is not on the system `PATH`.
- Clarified the architecture rebuild workflow after resolving a merge conflict.
