# Synthetic Bank and Fintech Platform — SQL queries

## 1. Show related customers, accounts, payments records (up to 20).

```sql
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
```

| customers_customer_id | customers_display_name | accounts_account_id | accounts_currency | payments_payment_id | payments_amount |
| --- | --- | --- | --- | --- | --- |
| 1001 | Avery Chen | 2001 | USD | 3001 | 125.5 |
| 1002 | Riley Morgan | 2002 | EUR | 3002 | 42.75 |

## 2. Find accounts records where customer_id matches 1001 (up to 20).

```sql
SELECT * FROM portfolio."accounts"
WHERE "customer_id" IS NOT DISTINCT FROM 1001
ORDER BY "account_id"
LIMIT 20;
```

| account_id | customer_id | currency | status | opened_on |
| --- | --- | --- | --- | --- |
| 2001 | 1001 | USD | open | 2026-01-16 |

## 3. Count accounts records for each customer_id (up to 20 groups).

```sql
SELECT "customer_id", count(*) AS record_count
FROM portfolio."accounts"
GROUP BY "customer_id"
ORDER BY record_count DESC, "customer_id" NULLS LAST
LIMIT 20;
```

| customer_id | record_count |
| --- | --- |
| 1001 | 1 |
| 1002 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 2.474 | 2.389, 6.763, 2.474 | Sort → Seq Scan | 274 |
| After index | 0.312 | 0.326, 0.312, 0.29 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 55 |

The median execution time changed from 2.474 ms to 0.312 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=2.356..2.359 rows=50 loops=1)
  Seq Scan on payments (actual time=0.014..2.316 rows=50 loops=1)
Planning Time: 0.391 ms
Execution Time: 2.389 ms
```

### Before index, run 2

```text
Sort (actual time=6.721..6.725 rows=50 loops=1)
  Seq Scan on payments (actual time=0.021..6.662 rows=50 loops=1)
Planning Time: 1.731 ms
Execution Time: 6.763 ms
```

### Before index, run 3

```text
Sort (actual time=2.441..2.444 rows=50 loops=1)
  Seq Scan on payments (actual time=0.014..2.402 rows=50 loops=1)
Planning Time: 0.356 ms
Execution Time: 2.474 ms
```

### After index, run 1

```text
Sort (actual time=0.263..0.266 rows=50 loops=1)
  Bitmap Heap Scan on payments (actual time=0.029..0.209 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.013..0.014 rows=50 loops=1)
Planning Time: 0.599 ms
Execution Time: 0.326 ms
```

### After index, run 2

```text
Sort (actual time=0.249..0.251 rows=50 loops=1)
  Bitmap Heap Scan on payments (actual time=0.028..0.21 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.014 rows=50 loops=1)
Planning Time: 0.567 ms
Execution Time: 0.312 ms
```

### After index, run 3

```text
Sort (actual time=0.231..0.233 rows=50 loops=1)
  Bitmap Heap Scan on payments (actual time=0.029..0.191 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.015 rows=50 loops=1)
Planning Time: 0.593 ms
Execution Time: 0.29 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Agwoko_Evelyn_Owame_301871395_P2_Queries.sql, then Agwoko_Evelyn_Owame_301871395_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Agwoko_Evelyn_Owame_301871395_P2_QueryResults.png) · [Index comparison](screenshots/Agwoko_Evelyn_Owame_301871395_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

