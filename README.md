# Payments Operations Technical Demo

An ongoing personal learning project connecting payments operations experience with practical PostgreSQL and SQL investigation skills. It is being developed incrementally and is not a finished application.

## Current Scope

- A PostgreSQL schema modelling clients, mandates, instalments and payment presentments, with lookup tables for payment streams, frequencies and statuses.
- Synthetic sample data covering different payment and instalment outcomes.
- An investigation query joining payment attempts to their client, mandate and instalment context, filtered to statuses marked as requiring investigation.
- Architecture documentation and a changelog recording development progress.

The scenario follows a debit-order collection workflow: a client has a mandate, the mandate has scheduled instalments, and presentments record collection attempts. The aim is to practise tracing payment outcomes through related records and interpreting their operational context.

## Implemented Files

```text
ops-technical-demo/
|-- README.md
|-- CHANGELOG.md
|-- sql/
|   |-- schema.sql
|   |-- sample_data.sql
|   |-- diagnostic_queries.sql
|-- docs/
    |-- architecture.md
```

## Run the Current Demo

Install PostgreSQL and make its command-line tools available on your PATH. Run the following from the repository root, using your local PostgreSQL connection settings:

```powershell
createdb ops_demo
psql -v ON_ERROR_STOP=1 -d ops_demo -f sql/schema.sql
psql -v ON_ERROR_STOP=1 -d ops_demo -f sql/sample_data.sql
psql -v ON_ERROR_STOP=1 -d ops_demo -f sql/diagnostic_queries.sql
```

Use a dedicated demo database: `schema.sql` drops and recreates the demo tables. All sample data is synthetic; this project should not be connected to production systems or real customer data.

See [architecture documentation](docs/architecture.md) for table relationships and a Windows executable-path example.

## Planned Work

- Extend the diagnostic SQL with further operations investigation scenarios.
- Add a Python diagnostics runner and its dependencies.
- Add environment setup and troubleshooting notes, with screenshots of completed work.

These items are planned and are not implemented in the current repository. The current demonstration runs directly through PostgreSQL and SQL.
