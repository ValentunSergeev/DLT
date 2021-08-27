CREATE TABLE accounts (
  id INTEGER PRIMARY KEY,
  name varchar(255),
  credit INTEGER
 );

 INSERT INTO accounts VALUES (1, "1", 1000), (2, "2", 1000), (3, "3", 1000);

BEGIN TRANSACTION;

UPDATE accounts SET credit = credit - 500 WHERE id = 1;
UPDATE accounts SET credit = credit + 500 WHERE id = 3;

END TRANSACTION;

BEGIN TRANSACTION;

UPDATE accounts SET credit = credit - 700 WHERE id = 2;
UPDATE accounts SET credit = credit + 700 WHERE id = 1;

END TRANSACTION;

BEGIN TRANSACTION;

UPDATE accounts SET credit = credit - 100 WHERE id = 2;
UPDATE accounts SET credit = credit + 100 WHERE id = 3;

END TRANSACTION;

SELECT * FROM accounts
-----------------------------
CREATE TABLE accounts (
  id INTEGER PRIMARY KEY,
  name varchar(255),
  bankName varchar(255),
  credit INTEGER
 );

INSERT INTO accounts VALUES (1, "1", "S", 1000), (2, "2", "T", 1000), (3, "3", "S", 1000),  (4, "Fees", "-", 0);

BEGIN TRANSACTION;

UPDATE accounts SET credit = credit - 500 WHERE id = 1;
UPDATE accounts SET credit = credit + 500 WHERE id = 3;

END TRANSACTION;

BEGIN TRANSACTION;

UPDATE accounts SET credit = credit - 700 WHERE id = 2;
UPDATE accounts SET credit = credit - 30 WHERE id = 2;
UPDATE accounts SET credit = credit + 30 WHERE id = 4;
UPDATE accounts SET credit = credit + 700 WHERE id = 1;

END TRANSACTION;

BEGIN TRANSACTION;

UPDATE accounts SET credit = credit - 100 WHERE id = 2;
UPDATE accounts SET credit = credit - 30 WHERE id = 2;
UPDATE accounts SET credit = credit + 30 WHERE id = 4;
UPDATE accounts SET credit = credit + 100 WHERE id = 3;

END TRANSACTION;

SELECT * FROM accounts
------------------------

CREATE TABLE accounts (
  id INTEGER PRIMARY KEY,
  name varchar(255),
  bankName varchar(255),
  credit INTEGER
 );

CREATE TABLE transactions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  fromId INTEGER NOT NULL,
  toId INTEGER NOT NULL,
  fee INTEGER NOT NULL,
  amount INTEGER NOT NULL,
  createdAt DATE,

  FOREIGN KEY (fromid) REFERENCES accounts(id),
  FOREIGN KEY (toid) REFERENCES accounts(id)
 );

INSERT INTO accounts VALUES (1, "1", "S", 1000), (2, "2", "T", 1000), (3, "3", "S", 1000),  (4, "Fees", "-", 0);

BEGIN TRANSACTION;

UPDATE accounts SET credit = credit - 500 WHERE id = 1;
UPDATE accounts SET credit = credit + 500 WHERE id = 3;
INSERT INTO transactions VALUES (NULL, 1, 3, 0, 500, date("now"));

END TRANSACTION;

BEGIN TRANSACTION;

UPDATE accounts SET credit = credit - 700 WHERE id = 2;
UPDATE accounts SET credit = credit - 30 WHERE id = 2;
UPDATE accounts SET credit = credit + 30 WHERE id = 4;
UPDATE accounts SET credit = credit + 700 WHERE id = 1;

INSERT INTO transactions VALUES (NULL, 2, 1, 30, 700, date("now"));

END TRANSACTION;


BEGIN TRANSACTION;

UPDATE accounts SET credit = credit - 100 WHERE id = 2;
UPDATE accounts SET credit = credit - 30 WHERE id = 2;
UPDATE accounts SET credit = credit + 30 WHERE id = 4;
UPDATE accounts SET credit = credit + 100 WHERE id = 3;

INSERT INTO transactions VALUES (NULL, 2, 3, 30, 100, date("now"));

END TRANSACTION;
SELECT * FROM accounts;

SELECT * FROM transactions;

