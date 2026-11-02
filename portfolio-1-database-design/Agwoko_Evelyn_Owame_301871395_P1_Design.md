# Synthetic Bank and Fintech Platform — database design

My case study records customers, accounts, payments.

## Users

- Customer-service analysts reviewing account activity
- Database students testing constraints and query plans

## Main operations

- Register customers and open accounts
- Record payments with retry-safe idempotency keys
- Review and summarize payment activity

## Entities

| Entity | Information stored |
| --- | --- |
| customers | Synthetic customer identity and registration data. |
| accounts | An account owned by one customer, with currency and lifecycle status. |
| payments | A synthetic credit or debit payment recorded against one account. |

## customers

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| customer_id | BIGINT | PK | Yes |
| display_name | TEXT |  | Yes |
| created_at | TIMESTAMPTZ |  | Yes |


## accounts

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| account_id | BIGINT | PK | Yes |
| customer_id | BIGINT | FK | Yes |
| currency | TEXT |  | Yes |
| status | TEXT |  | Yes |
| opened_on | DATE |  | Yes |
- customer_id → customers.customer_id

## payments

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| payment_id | BIGINT | PK | Yes |
| account_id | BIGINT | FK | Yes |
| amount | NUMERIC(18,2) |  | Yes |
| direction | TEXT |  | Yes |
| status | TEXT |  | Yes |
| occurred_at | TIMESTAMPTZ |  | Yes |
| idempotency_key | TEXT |  | No |
- account_id → accounts.account_id

## Relationships and business rules

- Every customer must have a non-empty display name.
- Every account must reference an existing customer through the declared customer_id foreign key.
- Account status must be open, suspended, or closed.
- Payment amount must be greater than zero.
- Payment direction must be credit or debit.
- Every payment must reference an existing account through the declared account_id foreign key.
- When idempotency_key is not null, the account_id and idempotency_key pair must be unique, enforced by a partial unique index where idempotency_key is not null.

## Assumptions

- All records and identifiers are synthetic; identifiers are globally unique.
- Each account belongs to exactly one customer, and each payment belongs to exactly one account.
- Payment amounts are positive decimal values; direction is credit or debit, and status is pending, posted, or rejected.
- For a normalization example, begin with an account relation containing account_id, customer_id, customer_display_name, and currency. Since customer_id determines customer_display_name, separate customer data into customers and retain customer_id as the account foreign key; the example has one customer role and no repeated ancestor roles.
- An idempotency key may be absent; when present, it is unique within its account.
- Use a separate synthetic benchmark plan: generate 50000 payment rows, compare EXPLAIN plans for an occurred_at date-range filter before and after adding a B-tree index on payments.occurred_at, and record the plans without treating timings as required results.

