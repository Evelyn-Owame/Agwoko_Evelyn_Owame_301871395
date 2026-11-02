# Portfolio 1 — Database Design and Modelling

I organised the data into customers, accounts, payments. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| customers | 2 |
| accounts | 2 |
| payments | 2 |

The 23 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](Agwoko_Evelyn_Owame_301871395_P1_Design.md)
- [ER diagram](Agwoko_Evelyn_Owame_301871395_P1_ERDiagram.md)
- [Normalisation](Agwoko_Evelyn_Owame_301871395_P1_Normalisation.md)
- [Schema](Agwoko_Evelyn_Owame_301871395_P1_Schema.sql)
- [Sample data](Agwoko_Evelyn_Owame_301871395_P1_SampleData.sql)
- [Constraint tests](Agwoko_Evelyn_Owame_301871395_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/Agwoko_Evelyn_Owame_301871395_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)

