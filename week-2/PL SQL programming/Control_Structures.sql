SET SERVEROUTPUT ON;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE loans';
   EXECUTE IMMEDIATE 'DROP TABLE customers';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE customers (
    customer_id NUMBER PRIMARY KEY,
    first_name  VARCHAR2(50),
    last_name   VARCHAR2(50),
    date_of_birth DATE,
    balance     NUMBER(10, 2),
    is_vip      CHAR(1) DEFAULT 'F'
);

CREATE TABLE loans (
    loan_id       NUMBER PRIMARY KEY,
    customer_id   NUMBER,
    interest_rate NUMBER(5, 2),
    due_date      DATE,
    CONSTRAINT fk_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers (customer_id, first_name, last_name, date_of_birth, balance) VALUES (1, 'John', 'Smith', DATE '1955-05-20', 8500.00);
INSERT INTO customers (customer_id, first_name, last_name, date_of_birth, balance) VALUES (2, 'Jane', 'Doe', DATE '1982-11-15', 15000.00);
INSERT INTO customers (customer_id, first_name, last_name, date_of_birth, balance) VALUES (3, 'Peter', 'Jones', DATE '1960-01-30', 25000.00);
INSERT INTO customers (customer_id, first_name, last_name, date_of_birth, balance) VALUES (4, 'Mary', 'Williams', DATE '1995-07-10', 5000.00);
INSERT INTO customers (customer_id, first_name, last_name, date_of_birth, balance) VALUES (5, 'David', 'Brown', DATE '1950-03-12', 12000.00);

INSERT INTO loans (loan_id, customer_id, interest_rate, due_date) VALUES (101, 1, 5.50, SYSDATE + 90);
INSERT INTO loans (loan_id, customer_id, interest_rate, due_date) VALUES (102, 2, 6.00, SYSDATE + 25);
INSERT INTO loans (loan_id, customer_id, interest_rate, due_date) VALUES (103, 3, 4.75, SYSDATE + 120);
INSERT INTO loans (loan_id, customer_id, interest_rate, due_date) VALUES (104, 4, 7.25, SYSDATE + 15);
INSERT INTO loans (loan_id, customer_id, interest_rate, due_date) VALUES (105, 5, 5.00, SYSDATE + 200);

COMMIT;

DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Scenario 1: Applying discount for customers over 60 ---');
    FOR cust IN (SELECT customer_id, date_of_birth FROM customers)
    LOOP
        IF (MONTHS_BETWEEN(SYSDATE, cust.date_of_birth) / 12) > 60 THEN
            UPDATE loans
            SET interest_rate = interest_rate - 1.00
            WHERE customer_id = cust.customer_id;

            DBMS_OUTPUT.PUT_LINE('Applied 1% interest discount for Customer ID: ' || cust.customer_id);
        END IF;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('--- Scenario 1 Complete ---');
    DBMS_OUTPUT.PUT_LINE('');
END;
/

DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Scenario 2: Promoting customers to VIP status ---');
    FOR cust IN (SELECT customer_id, balance FROM customers)
    LOOP
        IF cust.balance > 10000 THEN
            UPDATE customers
            SET is_vip = 'T'
            WHERE customer_id = cust.customer_id;

            DBMS_OUTPUT.PUT_LINE('Customer ID: ' || cust.customer_id || ' has been promoted to VIP.');
        END IF;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('--- Scenario 2 Complete ---');
    DBMS_OUTPUT.PUT_LINE('');
END;
/

DECLARE
    CURSOR due_loans_cursor IS
        SELECT
            c.first_name,
            c.last_name,
            l.due_date
        FROM
            customers c
        JOIN
            loans l ON c.customer_id = l.customer_id
        WHERE
            l.due_date BETWEEN SYSDATE AND SYSDATE + 30;

    v_first_name customers.first_name%TYPE;
    v_last_name  customers.last_name%TYPE;
    v_due_date   loans.due_date%TYPE;

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Scenario 3: Sending reminders for loans due within 30 days ---');
    OPEN due_loans_cursor;
    LOOP
        FETCH due_loans_cursor INTO v_first_name, v_last_name, v_due_date;
        EXIT WHEN due_loans_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Reminder: Dear ' || v_first_name || ' ' || v_last_name ||
                             ', your loan is due on ' || TO_CHAR(v_due_date, 'YYYY-MM-DD') || '.');
    END LOOP;
    CLOSE due_loans_cursor;
    DBMS_OUTPUT.PUT_LINE('--- Scenario 3 Complete ---');
END;
/

DBMS_OUTPUT.PUT_LINE('');
DBMS_OUTPUT.PUT_LINE('--- Verification: Final State of Data ---');

DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Updated Customer VIP Status:');
SELECT customer_id, first_name, last_name, balance, is_vip FROM customers;

DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Updated Loan Interest Rates:');
SELECT loan_id, customer_id, interest_rate, due_date FROM loans;

