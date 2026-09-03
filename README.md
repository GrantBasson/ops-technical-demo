# ops-technical-demo

Private draft for an operations technical demonstration.

This repository demonstrates practical operations troubleshooting in a payments environment. It contains a small PostgreSQL data model, realistic sample data, diagnostic SQL, a Python diagnostics runner, and documentation explaining how the pieces fit together.

The scenario is a debit-order/payment-presentment workflow:

- Clients are loaded with identifying details.
- Mandates define collection agreements and instalment schedules.
- Presentments represent payment attempts submitted to a payment stream.
- Diagnostic queries highlight common operations questions such as failed collections, duplicate references, mandate utilisation, and retry candidates.

## Repository Structure

```text
ops-technical-demo/
|-- README.md
|-- python/
|   |-- diagnostics.py
|   |-- requirements.txt
|-- sql/
|   |-- schema.sql
|   |-- sample_data.sql
|   |-- diagnostic_queries.sql
|-- docs/
|   |-- architecture.md
|   |-- vm-setup.md
|   |-- troubleshooting.md
|-- screenshots/
    |-- rdp-session.png
    |-- database-query.png
    |-- python-output.png
```

## Quick Start

1. Create a PostgreSQL database for the demo.

   ```powershell
   createdb ops_demo
   ```

2. Load the schema and sample data.

   ```powershell
   psql -d ops_demo -f sql/schema.sql
   psql -d ops_demo -f sql/sample_data.sql
   ```

3. Run the SQL diagnostics directly.

   ```powershell
   psql -d ops_demo -f sql/diagnostic_queries.sql
   ```

4. Or run the Python diagnostic script.

   ```powershell
   python -m venv .venv
   .\.venv\Scripts\Activate.ps1
   pip install -r python/requirements.txt
   $env:DATABASE_URL = "postgresql://postgres:postgres@localhost:5432/ops_demo"
   python python/diagnostics.py
   ```

## Notes

This is demonstration material only. It uses synthetic data and should not be connected to production systems or real customer data.
