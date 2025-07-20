SET SERVEROUTPUT ON;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE employees';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE accounts';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

CREATE TABLE accounts (
    account_id   NUMBER PRIMARY KEY,
    customer_id  NUMBER,
    account_type VARCHAR2(20) CHECK (account_type IN ('Savings', 'Checking')),
    balance      NUMBER(12, 2)
);

CREATE TABLE employees (
    employee_id   NUMBER PRIMARY KEY,
    first_name    VARCHAR2(50),
    last_name     VARCHAR2(50),
    department_id NUMBER,
    salary        NUMBER(10, 2)
);

INSERT INTO accounts VALUES (1001, 1, 'Savings', 5000.00);
INSERT INTO accounts VALUES (1002, 1, 'Checking', 1200.00);
INSERT INTO accounts VALUES (1003, 2, 'Savings', 15000.00);
INSERT INTO accounts VALUES (1004, 3, 'Savings', 800.00);

INSERT INTO employees VALUES (701, 'Alice', 'Johnson', 10, 60000.00);
INSERT INTO employees VALUES (702, 'Bob', 'Miller', 10, 65000.00);
INSERT INTO employees VALUES (703, 'Charlie', 'Davis', 20, 70000.00);

COMMIT;

CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest IS
    v_interest_rate CONSTANT NUMBER := 0.01;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Scenario 1: Processing Monthly Interest ---');
    UPDATE accounts
    SET balance = balance + (balance * v_interest_rate)
    WHERE account_type = 'Savings';
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' savings accounts updated with ' || (v_interest_rate * 100) || '% interest.');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('--- Scenario 1 Complete ---');
END ProcessMonthlyInterest;
/

CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus(
    p_department_id IN employees.department_id%TYPE,
    p_bonus_percent IN NUMBER
) IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Scenario 2: Updating Employee Bonuses ---');
    DBMS_OUTPUT.PUT_LINE('Applying a ' || p_bonus_percent || '% bonus to Department ID: ' || p_department_id);
    UPDATE employees
    SET salary = salary + (salary * p_bonus_percent / 100)
    WHERE department_id = p_department_id;
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No employees found for Department ID: ' || p_department_id);
    ELSE
        DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' employee salaries updated.');
    END IF;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('--- Scenario 2 Complete ---');
END UpdateEmployeeBonus;
/

CREATE OR REPLACE PROCEDURE TransferFunds(
    p_from_account IN accounts.account_id%TYPE,
    p_to_account   IN accounts.account_id%TYPE,
    p_amount       IN accounts.balance%TYPE
) IS
    v_from_balance accounts.balance%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Scenario 3: Transferring Funds ---');
    DBMS_OUTPUT.PUT_LINE('Attempting to transfer ' || TO_CHAR(p_amount, 'FM$999,999.00') || ' from Account ' || p_from_account || ' to ' || p_to_account);
    SELECT balance INTO v_from_balance
    FROM accounts
    WHERE account_id = p_from_account
    FOR UPDATE;
    IF v_from_balance >= p_amount THEN
        UPDATE accounts
        SET balance = balance - p_amount
        WHERE account_id = p_from_account;
        UPDATE accounts
        SET balance = balance + p_amount
        WHERE account_id = p_to_account;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Success: Transfer completed.');
    ELSE
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Failure: Insufficient funds in source account ' || p_from_account);
    END IF;
    DBMS_OUTPUT.PUT_LINE('--- Scenario 3 Complete ---');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: One or both account IDs are invalid.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
        RAISE;
END TransferFunds;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '====== EXECUTING STORED PROCEDURES ======');
    ProcessMonthlyInterest;
    DBMS_OUTPUT.PUT_LINE('');
    UpdateEmployeeBonus(p_department_id => 10, p_bonus_percent => 5);
    DBMS_OUTPUT.PUT_LINE('');
    TransferFunds(p_from_account => 1001, p_to_account => 1002, p_amount => 500.00);
    DBMS_OUTPUT.PUT_LINE('');
    TransferFunds(p_from_account => 1004, p_to_account => 1001, p_amount => 1000.00);
    DBMS_OUTPUT.PUT_LINE('====== EXECUTION COMPLETE ======');
END;
/

PROMPT
PROMPT --- Verification: Final State of Data ---
PROMPT

PROMPT Updated Account Balances:
SELECT * FROM accounts ORDER BY account_id;

PROMPT
PROMPT Updated Employee Salaries:
SELECT * FROM employees ORDER BY employee_id;