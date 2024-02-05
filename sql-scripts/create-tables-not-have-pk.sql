/*
This SQL query file is a follow-up for create-tables-have-pk query which creates all tables that have a pk.
This will now create the tables that only have foreign keys.
*/

CREATE TABLE purchase_details (
	business_id INT,
    CONSTRAINT purchaseDetails_locations_fk FOREIGN KEY (business_id) REFERENCES locations(business_id)
);

CREATE TABLE gift_certificate_details (
	business_id INT,
    user_payment_id INT,
    customer_id INT,
    CONSTRAINT giftCertificateDetails_locations_fk FOREIGN KEY (business_id) REFERENCES locations(business_id),
    CONSTRAINT giftCertificateDetails_transactionDetails_fk FOREIGN KEY (user_payment_id) REFERENCES transaction_details(user_payment_id),
    CONSTRAINT giftCertificateDetails_customerDetails_fk FOREIGN KEY (customer_id) REFERENCES customer_details(customer_id)
);

CREATE TABLE membership_redemption_details (
	business_id INT,
    membership_id INT,
    customer_id INT,
    CONSTRAINT membershipRedemptionDetails_locations_fk FOREIGN KEY (business_id) REFERENCES locations(business_id),
    CONSTRAINT membershipRedemptionDetails_membershipDetails_fk FOREIGN KEY (membership_id) REFERENCES membership_details(membership_id),
    CONSTRAINT membershipRedemptionDetails_customerDetails_fk FOREIGN KEY (customer_id) REFERENCES customer_details(customer_id)
);

CREATE TABLE membership_sold_details (
	business_id INT,
    membership_id INT,
    customer_id INT,
    CONSTRAINT membershipSoldDetails_locations_fk FOREIGN KEY (business_id) REFERENCES locations(business_id),
    CONSTRAINT membershipSoldDetails_membershipDetails_fk FOREIGN KEY (membership_id) REFERENCES membership_details(membership_id),
    CONSTRAINT membershipSoldDetails_customerDetails_fk FOREIGN KEY (customer_id) REFERENCES customer_details(customer_id)
);

CREATE TABLE membership_usage_details (
	business_id INT,
    membership_id INT,
    customer_id INT,
    payment_id INT,
    CONSTRAINT membershipUsageDetails_locations_fk FOREIGN KEY (business_id) REFERENCES locations(business_id),
    CONSTRAINT membershipUsageDetails_membershipDetails_fk FOREIGN KEY (membership_id) REFERENCES membership_details(membership_id),
    CONSTRAINT membershipUsageDetails_customerDetails_fk FOREIGN KEY (customer_id) REFERENCES customer_details(customer_id),
    CONSTRAINT membershipUsageDetails_transactionDetails_fk FOREIGN KEY (payment_id) REFERENCES customer_details(user_payment_id)
);

CREATE TABLE payroll_paid_details (
	business_id INT,
    service_provider_id INT,
    CONSTRAINT payrollPaidDetails_locations_fk FOREIGN KEY (business_id) REFERENCES locations(business_id),
    CONSTRAINT payrollPaidDetails_serviceProviderDetails_fk FOREIGN KEY (service_provider_id) REFERENCES service_provider_details(service_provider_id)
);

CREATE TABLE refund_details (
	business_id INT,
    user_payment_id INT,
    customer_id INT,
    service_provider_id INT,
    CONSTRAINT refundDetails_locations_fk FOREIGN KEY (business_id) REFERENCES locations(business_id),
    CONSTRAINT refundDetails_transactionDetails_fk FOREIGN KEY (user_payment_id) REFERENCES transaction_details(user_payment_id),
    CONSTRAINT refundDetails_customerDetails_fk FOREIGN KEY (customer_id) REFERENCES customer_details(customer_id),
    CONSTRAINT refundDetails_serviceProviderDetails_fk FOREIGN KEY (service_provider_id) REFERENCES service_provider_details(service_provider_id)
);
