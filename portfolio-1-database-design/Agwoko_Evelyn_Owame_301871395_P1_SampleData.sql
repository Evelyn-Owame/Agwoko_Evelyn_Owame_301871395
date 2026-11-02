-- Fictional sample records for Synthetic Bank and Fintech Platform.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."customers" ("customer_id", "display_name", "created_at") VALUES (1001, 'Avery Chen', '2026-01-15T10:00:00Z');
INSERT INTO portfolio."customers" ("customer_id", "display_name", "created_at") VALUES (1002, 'Riley Morgan', '2026-02-20T14:30:00+00:00');
INSERT INTO portfolio."accounts" ("account_id", "customer_id", "currency", "status", "opened_on") VALUES (2001, 1001, 'USD', 'open', '2026-01-16');
INSERT INTO portfolio."accounts" ("account_id", "customer_id", "currency", "status", "opened_on") VALUES (2002, 1002, 'EUR', 'suspended', '2026-02-21');
INSERT INTO portfolio."payments" ("payment_id", "account_id", "amount", "direction", "status", "occurred_at", "idempotency_key") VALUES (3001, 2001, 125.5, 'credit', 'posted', '2026-03-01T12:15:00Z', 'idem-seed-1');
INSERT INTO portfolio."payments" ("payment_id", "account_id", "amount", "direction", "status", "occurred_at", "idempotency_key") VALUES (3002, 2002, 42.75, 'debit', 'pending', '2026-03-02T09:45:00+00:00', NULL);
COMMIT;
