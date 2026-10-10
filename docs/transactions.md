1. What a transaction is:
* A transaction is a sequance of one or more database operations/queries/statements (one unit of business work).

2. Why our order creation needs a transaction:
* Because orders perform very important operations, and avoiding any kind of anamolies between those transactions is very important. That's why we use ACID properties in dbms that guarantee validity of daata even in the event of failures/errors while transaction runs, and after it completes.

3. ACID in your own words
* ACID is a database transaction properties/principles that guarintee validity of data, even in the event of errors/failures while the transaction runs, and after it completes.

4. The failed transaction experiment:
* I failed a lot while practising acid atommicity and consistency. And, every time i should have to go back by running ROLLBACK, because whatever i type wasn't being accepted after the failure/error. And, after i go to the main state, i could make sure that no changes were applied, neverthless i made some of them in the transaction period.

5. What happened after the foreign-key error:
* The error message pop-up, and explain the error. Although i typed and tried to run some queries after error/failure, i couldn't manage and go back by running ROLLBACK.

6. Dirty read experiment:
* In dirty read experiment, i have leart and made sure that when 2 or more transaction goes on parellel in one database, the changings after the commit of one transaction could be seen/readable by others even if they all begin their journey from the same state. Especially, in the Read Committed morde.

7. Non-repeatable read experiment:
* In non-repeatable read experiment, i saw how this mode works in the acid principles. After commitment by the concurrent trnasaction, the state could be readable by other concurrent transactions.

8. Repeatable Read experiment:
* In Repeatable Read experiment, i have understood the difference between the modes, and saw how this one works. In the concurrent transactions, if one of them have committed the change, the other ones couldn't read these changes. They could read but onyl after they also commit and go back to main state. But in the time, they only see/read the stable snapshot.

9. Your understanding of phantom reads:
* Phantom reads works a little like Repeatable Read, but there is a nuance. We couldn't see the explicit changes by the concurrent transactions, but we might see them if we use conditional statements. But, i couldn't use that, i dunno why!

10. Why stronger isolation isn't automatically "better":
* I don't understand what you mean by 'stronger' but, each isolation method/mode is unique and usable when they meet the business goals and wants.