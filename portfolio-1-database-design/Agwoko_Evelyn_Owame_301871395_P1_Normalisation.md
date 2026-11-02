# Synthetic Bank and Fintech Platform — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| customer_id | accounts records (list) |
| --- | --- |
| 1001 | [2001] |
| 1002 | [2002] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| accounts.account_id | accounts.customer_id | accounts.currency | customers.customer_id | customers.display_name |
| --- | --- | --- | --- | --- |
| 2001 | 1001 | USD | 1001 | Avery Chen |
| 2002 | 1002 | EUR | 1002 | Riley Morgan |

Key: account_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## accounts_example

| accounts.account_id | accounts.customer_id | accounts.currency | customers.customer_id | customers.display_name |
| --- | --- | --- | --- | --- |
| 2001 | 1001 | USD | 1001 | Avery Chen |
| 2002 | 1002 | EUR | 1002 | Riley Morgan |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## customers

| customer_id | display_name | created_at |
| --- | --- | --- |
| 1001 | Avery Chen | 2026-01-15T10:00:00+00:00 |
| 1002 | Riley Morgan | 2026-02-20T14:30:00+00:00 |

## accounts

| account_id | customer_id | currency | status | opened_on |
| --- | --- | --- | --- | --- |
| 2001 | 1001 | USD | open | 2026-01-16 |
| 2002 | 1002 | EUR | suspended | 2026-02-21 |

## payments

| payment_id | account_id | amount | direction | status | occurred_at | idempotency_key |
| --- | --- | --- | --- | --- | --- | --- |
| 3001 | 2001 | 125.5 | credit | posted | 2026-03-01T12:15:00+00:00 | idem-seed-1 |
| 3002 | 2002 | 42.75 | debit | pending | 2026-03-02T09:45:00+00:00 | NULL |

## Dependencies

- customers: (customer_id) → display_name, created_at
- accounts: (account_id) → customer_id, currency, status, opened_on
- payments: (payment_id) → account_id, amount, direction, status, occurred_at, idempotency_key

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
