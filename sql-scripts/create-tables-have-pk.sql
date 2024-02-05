/*
I prefer to create database tables first then use ALTER TABLE to populate the remaining columns(attributes).
The reason for this is you can run into issues with foreign keys relating to tables that do not exist yet.
I will also choose not to have AUTO_INCREMENT because data will only be imported into the database not manually created.
So all primary key columns will already be populated.
*/

CREATE TABLE locations (
	business_id INT NOT NULL,
    CONSTRAINT business_id_pk PRIMARY KEY (business_id)
);

CREATE TABLE customer_details (
	customer_id INT NOT NULL,
    CONSTRAINT customer_id_pk PRIMARY KEY (customer_id)
);

CREATE TABLE service_provider_details (
	service_provider_id INT NOT NULL,
    CONSTRAINT service_provider_id_pk PRIMARY KEY (service_provider_id)
);

CREATE TABLE membership_details (
	membership_id INT NOT NULL,
    CONSTRAINT membership_id_pk PRIMARY KEY (membership_id)
);

CREATE TABLE appointment_details (
	appointment_id INT NOT NULL,
    CONSTRAINT appointment_id_pk PRIMARY KEY (appointment_id)
);

CREATE TABLE transaction_details (
	user_payment_id INT NOT NULL,
    CONSTRAINT user_payment_id_pk PRIMARY KEY (user_payment_id)
);

CREATE TABLE deposit_details (
	merchant_id INT NOT NULL,
    transaction_id INT NOT NULL,
    CONSTRAINT merchantId_transactionId_pk PRIMARY KEY (merchant_id, transaction_id)
);