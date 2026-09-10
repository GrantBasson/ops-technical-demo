
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
def fetch_investigations(connection):
    cursor = connection.cursor(row_factory=dict_row)
    cursor.execute("""SELECT
        clients.client_number,
        clients.id_number,
        CONCAT_WS(' ', clients.first_name, clients.surname) AS client_name,
        mandates.mandate_reference,
        payment_streams.payment_stream_name,
        payment_frequencies.frequency_name,
        mandate_statuses.status_name AS mandate_status,
        instalments.instalment_number,
        presentments.amount,
        presentment_status_codes.status_name AS presentment_status,
        presentment_status_codes.requires_investigation
    FROM clients
    INNER JOIN mandates
        ON clients.client_id = mandates.client_id
    INNER JOIN payment_streams
        ON mandates.payment_stream_code = payment_streams.payment_stream_code
    INNER JOIN payment_frequencies
        ON mandates.frequency_code = payment_frequencies.frequency_code
    INNER JOIN mandate_statuses
        ON mandates.mandate_status_code = mandate_statuses.status_code
    INNER JOIN instalments
        ON mandates.mandate_id = instalments.mandate_id
    INNER JOIN presentments
        ON instalments.instalment_id = presentments.instalment_id
    INNER JOIN presentment_status_codes
        ON presentments.status_code = presentment_status_codes.status_code
    WHERE presentment_status_codes.requires_investigation = TRUE;
    
    """)
    results = cursor.fetchall()
    cursor.close()
    return results

###Format the results
def display_report(results):
    if results:
        print(f"\nPresentments requiring investigation: {len(results)}")

        for row in results:
            print(
                f"{row["client_name"]} | {row["mandate_reference"]} | R{row["amount"]:.2f} | {row["presentment_status"]}")
    else:
        print("No presentments require investigation.")


def main():
    print("Payments diagnostics")
    connection = connect_to_database()
    print("Connected to PostgreSQL")

    try:
        results = fetch_investigations(connection)
        display_report(results)
        export_report(results)
    except psycopg.Error as error:
        print(f"Database query failed: {error}")
        sys.exit(1)
    finally:
        connection.close()

def export_report(results):
    workbook = Workbook()
    sheet = workbook.active
    sheet.title = "Investigations"

    sheet.append(["Client", "Mandate", "Amount", "Payment status"])

    for row in results:
        sheet.append([
            row["client_name"],
            row["mandate_reference"],
            row["amount"],
            row["presentment_status"]
        ])

    workbook.save("investigations.xlsx")
    print("Saved investigations.xlsx")

if __name__ == "__main__":
    main()