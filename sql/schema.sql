--drop tables and their dependencies if they exist
DROP TABLE IF EXISTS presentments CASCADE;
DROP TABLE IF EXISTS instalments CASCADE;
DROP TABLE IF EXISTS mandates CASCADE;
DROP TABLE IF EXISTS presentment_status_codes CASCADE;
DROP TABLE IF EXISTS mandate_statuses CASCADE;
DROP TABLE IF EXISTS payment_frequencies CASCADE;
DROP TABLE IF EXISTS payment_streams CASCADE;
DROP TABLE IF EXISTS clients CASCADE;

--create clients table
CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,
    client_number TEXT NOT NULL UNIQUE,
    first_name TEXT NOT NULL,
    middle_name TEXT,
    surname TEXT NOT NULL,
    id_number CHAR(13) NOT NULL UNIQUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--create payment streams table
CREATE TABLE payment_streams (
    payment_stream_code TEXT PRIMARY KEY,
    payment_stream_name TEXT NOT NULL
);

--create payment frequencies table
CREATE TABLE payment_frequencies (
    frequency_code TEXT PRIMARY KEY,
    frequency_name TEXT NOT NULL
);

--create mandate statuses table
CREATE TABLE mandate_statuses (
    status_code TEXT PRIMARY KEY,
    status_name TEXT NOT NULL
);

--create presentment status codes table
CREATE TABLE presentment_status_codes (
    status_code TEXT PRIMARY KEY,
    status_name TEXT NOT NULL,
    requires_investigation BOOLEAN NOT NULL DEFAULT FALSE
);

--create mandates table
CREATE TABLE mandates (
    mandate_id SERIAL PRIMARY KEY,
    client_id INTEGER NOT NULL REFERENCES clients(client_id),
    mandate_reference TEXT NOT NULL UNIQUE,
    payment_stream_code TEXT NOT NULL REFERENCES payment_streams(payment_stream_code),
    frequency_code TEXT NOT NULL REFERENCES payment_frequencies(frequency_code),
    mandate_status_code TEXT NOT NULL REFERENCES mandate_statuses(status_code),
    start_date DATE NOT NULL,
    end_date DATE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--create instalments table
CREATE TABLE instalments (
    instalment_id SERIAL PRIMARY KEY,
    instalment_number INTEGER NOT NULL,
    mandate_id INTEGER NOT NULL REFERENCES mandates(mandate_id),
    due_date DATE NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    instalment_status TEXT NOT NULL,
    UNIQUE (mandate_id, instalment_number)
);

--create presentments table
CREATE TABLE presentments (
    presentment_id SERIAL PRIMARY KEY,
    instalment_id INTEGER NOT NULL REFERENCES instalments(instalment_id),
    mandate_id INTEGER NOT NULL REFERENCES mandates(mandate_id),
    presentment_reference TEXT NOT NULL UNIQUE,
    amount NUMERIC(10, 2) NOT NULL,
    status_code TEXT NOT NULL REFERENCES presentment_status_codes(status_code),
    submitted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
