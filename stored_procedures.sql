-- Stored Procedures!

SELECT *
FROM customer;

-- If you don't have loyalty member column, execute the following:
--ALTER TABLE customer
--ADD COLUMN loyalty_member BOOLEAN;

-- Reset all of the customers to not be loyalty members
UPDATE customer
SET loyalty_member = FALSE;

SELECT *
FROM customer
WHERE loyalty_member = TRUE;

-- Create a Procedure that will make any customer who has spent >= $100 a loyalty member


-- Step 1. Get all of the customer IDs of those who have spent at least $100
SELECT customer_id
FROM payment
GROUP BY customer_id
HAVING SUM(amount) >= 100;

-- Step 2. Write a DML statement to update any customer whose ID is in Step 1's query
UPDATE customer
SET loyalty_member = TRUE 
WHERE customer_id IN (
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	HAVING SUM(amount) >= 100
);

SELECT *
FROM customer c 
WHERE loyalty_member = TRUE;

-- Step 3. Take the command from Step 2 and put it as the body of a procedure
CREATE OR REPLACE PROCEDURE update_loyalty_status()
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE customer
	SET loyalty_member = TRUE 
	WHERE customer_id IN (
		SELECT customer_id
		FROM payment
		GROUP BY customer_id
		HAVING SUM(amount) >= 100
	);
END;
$$;

-- Execute a procdure - use CALL
CALL update_loyalty_status();

SELECT *
FROM customer
WHERE loyalty_member = TRUE;


-- Let's pretend a user right below the threshold makes a new payment

-- Find a customer who is close (95-100)
SELECT customer_id, SUM(amount)
FROM payment p 
GROUP BY customer_id
HAVING SUM(amount) BETWEEN 95 AND 100
ORDER BY SUM(amount);

SELECT *
FROM customer 
WHERE customer_id = 132; -- loyalty_member = False

-- Add a new payment for customer_id of 132 for $4.99
INSERT INTO payment(customer_id, staff_id, rental_id, amount, payment_date)
VALUES (132, 1, 1, 4.99, '2024-01-05 13:59:30');

-- Call the procedure again
CALL update_loyalty_status(); 


SELECT *
FROM customer 
WHERE customer_id = 132;

SELECT COUNT(*)
FROM customer 
WHERE loyalty_member = TRUE;


-- Create a Procedure to add a new row to the actor table

SELECT *
FROM actor;

SELECT NOW();

INSERT INTO actor(first_name, last_name, last_update)
VALUES ('Brian', 'Stanton', NOW());

INSERT INTO actor(first_name, last_name, last_update)
VALUES ('Sarah', 'Stodder', NOW());

SELECT *
FROM actor
ORDER BY actor_id DESC;

-- Put the insert into a procedure that will accept the column arguments
CREATE OR REPLACE PROCEDURE add_actor(first_name VARCHAR, last_name VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN 
	INSERT INTO actor(first_name, last_name, last_update)
	VALUES (first_name, last_name, NOW());
END;
$$;

-- Add actors
CALL add_actor('Florence', 'Pugh');
CALL add_actor('Cillian', 'Murphy');
CALL add_actor('Tom', 'Hanks');

SELECT *
FROM actor a 
ORDER BY actor_id DESC;

-- To delete a procedure, we use DROP PROCEDURE procedure_name
DROP PROCEDURE IF EXISTS update_loyalty_status;



