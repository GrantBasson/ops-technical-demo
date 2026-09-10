# Architecture

## 1. Overview

This project is a small PostgreSQL and Python demo for payments and operations troubleshooting. It is intended for practising database setup, reading table relationships, and writing diagnostic SQL against a realistic but simple payments workflow.

All data used in this project is synthetic. It is not production data, customer data, or real personal information.

## 2. Business Scenario

The demo follows a basic payment collections flow:

```text
clients -> mandates -> instalments -> presentments
```

A client represents the person or customer whose details are held in the system. A mandate represents the agreement that allows collections to be made for that client. Instalments represent scheduled amounts due against a mandate. Presentments represent payment collection attempts submitted for an instalment.

Lookup tables control valid values used by the main operational records. These include payment streams, payment frequencies, mandate statuses, and presentment status codes. This keeps repeated business values consistent across the database.

## 3. Table Summary

`clients` stores basic client identity details, including a unique `client_number` and unique South African-style `id_number`.

`payment_streams` stores allowed payment stream codes and names, such as the collection channel used for a mandate.

`payment_frequencies` stores allowed collection frequency codes and names.

`mandate_statuses` stores allowed mandate lifecycle statuses.

`presentment_status_codes` stores allowed presentment result statuses. It also identifies whether a status requires investigation.

`mandates` stores collection agreements linked to clients. Each mandate has a unique `mandate_reference`, payment stream, frequency, status, and start date.

`instalments` stores scheduled amounts due against mandates. Each instalment is linked to a `mandate_id`, with an `instalment_number` unique within that mandate.

`presentments` stores payment collection attempts against instalments. Each presentment has a unique `presentment_reference`, amount, status code, and submission timestamp.

## 4. Key Relationships

The main operational chain is:

```text
clients.client_id -> mandates.client_id
mandates.mandate_id -> instalments.mandate_id
instalments.instalment_id -> presentments.instalment_id
mandates.mandate_id -> presentments.mandate_id
```

In plain English:

- A client can have one or more mandates.
- A mandate can have one or more instalments.
- An instalment can have one or more presentment attempts.

Presentments also reference a mandate directly. The current foreign keys check that the instalment and mandate exist, but do not enforce that both refer to the same mandate. Business references remain unique while relationships use generated IDs.

The `mandates` table also uses lookup tables:

- `mandates.payment_stream_code` references `payment_streams.payment_stream_code`.
- `mandates.frequency_code` references `payment_frequencies.frequency_code`.
- `mandates.mandate_status_code` references `mandate_statuses.status_code`.

The `presentments` table uses one lookup table:

- `presentments.status_code` references `presentment_status_codes.status_code`.

## 5. Design Choices

`NUMERIC(10, 2)` is used for money amounts because payment values must be exact. Floating-point types can introduce rounding problems, which is not acceptable for financial amounts.

South African ID numbers are stored as `CHAR(13)` because they are fixed-length identifiers, not values used for arithmetic. Storing them as text preserves leading zeroes and avoids treating an identifier like a number.

Lookup tables are used for controlled values so that codes such as payment streams, frequencies, and statuses stay consistent. This also makes diagnostic queries easier because the database can enforce valid codes.

`DROP TABLE IF EXISTS ... CASCADE` is used so the schema script can be rerun during learning and practice. The `CASCADE` option removes dependent objects, which helps avoid foreign key dependency errors when rebuilding the demo database from scratch.

## 6. How To Rebuild The Database

Create the demo database:

```powershell
createdb ops_demo
```

Run the schema script:

```powershell
psql -d ops_demo -f sql/schema.sql
```

Load the sample data:

```powershell
psql -d ops_demo -f sql/sample_data.sql
```

These commands assume PostgreSQL is installed and available on the system `PATH`.

If PostgreSQL is not on the system `PATH`, use the full path to `psql.exe`. For example, on the local Windows development machine used while building this demo:

```powershell
& "C:\pg16\pgsql\bin\psql.exe" -h 127.0.0.1 -p 5432 -U postgres -d ops_demo -f .\sql\schema.sql
```

## 7. Python Diagnostics and Excel Export

`python/diagnostics.py` implements this flow:

```text
main -> connect_to_database -> fetch_investigations -> display_report -> export_report
```

`connect_to_database()` returns a Psycopg connection or reports an operational connection error and exits with code 1. `fetch_investigations(connection)` executes the investigation SELECT and returns dictionary rows, keyed by SQL column names and aliases. It closes its cursor after fetching. The SQL is currently embedded in the Python file rather than loaded from `sql/diagnostic_queries.sql`; changes to the investigation logic must be kept consistent in both places.

`display_report(results)` prints the row count and client, mandate, amount and payment outcome, or a message when no rows match. Multiple attempts for the same client remain separate rows. `export_report(results)` uses openpyxl to create an `Investigations` worksheet and save four report columns to `investigations.xlsx` in the working directory. It exports the same fetched results without running a second query. Empty results still produce column headings.

`main()` catches Psycopg database errors during fetching/reporting and exits with code 1. Its `finally` block closes the connection, including when a query or export fails. Export filesystem errors are not caught by the database handler. The main guard starts the workflow only when the file is executed directly, so importing it makes the functions available without running the report.

The runner reads database records; it does not change them. Dependencies and PowerShell setup instructions are recorded in `python/requirements.txt` and the README. VM/RDP setup and additional operational diagnostics remain future work.
