-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. customer pk duplicate. Expected: pk_customers, SQLSTATE 23505.
INSERT INTO portfolio."customers" ("customer_id", "display_name", "created_at")
VALUES (1001, 'Jordan Sample', '2026-04-01T10:00:00Z');

-- 2. customer id null. Expected: customer_id, SQLSTATE 23502.
INSERT INTO portfolio."customers" ("customer_id", "display_name", "created_at")
VALUES (NULL, 'Jordan Sample', '2026-04-01T10:00:00Z');

-- 3. customer name null. Expected: display_name, SQLSTATE 23502.
INSERT INTO portfolio."customers" ("customer_id", "display_name", "created_at")
VALUES (4101, NULL, '2026-04-01T10:00:00Z');

-- 4. customer created null. Expected: created_at, SQLSTATE 23502.
INSERT INTO portfolio."customers" ("customer_id", "display_name", "created_at")
VALUES (4102, 'Jordan Sample', NULL);

-- 5. account pk duplicate. Expected: pk_accounts, SQLSTATE 23505.
INSERT INTO portfolio."accounts" ("account_id", "customer_id", "currency", "status", "opened_on")
VALUES (2001, 1002, 'GBP', 'open', '2026-04-01');

-- 6. account customer fk invalid. Expected: fk_accounts_0, SQLSTATE 23503.
INSERT INTO portfolio."accounts" ("account_id", "customer_id", "currency", "status", "opened_on")
VALUES (4103, 49991, 'GBP', 'open', '2026-04-01');

-- 7. account id null. Expected: account_id, SQLSTATE 23502.
INSERT INTO portfolio."accounts" ("account_id", "customer_id", "currency", "status", "opened_on")
VALUES (NULL, 1001, 'GBP', 'open', '2026-04-01');

-- 8. account customer null. Expected: customer_id, SQLSTATE 23502.
INSERT INTO portfolio."accounts" ("account_id", "customer_id", "currency", "status", "opened_on")
VALUES (4104, NULL, 'GBP', 'open', '2026-04-01');

-- 9. account currency null. Expected: currency, SQLSTATE 23502.
INSERT INTO portfolio."accounts" ("account_id", "customer_id", "currency", "status", "opened_on")
VALUES (4105, 1001, NULL, 'open', '2026-04-01');

-- 10. account status null. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."accounts" ("account_id", "customer_id", "currency", "status", "opened_on")
VALUES (4106, 1001, 'GBP', NULL, '2026-04-01');

-- 11. account opened null. Expected: opened_on, SQLSTATE 23502.
INSERT INTO portfolio."accounts" ("account_id", "customer_id", "currency", "status", "opened_on")
VALUES (4107, 1001, 'GBP', 'open', NULL);

-- 12. payment pk duplicate. Expected: pk_payments, SQLSTATE 23505.
INSERT INTO portfolio."payments" ("payment_id", "account_id", "amount", "direction", "status", "occurred_at", "idempotency_key")
VALUES (3001, 2002, 75.25, 'debit', 'posted', '2026-04-01T10:00:00Z', NULL);

-- 13. payment account fk invalid. Expected: fk_payments_0, SQLSTATE 23503.
INSERT INTO portfolio."payments" ("payment_id", "account_id", "amount", "direction", "status", "occurred_at", "idempotency_key")
VALUES (4108, 49992, 75.25, 'debit', 'posted', '2026-04-01T10:00:00Z', NULL);

-- 14. payment id null. Expected: payment_id, SQLSTATE 23502.
INSERT INTO portfolio."payments" ("payment_id", "account_id", "amount", "direction", "status", "occurred_at", "idempotency_key")
VALUES (NULL, 2001, 75.25, 'debit', 'posted', '2026-04-01T10:00:00Z', NULL);

-- 15. payment account null. Expected: account_id, SQLSTATE 23502.
INSERT INTO portfolio."payments" ("payment_id", "account_id", "amount", "direction", "status", "occurred_at", "idempotency_key")
VALUES (4109, NULL, 75.25, 'debit', 'posted', '2026-04-01T10:00:00Z', NULL);

-- 16. payment amount null. Expected: amount, SQLSTATE 23502.
INSERT INTO portfolio."payments" ("payment_id", "account_id", "amount", "direction", "status", "occurred_at", "idempotency_key")
VALUES (4110, 2001, NULL, 'debit', 'posted', '2026-04-01T10:00:00Z', NULL);

-- 17. payment direction null. Expected: direction, SQLSTATE 23502.
INSERT INTO portfolio."payments" ("payment_id", "account_id", "amount", "direction", "status", "occurred_at", "idempotency_key")
VALUES (4111, 2001, 75.25, NULL, 'posted', '2026-04-01T10:00:00Z', NULL);

-- 18. payment status null. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."payments" ("payment_id", "account_id", "amount", "direction", "status", "occurred_at", "idempotency_key")
VALUES (4112, 2001, 75.25, 'debit', NULL, '2026-04-01T10:00:00Z', NULL);

-- 19. payment occurred null. Expected: occurred_at, SQLSTATE 23502.
INSERT INTO portfolio."payments" ("payment_id", "account_id", "amount", "direction", "status", "occurred_at", "idempotency_key")
VALUES (4113, 2001, 75.25, 'debit', 'posted', NULL, NULL);

-- 20. account status disallowed. Expected: account_status_allowed, SQLSTATE 23514.
INSERT INTO portfolio."accounts" ("account_id", "customer_id", "currency", "status", "opened_on")
VALUES (4114, 1001, 'GBP', 'pending', '2026-04-01');

-- 21. payment amount nonpositive. Expected: payment_amount_positive, SQLSTATE 23514.
INSERT INTO portfolio."payments" ("payment_id", "account_id", "amount", "direction", "status", "occurred_at", "idempotency_key")
VALUES (4115, 2001, 0, 'credit', 'posted', '2026-04-01T10:00:00Z', NULL);

-- 22. payment direction disallowed. Expected: payment_direction_allowed, SQLSTATE 23514.
INSERT INTO portfolio."payments" ("payment_id", "account_id", "amount", "direction", "status", "occurred_at", "idempotency_key")
VALUES (4116, 2001, 75.25, 'wire', 'posted', '2026-04-01T10:00:00Z', NULL);

-- 23. payment idempotency duplicate. Expected: payment_idempotency_per_account, SQLSTATE 23505.
INSERT INTO portfolio."payments" ("payment_id", "account_id", "amount", "direction", "status", "occurred_at", "idempotency_key")
VALUES (4117, 2001, 75.25, 'credit', 'posted', '2026-04-01T10:00:00Z', 'idem-seed-1');
