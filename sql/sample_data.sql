-- Clients
INSERT INTO clients (
    client_number,
    first_name,
    middle_name,
    surname,
    id_number
) VALUES
    ('CL-0001', 'Lerato', NULL, 'Mokoena', '9001015000000'),
    ('CL-0002', 'Aisha', 'N.', 'Pillay', '8506120456789'),
    ('CL-0003', 'Thabo', NULL, 'Dlamini', '9207035012345'),
    ('CL-0004', 'Nadia', 'K.', 'Jacobs', '8811240454321');

-- Payment streams
INSERT INTO payment_streams (
    payment_stream_code,
    payment_stream_name
) VALUES
    ('EFT_DEBIT', 'EFT Debit'),
    ('ACOL', 'Authenticated Collections'),
    ('POS', 'POS Collection');

-- Payment frequencies
INSERT INTO payment_frequencies (
    frequency_code,
    frequency_name
) VALUES
    ('MONTHLY', 'Monthly'),
    ('WEEKLY', 'Weekly'),
    ('ONCE_OFF', 'Once Off');

-- Mandate statuses
INSERT INTO mandate_statuses (
    status_code,
    status_name
) VALUES
    ('ACTIVE', 'Active'),
    ('COMPLETE', 'Complete'),
    ('CANCELLED', 'Cancelled'),
    ('INVALID', 'Invalid');

-- Presentment status codes
INSERT INTO presentment_status_codes (
    status_code,
    status_name,
    requires_investigation
) VALUES
    ('SUCCESS', 'Successful collection', FALSE),
    ('PENDING', 'Submitted and awaiting response', FALSE),
    ('INSUFFICIENT_FUNDS', 'Declined due to insufficient funds', FALSE),
    ('ACCOUNT_CLOSED', 'Declined because account is closed', TRUE),
    ('INVALID_ACCOUNT', 'Declined because account details are invalid', TRUE),
    ('DUPLICATE_REFERENCE', 'Rejected because reference was already used', TRUE);

-- Mandates
INSERT INTO mandates (
    client_id,
    mandate_reference,
    payment_stream_code,
    frequency_code,
    mandate_status_code,
    start_date,
    end_date
) VALUES
    ((SELECT client_id FROM clients WHERE client_number = 'CL-0001'), 'MAN-2026-0001', 'EFT_DEBIT', 'MONTHLY', 'ACTIVE', '2026-01-01', NULL),
    ((SELECT client_id FROM clients WHERE client_number = 'CL-0002'), 'MAN-2026-0002', 'ACOL', 'MONTHLY', 'ACTIVE', '2026-02-01', NULL),
    ((SELECT client_id FROM clients WHERE client_number = 'CL-0003'), 'MAN-2026-0003', 'POS', 'ONCE_OFF', 'INVALID', '2026-03-15', NULL),
    ((SELECT client_id FROM clients WHERE client_number = 'CL-0004'), 'MAN-2026-0004', 'EFT_DEBIT', 'MONTHLY', 'CANCELLED', '2026-01-15', '2026-08-31'),
    ((SELECT client_id FROM clients WHERE client_number = 'CL-0001'), 'MAN-2026-0005', 'ACOL', 'MONTHLY', 'COMPLETE', '2026-06-01', '2026-08-31'),
    ((SELECT client_id FROM clients WHERE client_number = 'CL-0002'), 'MAN-2026-0006', 'EFT_DEBIT', 'WEEKLY', 'ACTIVE', '2026-08-03', NULL),
    ((SELECT client_id FROM clients WHERE client_number = 'CL-0003'), 'MAN-2026-0007', 'ACOL', 'MONTHLY', 'ACTIVE', '2026-07-01', NULL),
    ((SELECT client_id FROM clients WHERE client_number = 'CL-0004'), 'MAN-2026-0008', 'POS', 'ONCE_OFF', 'COMPLETE', '2026-08-01', '2026-08-01');

-- Instalments
INSERT INTO instalments (
    instalment_number,
    mandate_id,
    due_date,
    amount,
    instalment_status
) VALUES
    (1, (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0001'), '2026-07-25', 950.00, 'COMPLETE'),
    (2, (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0001'), '2026-08-25', 950.00, 'INCOMPLETE'),
    (3, (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0001'), '2026-09-25', 950.00, 'ACTIVE'),
    (1, (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0002'), '2026-08-01', 1200.00, 'COMPLETE'),
    (2, (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0002'), '2026-09-01', 1200.00, 'ACTIVE'),
    (3, (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0002'), '2026-10-01', 1200.00, 'RESCHEDULED'),
    (1, (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0003'), '2026-08-07', 300.00, 'INVALID'),
    (1, (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0004'), '2026-08-15', 650.00, 'INCOMPLETE'),
    (2, (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0004'), '2026-09-15', 650.00, 'CANCELLED'),
    (1, (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0005'), '2026-06-01', 450.00, 'COMPLETE'),
    (2, (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0005'), '2026-07-01', 450.00, 'COMPLETE'),
    (3, (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0005'), '2026-08-01', 450.00, 'COMPLETE'),
    (1, (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0006'), '2026-08-03', 200.00, 'COMPLETE'),
    (2, (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0006'), '2026-08-10', 200.00, 'INCOMPLETE'),
    (3, (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0006'), '2026-08-17', 200.00, 'RESCHEDULED'),
    (4, (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0006'), '2026-08-24', 200.00, 'ACTIVE'),
    (1, (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0007'), '2026-07-01', 800.00, 'COMPLETE'),
    (2, (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0007'), '2026-08-01', 800.00, 'INVALID'),
    (3, (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0007'), '2026-09-01', 800.00, 'ACTIVE'),
    (1, (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0008'), '2026-08-01', 1500.00, 'COMPLETE');

-- Presentments
INSERT INTO presentments (
    instalment_id,
    mandate_id,
    presentment_reference,
    amount,
    status_code,
    submitted_at
) VALUES
    (
        (
            SELECT instalment_id
            FROM instalments
            WHERE mandate_id = (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0001')
              AND due_date = '2026-07-25'
        ),
        (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0001'),
        'PRES-2026-0001',
        950.00,
        'SUCCESS',
        '2026-07-25 08:15:00'
    ),
    (
        (
            SELECT instalment_id
            FROM instalments
            WHERE mandate_id = (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0001')
              AND due_date = '2026-08-25'
        ),
        (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0001'),
        'PRES-2026-0002',
        950.00,
        'INSUFFICIENT_FUNDS',
        '2026-08-25 08:15:00'
    ),
    (
        (
            SELECT instalment_id
            FROM instalments
            WHERE mandate_id = (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0001')
              AND due_date = '2026-08-25'
        ),
        (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0001'),
        'PRES-2026-0003',
        950.00,
        'PENDING',
        '2026-08-28 08:15:00'
    ),
    (
        (
            SELECT instalment_id
            FROM instalments
            WHERE mandate_id = (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0002')
              AND due_date = '2026-08-01'
        ),
        (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0002'),
        'PRES-2026-0004',
        1200.00,
        'SUCCESS',
        '2026-08-01 07:30:00'
    ),
    (
        (
            SELECT instalment_id
            FROM instalments
            WHERE mandate_id = (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0002')
              AND due_date = '2026-09-01'
        ),
        (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0002'),
        'PRES-2026-0005',
        1200.00,
        'PENDING',
        '2026-09-01 07:30:00'
    ),
    (
        (
            SELECT instalment_id
            FROM instalments
            WHERE mandate_id = (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0003')
              AND due_date = '2026-08-07'
        ),
        (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0003'),
        'PRES-2026-0006',
        300.00,
        'INVALID_ACCOUNT',
        '2026-08-07 09:00:00'
    ),
    (
        (
            SELECT instalment_id
            FROM instalments
            WHERE mandate_id = (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0004')
              AND due_date = '2026-08-15'
        ),
        (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0004'),
        'PRES-2026-0007',
        650.00,
        'ACCOUNT_CLOSED',
        '2026-08-15 10:20:00'
    ),
    (
        (
            SELECT instalment_id
            FROM instalments
            WHERE mandate_id = (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0004')
              AND due_date = '2026-08-15'
        ),
        (SELECT mandate_id FROM mandates WHERE mandate_reference = 'MAN-2026-0004'),
        'PRES-2026-0008',
        650.00,
        'DUPLICATE_REFERENCE',
        '2026-08-15 10:25:00'
    );
