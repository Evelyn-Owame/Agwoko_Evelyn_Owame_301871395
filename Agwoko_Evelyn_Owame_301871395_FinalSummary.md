# MIT 8103 Advanced Database Systems

**Synthetic Bank and Fintech Platform** · Evelyn Owame Agwoko · Student ID 301871395

## Case study

My case study is a Synthetic Bank and Fintech Platform, a simulated financial environment built to explore how a relational database can support real banking workflows. I designed the database with two main audiences in mind. The first is customer-service analysts, who need to review account activity and investigate payment histories. The second is database students, who need a reliable environment for testing constraints and examining query execution plans.

The data is organized into three separate tables: customers, accounts and payments. Separating these entities keeps each table focused on one subject and reduces redundancy. Together, they support three core operations:

Registering customers and opening accounts, so that every account is tied to a verified customer record.
Recording payments with retry-safe idem-potency keys, so that if a payment request is submitted more than once (for example, after a network failure or timeout), the system recognizes the repeat and does not process the same payment twice.
Reviewing and summarizing payment activity, so that analysts can examine transactions per account or customer and produce meaningful summaries.

## Portfolio 1: Database Design and Modelling

I organized the relational design into 3 tables. Primary keys identify records, foreign keys preserve the links, and checks enforce the stated business rules. When idem-potency_key is not null, the account_id and idem-potency_key pair must be unique, enforced by a partial unique index where idem-potency_key is not null. The normalization examples show the sample data at 1NF, 2NF and 3NF. All 23 deliberately invalid inserts were rejected without changing the valid sample rows.

![Synthetic Bank and Fintech Platform ER diagram](images/Agwoko_Evelyn_Owame_301871395_ERDiagram.png)

Figure 1. Tables, keys and relationships. PK: primary key; FK: foreign key; UK: unique value.

<!-- PAGE BREAK -->

## Portfolio 2: Query Processing and Optimization

I ran three SQL queries against the sample records. The join returned 2 rows and included Avery Chen with USD. For the index comparison, I used 50,000 separate performance rows. The median lookup time changed from 2.474 ms to 0.312 ms. Both phases returned the same records. The measured plan used the new index. These timings apply to this lookup and environment.

## Portfolio 3: Transactions and Concurrency

I used a temporary counter on payments to test COMMIT, ROLLBACK and READ COMMITTED isolation. The uncommitted update remained hidden from the other session, and ROLLBACK restored the earlier committed value. Without locking, two increments left the counter at 2. With SELECT FOR UPDATE, Session B waited for Session A and the final value was 3. The helper is confined to this exercise; the case's original business fields stay unchanged.

## Portfolio 4: NoSQL and Advanced Data Models

I used account_events for the case's event documents. MongoDB inserted 4 sample events and returned the expected results for 4 queries. Validation rejected an invalid date type and a duplicate event ID. Embedded snapshots keep related details with an event, while the details field can differ by event type. These are fictional events; PostgreSQL continues to enforce its relational rules.

## Repository and evidence

https://github.com/Evelyn-Owame/Agwoko_Evelyn_Owame_301871395

The portfolio folders contain the SQL and JavaScript, explanations, query plans, result tables and screenshots.


<!-- PAGE BREAK -->

## Portfolio 5: Distributed and Cloud Database Exercise

I proposed three MongoDB replica members across separate failure zones. The discussion covers primary elections, majority acknowledgement, secondary lag and sharding trade-offs for account_events. Replication supports availability, while backups address recovery. PostgreSQL needs its own availability plan. This is the permitted discussion option; no live replica set or failover test was deployed.

## Individual reflection

I kept customers, accounts, payments in separate tables so their details could be maintained without repeating them in every related record. When idem-potency_key is not null, the account_id and idem-potency_key pair must be unique, enforced by a partial unique index where idem-potency_key is not null. The constraint tests check this alongside the required values and record links. One issue illustrated by the two-session exercise is that both sessions can read the same value before either update is committed. Locking the row before reading preserves both increments. The index comparison also shows why I need to check the execution plan as well as the final answer: the same result can require different amounts of database work.

## AI-use declaration

I used GitHub Copilot and the portfolio generator to help prepare the database model, scripts and explanations. The generator ran the PostgreSQL and MongoDB exercises, checked their outputs and captured the result images.  I remain responsible for checking and explaining the submitted work.

## References

- [PostgreSQL: constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)
- [PostgreSQL: EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)
- [PostgreSQL: isolation](https://www.postgresql.org/docs/17/transaction-iso.html)
- [PostgreSQL: row locks](https://www.postgresql.org/docs/17/explicit-locking.html)
- [MongoDB: data modelling](https://www.mongodb.com/docs/manual/data-modeling/)
- [MongoDB: replication](https://www.mongodb.com/docs/manual/replication/)
- [MongoDB: sharding](https://www.mongodb.com/docs/manual/sharding/)
- [Mermaid: ER diagrams](https://mermaid.js.org/syntax/entityRelationshipDiagram.html)

