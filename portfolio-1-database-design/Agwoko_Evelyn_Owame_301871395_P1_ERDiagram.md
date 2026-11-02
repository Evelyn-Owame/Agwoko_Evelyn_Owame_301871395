# Synthetic Bank and Fintech Platform — ER diagram

```mermaid
erDiagram
    direction LR
    customers {
        bigint customer_id PK
        text display_name
        timestamptz created_at
    }
    accounts {
        bigint account_id PK
        bigint customer_id FK
        text currency
        text status
        date opened_on
    }
    payments {
        bigint payment_id PK
        bigint account_id FK
        numeric amount
        text direction
        text status
        timestamptz occurred_at
        text idempotency_key "Optional"
    }
    customers ||--o{ accounts : "customer_id"
    accounts ||--o{ payments : "account_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Agwoko_Evelyn_Owame_301871395_ERDiagram.png)
