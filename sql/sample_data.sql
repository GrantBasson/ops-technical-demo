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
    ('CARD', 'Card Collection');

-- Payment frequencies
INSERT INTO payment_frequencies (
    frequency_code,
    frequency_name
) VALUES
    ('MONTHLY', 'Monthly'),
    ('WEEKLY', 'Weekly');

-- Mandate statuses
INSERT INTO mandate_statuses (
    status_code,
    status_name
) VALUES
    ('ACTIVE', 'Active'),
    ('SUSPENDED', 'Suspended'),
    ('CANCELLED', 'Cancelled'),
    ('COMPLETED', 'Completed');

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
    client_number,
    mandate_reference,
    payment_stream_code,
    frequency_code,
    mandate_status_code,
    start_date,
    end_date
) VALUES
    ('CL-0001', 'MAN-2026-0001', 'EFT_DEBIT', 'MONTHLY', 'ACTIVE', '2026-01-01', NULL),
    ('CL-0002', 'MAN-2026-0002', 'ACOL', 'MONTHLY', 'ACTIVE', '2026-02-01', NULL),
    ('CL-0003', 'MAN-2026-0003', 'CARD', 'WEEKLY', 'SUSPENDED', '2026-03-15', NULL),
    ('CL-0004', 'MAN-2026-0004', 'EFT_DEBIT', 'MONTHLY', 'CANCELLED', '2026-01-15', '2026-08-31');

-- Installments
INSERT INTO installments (
    mandate_reference,
    due_date,
    amount,
    installment_status
) VALUES
    ('MAN-2026-0001', '2026-07-25', 950.00, 'PAID'),
    ('MAN-2026-0001', '2026-08-25', 950.00, 'FAILED'),
    ('MAN-2026-0002', '2026-08-01', 1200.00, 'PAID'),
    ('MAN-2026-0002', '2026-09-01', 1200.00, 'PENDING'),
    ('MAN-2026-0003', '2026-08-07', 300.00, 'FAILED'),
    ('MAN-2026-0004', '2026-08-15', 650.00, 'FAILED');

-- Presentments
INSERT INTO presentments (
    installment_id,
    presentment_reference,
    amount,
    status_code,
    submitted_at
) VALUES
    (
        (
            SELECT installment_id
            FROM installments
            WHERE mandate_reference = 'MAN-2026-0001'
              AND due_date = '2026-07-25'
        ),
        'PRES-2026-0001',
        950.00,
        'SUCCESS',
        '2026-07-25 08:15:00'
    ),
    (
        (
            SELECT installment_id
            FROM installments
            WHERE mandate_reference = 'MAN-2026-0001'
              AND due_date = '2026-08-25'
        ),
        'PRES-2026-0002',
        950.00,
        'INSUFFICIENT_FUNDS',
        '2026-08-25 08:15:00'
    ),
    (
        (
            SELECT installment_id
            FROM installments
            WHERE mandate_reference = 'MAN-2026-0001'
              AND due_date = '2026-08-25'
        ),
        'PRES-2026-0003',
        950.00,
        'PENDING',
        '2026-08-28 08:15:00'
    ),
    (
        (
            SELECT installment_id
            FROM installments
            WHERE mandate_reference = 'MAN-2026-0002'
              AND due_date = '2026-08-01'
        ),
        'PRES-2026-0004',
        1200.00,
        'SUCCESS',
        '2026-08-01 07:30:00'
    ),
    (
        (
            SELECT installment_id
            FROM installments
            WHERE mandate_reference = 'MAN-2026-0002'
              AND due_date = '2026-09-01'
        ),
        'PRES-2026-0005',
        1200.00,
        'PENDING',
        '2026-09-01 07:30:00'
    ),
    (
        (
            SELECT installment_id
            FROM installments
            WHERE mandate_reference = 'MAN-2026-0003'
              AND due_date = '2026-08-07'
        ),
        'PRES-2026-0006',
        300.00,
        'INVALID_ACCOUNT',
        '2026-08-07 09:00:00'
    ),
    (
        (
            SELECT installment_id
            FROM installments
            WHERE mandate_reference = 'MAN-2026-0004'
              AND due_date = '2026-08-15'
        ),
        'PRES-2026-0007',
        650.00,
        'ACCOUNT_CLOSED',
        '2026-08-15 10:20:00'
    ),
    (
        (
            SELECT installment_id
            FROM installments
            WHERE mandate_reference = 'MAN-2026-0004'
              AND due_date = '2026-08-15'
        ),
        'PRES-2026-0008',
        650.00,
        'DUPLICATE_REFERENCE',
        '2026-08-15 10:25:00'
    );
