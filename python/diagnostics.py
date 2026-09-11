
from pathlib import Path
import psycopg
from openpyxl import Workbook
from psycopg.rows import dict_row
import sys

###Connect to the local database
def connect_to_database():
    try:
        connection = psycopg.connect(
            host="127.0.0.1",
            port=5432,
            dbname="ops_demo",
            user="postgres",
            connect_timeout = 5
        )
    except psycopg.OperationalError as error:
        print(f"Could not connect to PostgreSQL: {error}")
        sys.exit(1)

    return connection

###Fetch client, mandate, instalment, and presentment information from various tables.
def fetch_report(connection, filename):
    sql_path = Path(__file__).resolve().parent.parent / "sql" / filename
    query = sql_path.read_text(encoding="utf-8")

    cursor = connection.cursor(row_factory=dict_row)
    cursor.execute(query)
    results = cursor.fetchall()
    cursor.close()

    return results

###Check for results, display a message if none, format if available and display the results
def display_report(results):
    if not results:
        print("No results found.")
        return

    columns = list(results[0].keys())

    print(f"\nRows returned: {len(results)}")
    print(" | ".join(columns))

    for row in results:
        print(" | ".join(str(row[column]) for column in columns))

###Export results to xlsx
def export_report(results):
    if not results:
        print("No results to export.")
        return

    workbook = Workbook()
    sheet = workbook.active
    sheet.title = "Report"

    columns = list(results[0].keys())
    sheet.append(columns)

    for row in results:
        sheet.append([row[column] for column in columns])

    workbook.save("report.xlsx")
    print("Saved report.xlsx")

###Run the defined functions with relevant messages along the way, error where required and make sure to clean up as needed.
def main():
    print("Payments diagnostics")
    connection = connect_to_database()
    print("Connected to PostgreSQL")

    try:
        results = fetch_report(connection, "investigate_presentments.sql")
        display_report(results)
        export_report(results)
    except psycopg.Error as error:
        print(f"Database query failed: {error}")
        sys.exit(1)
    finally:
        connection.close()

###Allow this function to be called on its own or by another function.
if __name__ == "__main__":
    main()