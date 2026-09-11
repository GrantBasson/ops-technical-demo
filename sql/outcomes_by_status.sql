SELECT
    presentment_status_codes.status_code,
    presentment_status_codes.status_name AS presentment_status,
    COUNT(*) AS attempt_count,
    SUM(presentments.amount) AS total_attempted_amount
FROM presentments
INNER JOIN presentment_status_codes
    ON presentments.status_code = presentment_status_codes.status_code
GROUP BY
    presentment_status_codes.status_code,
    presentment_status_codes.status_name
ORDER BY attempt_count DESC;