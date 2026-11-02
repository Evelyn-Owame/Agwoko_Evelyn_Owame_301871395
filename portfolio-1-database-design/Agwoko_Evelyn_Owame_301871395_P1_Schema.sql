-- Synthetic Bank and Fintech Platform: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."customers" (
  "customer_id" bigint NOT NULL,
  "display_name" text NOT NULL,
  "created_at" timestamptz NOT NULL,
  CONSTRAINT "pk_customers" PRIMARY KEY ("customer_id")
);
CREATE TABLE portfolio."accounts" (
  "account_id" bigint NOT NULL,
  "customer_id" bigint NOT NULL,
  "currency" text NOT NULL,
  "status" text NOT NULL,
  "opened_on" date NOT NULL,
  CONSTRAINT "pk_accounts" PRIMARY KEY ("account_id")
);
CREATE TABLE portfolio."payments" (
  "payment_id" bigint NOT NULL,
  "account_id" bigint NOT NULL,
  "amount" numeric(18,2) NOT NULL,
  "direction" text NOT NULL,
  "status" text NOT NULL,
  "occurred_at" timestamptz NOT NULL,
  "idempotency_key" text,
  CONSTRAINT "pk_payments" PRIMARY KEY ("payment_id")
);
ALTER TABLE portfolio."accounts" ADD CONSTRAINT "fk_accounts_0" FOREIGN KEY ("customer_id") REFERENCES portfolio."customers" ("customer_id");
ALTER TABLE portfolio."payments" ADD CONSTRAINT "fk_payments_0" FOREIGN KEY ("account_id") REFERENCES portfolio."accounts" ("account_id");
ALTER TABLE portfolio."accounts" ADD CONSTRAINT "account_status_allowed" CHECK (("status" = 'open') OR ("status" = 'suspended') OR ("status" = 'closed'));
ALTER TABLE portfolio."payments" ADD CONSTRAINT "payment_amount_positive" CHECK ("amount" > 0);
ALTER TABLE portfolio."payments" ADD CONSTRAINT "payment_direction_allowed" CHECK (("direction" = 'credit') OR ("direction" = 'debit'));
CREATE UNIQUE INDEX "payment_idempotency_per_account" ON portfolio."payments" ("account_id", "idempotency_key") WHERE ("idempotency_key" IS NOT NULL);
COMMIT;
