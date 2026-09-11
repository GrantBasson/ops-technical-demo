# Changelog

## 2026-09-11 — GUI screenshots and documentation

- Saved four user-provided GUI screenshots with descriptive filenames and added a README gallery.
- Updated documentation for separate SQL reports, dynamic columns, current Excel export behaviour and the AI-generated GUI.
- Documented captured results: 3 investigations, 5 unattempted instalments and 6 status groups covering 17 attempts.


## 2026-09-10

### Python diagnostics and Excel export

- Added the Python learning-session runner with separate connection, query, display, export and main functions.
- Returned dictionary rows with Psycopg and displayed a presentment count and readable payment investigation details.
- Added Excel export through openpyxl to an Investigations worksheet in investigations.xlsx.
- Added connection/query error messages with exit code 1 and connection cleanup through finally.
- Manually exercised populated results, empty results, a nonexistent database and invalid SQL during the learning session; restored the working query and connection settings afterwards.
- Recorded installed dependency versions and documented setup, authentication, output location, overwrite behaviour and current error-handling limits.

### Earlier documentation refresh

- Clarified the ongoing learning-project status and current SQL investigation workflow.
- Separated planned Python tooling, additional diagnostics and screenshots from implemented functionality.
- Removed instructions for the unimplemented Python runner and corrected architecture relationships to match the schema.

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

## 2026-09-11 â€” AI-generated GUI

- Added `python/report_gui.py` on `ai-generated/basic-report-gui`, explicitly labelled as AI-generated code.
- Added three query buttons, a dynamic scrollable result table, background loading, error feedback and Excel Save As.
- Kept the existing learning script and user SQL edits intact.
