# MIT 8103 Advanced Database Systems

**Synthetic Bank and Fintech Platform** · Evelyn Owame Agwoko · Student ID 301871395

## Case Study
My case study is centered on a synthetic bank and fintech platform, a man-made financial environment I created to see how a relational database can handle real banking work. I had two kinds of users in mind when I build it. The first one is a customer-service analysts, who have to look through the account activity and dig into payment histories. The second one is a database students, who need a dependable place to test a constraints and study how queries get executed.

The data are kept in three different tables: customers, accounts, and payments.The reason they are Kept separate is because each table covers just one subject, and it cuts down on repeated data and between them, they support three main jobs.

The first job is to register customers and open accounts, so every account traces back to a verified customer record. The second job is to record payments using idempotency keys, which make retries safe. If the same payment request arrives twice, like after a network failure or a timeout, the system spots the repeat and doesn’t process the payment a second time. The third job is to review and summarize payment activity, so analysts can look at the transactions by account or by customer and pull together summaries that actually mean something.

## Portfolio 1: Database Design and Modelling

I split the relational design into three different tables. The primary keys identify each record, the foreign keys keep the tables linked, and the check constraints enforce the business rules I set. When an idempotency_key is present, the combination of account_id and idempotency_key has to be unique. I enforced that with a partial unique index that only applies where idempotency_key is not null. The normalization examples walk the sample data through 1NF, 2NF, and 3NF. I also tried 23 deliberately invalid inserts, and all were rejected, with the valid sample rows left untouched.

![Synthetic Bank and Fintech Platform ER diagram](images/Agwoko_Evelyn_Owame_301871395_ERDiagram.png)

Figure 1. Tables, keys and relationships. PK: primary key; FK: foreign key; UK: unique value.

<!-- PAGE BREAK -->

## Portfolio 2: Query Processing and Optimization

I ran three SQL queries against the sample records. The join returned two rows, one of which was Avery Chen’s USD account. To compare the index performance, I loaded 50,000 separate rows just for testing. The median lookup time dropped from 2.474 ms to 0.312 ms, and both of the runs returned the same records. The query plan confirmed that the new index was being used. These timings only reflect this particular lookup in my environment, so they shouldn’t be read as a general benchmark.

## Portfolio 3: Transactions and Concurrency

To test COMMIT, ROLLBACK, and READ COMMITTED isolation, I added a temporary counter to the payments table. While an update was still uncommitted, the other session couldn’t see it, and a ROLLBACK to put the counter back to its last committed value. Without locking, two increments left the counter at 2, so one update was lost. When I used SELECT FOR UPDATE, Session B waited until Session A finished, and the final value came out at 3. The counter is only a helper for this exercise, and the case’s original business fields were never changed.

## Portfolio 4: NoSQL and Advanced Data Models

For the case’s event documents, I used a MongoDB collection called account_events. I inserted four sample events, and all the four queries returned what I expected. Validation also did its job because, it rejected a document with an invalid date type and another one with a duplicate event ID. Each event carries embedded snapshots, so the related details stay with it, and the details field is free to vary by event type. The events are all fictional, and PostgreSQL still enforces its relational rules on the core data.

## Repository and evidence

https://github.com/Evelyn-Owame/Agwoko_Evelyn_Owame_301871395

The portfolio folders contain the SQL and JavaScript, explanations, query plans, result tables and screenshots.


<!-- PAGE BREAK -->

## Portfolio 5: Distributed and Cloud Database Exercise

I proposed a MongoDB replica set with three members placed in separate failure zones. The discussion covers how primary elections work, what majority acknowledgement means for writes, how far secondaries can lag, and the trade-offs of sharding account_events. Replication keeps the system available, but it isn’t a substitute for backups, which are what you rely on for recovery. PostgreSQL would need its own availability plan. For this part I took the discussion-only option the assignment allows, so I didn’t deploy a live replica set or run a failover test.

## Individual reflection

I kept the customers, accounts, and payments in separate tables so each one’s details can be maintained in a single place instead of being repeated in every related record. Where an idempotency_key is present, the account_id and idempotency_key pair has to be unique, which I enforced with a partial unique index that only applies when the key is not null. My constraint tests check that the rule along with the required values and the links between records.

The two-session exercise showed a problem clearly because, both sessions can read the same value before either one commits its update, so one increment gets lost. Locking the row before reading it fixed that and kept both increments. The index comparison taught me something similar. I need to look at the execution plan as well as the final answer, because the same result can take very different amounts of work from the database.

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

