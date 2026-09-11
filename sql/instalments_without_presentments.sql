SELECT
    clients.client_number,
    clients.id_number,
    CONCAT_WS(' ', clients.first_name, clients.surname) AS client_name,
    mandates.mandate_reference,
    payment_streams.payment_stream_name,
    payment_frequencies.frequency_name,
    mandate_statuses.status_name AS mandate_status,
    instalments.instalment_number,
    instalments.instalment_status,
    instalments.instalment_id
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
LEFT JOIN presentments
    ON instalments.instalment_id = presentments.instalment_id
WHERE presentments.instalment_id IS NULL;