SELECT *
FROM customer
WHERE loyalty_member = True;

-- Reset all customers to not be loyalty members
UPDATE customer 
SET loyalty_member = FALSE;



-- Subquery to find our customer_ids who have spent over $100
SELECT customer_id
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 100;


-- UPDATE 
--UPDATE customer 
--SET loyalty_member = TRUE 
--WHERE customer_id IN (
--	-- Subquery
--	SELECT customer_id
--	FROM payment
--	GROUP BY customer_id
--	HAVING SUM(amount) > 100
--)


-- Create a procedure that will do this for us 
CREATE OR REPLACE PROCEDURE update_loyalty_status()
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE customer 
	SET loyalty_member = TRUE 
	WHERE customer_id IN (
		-- Subquery
		SELECT customer_id
		FROM payment
		GROUP BY customer_id
		HAVING SUM(amount) > 100
	);
END
$$



SELECT *
FROM customer
WHERE loyalty_member = True;
-- Call/Execute the PROCEDURE
CALL update_loyalty_status();

-- Confirm the procedure worked
SELECT *
FROM customer
WHERE loyalty_member = False;


SELECT * FROM payment p ;

INSERT INTO payment (
	customer_id, staff_id, rental_id, amount, payment_date 
)VALUES(524, 2, 1520, 100, '2022-01-13');



SELECT *
FROM customer
WHERE loyalty_member = False;

CALL update_loyalty_status();


SELECT *
FROM customer c 
WHERE customer_id = 524;



-- Create a procedure that takes in arguments
CREATE OR REPLACE PROCEDURE add_actor(
	first_name VARCHAR(50),
	last_name VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO actor(first_name, last_name, last_update)
	VALUES(first_name, last_name, NOW());
END
$$

CALL add_actor('Tom', 'Holland');

SELECT *
FROM actor a 
WHERE last_name = 'Holland'
