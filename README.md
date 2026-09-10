# Payments Operations Technical Demo

An ongoing personal learning project connecting payments operations experience with practical PostgreSQL, SQL and Python investigation skills. It is being developed incrementally and is not a finished application.

## Current Scope

- A PostgreSQL schema modelling clients, mandates, instalments and payment presentments, with lookup tables for payment streams, frequencies and statuses.
- Synthetic sample data covering different payment and instalment outcomes.
- An investigation query joining payment attempts to their client, mandate and instalment context, filtered to statuses marked as requiring investigation.
- A Python runner that displays investigations and exports them to Excel, with database error handling.
- Architecture documentation and a changelog recording development progress.

The scenario follows a debit-order collection workflow: a client has a mandate, the mandate has scheduled instalments, and presentments record collection attempts. The aim is to practise tracing payment outcomes through related records and interpreting their operational context.

## Implemented Files

```text
ops-technical-demo/
|-- README.md
|-- CHANGELOG.md
|-- python/
|   |-- diagnostics.py
|   |-- requirements.txt
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

## Run the Python Report

The current script was developed with Python 3.14.6. Its f-string syntax requires Python 3.12 or newer; the recorded package versions are from the working Windows Python 3.14 environment.

From the repository root in PowerShell, create an environment if one does not already exist, then install the recorded dependencies:

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r python/requirements.txt
.\.venv\Scripts\python.exe python/diagnostics.py
```

For an existing project environment, skip the first command. In PyCharm, select `.venv\Scripts\python.exe` as the project interpreter and run `python/diagnostics.py`.

PostgreSQL must be running and the schema and sample data must already be loaded. The connection settings in `connect_to_database()` currently target `127.0.0.1:5432`, database `ops_demo`, user `postgres`, with a five-second connection timeout. Adjust these for your own local demo. The script supplies no password; authentication must be configured for that account, for example through PostgreSQL's password file. Do not put passwords in tracked source files.

The report displays client name, mandate reference, amount and payment status. The count is presentments, not unique clients. It saves `investigations.xlsx` in the process working directory, which may differ between a terminal and a PyCharm run configuration. Running from the repository root saves it there. The `Investigations` worksheet contains four columns: Client, Mandate, Amount and Payment status. An empty result produces the no-investigations message and a workbook containing headings only.

Each export overwrites the same filename. Close the workbook in Excel before rerunning. File-write errors are not currently handled with a custom message; database connection and query errors are reported with exit code 1. The connection is closed in `finally` after the query/report stage, including on failure.

## Planned Work

- Extend the diagnostic SQL with further operations investigation scenarios.
- Add environment setup and troubleshooting notes, with screenshots of completed work.

These items are planned and are not implemented in the current repository. The current demonstration can run directly through SQL or through the Python report runner.
