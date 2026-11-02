-- Show related customers, accounts, payments records (up to 20).
SELECT t0."customer_id" AS "customers_customer_id",
       t0."display_name" AS "customers_display_name",
       t1."account_id" AS "accounts_account_id",
       t1."currency" AS "accounts_currency",
       t2."payment_id" AS "payments_payment_id",
       t2."amount" AS "payments_amount"
FROM portfolio."customers" t0
JOIN portfolio."accounts" t1 ON t1."customer_id" = t0."customer_id"
JOIN portfolio."payments" t2 ON t2."account_id" = t1."account_id"
ORDER BY t0."customer_id", t1."account_id", t2."payment_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."customer_id" AS "customers_customer_id",
       t0."display_name" AS "customers_display_name",
       t1."account_id" AS "accounts_account_id",
       t1."currency" AS "accounts_currency",
       t2."payment_id" AS "payments_payment_id",
       t2."amount" AS "payments_amount"
FROM portfolio."customers" t0
JOIN portfolio."accounts" t1 ON t1."customer_id" = t0."customer_id"
JOIN portfolio."payments" t2 ON t2."account_id" = t1."account_id"
ORDER BY t0."customer_id", t1."account_id", t2."payment_id"
LIMIT 20;

-- Find accounts records where customer_id matches 1001 (up to 20).
SELECT * FROM portfolio."accounts"
WHERE "customer_id" IS NOT DISTINCT FROM 1001
ORDER BY "account_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."accounts"
WHERE "customer_id" IS NOT DISTINCT FROM 1001
ORDER BY "account_id"
LIMIT 20;

-- Count accounts records for each customer_id (up to 20 groups).
SELECT "customer_id", count(*) AS record_count
FROM portfolio."accounts"
GROUP BY "customer_id"
ORDER BY record_count DESC, "customer_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "customer_id", count(*) AS record_count
FROM portfolio."accounts"
GROUP BY "customer_id"
ORDER BY record_count DESC, "customer_id" NULLS LAST
LIMIT 20;
