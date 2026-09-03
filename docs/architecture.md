# Architecture

## 1. Overview

This project is a small PostgreSQL demo for payments and operations troubleshooting. It is intended for practising database setup, reading table relationships, and writing diagnostic SQL against a realistic but simple payments workflow.

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

`instalments` stores scheduled amounts due against mandates. Each instalment is linked to a `mandate_reference`.

`presentments` stores payment collection attempts against instalments. Each presentment has a unique `presentment_reference`, amount, status code, and submission timestamp.

## 4. Key Relationships

The main operational chain is:

```text
clients.client_number -> mandates.client_number
mandates.mandate_reference -> instalments.mandate_reference
instalments.instalment_id -> presentments.instalment_id
```

In plain English:

- A client can have one or more mandates.
- A mandate can have one or more instalments.
- An instalment can have one or more presentment attempts.

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

Run the schema script against the local `ops_demo` database using the PostgreSQL client:

```powershell
psql -d ops_demo -f sql/schema.sql
```
