
SELECT COUNT(*)
FROM actor
WHERE last_name LIKE 'B%';

-- Create a Stored Function - give us a count of actors whose last name starts with *letter*
CREATE OR REPLACE FUNCTION count_actors_with_letter_name(letter VARCHAR(1))
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
	DECLARE actor_count INTEGER;
BEGIN
	SELECT COUNT(*) INTO actor_count
	FROM actor
	WHERE last_name LIKE concat(letter, '%');
	
	RETURN actor_count;
END;
$$

-- Execute/Call Function we use a SELECT 
SELECT count_actors_with_letter_name('A');




-- Create a function to return the employee with the most transactions
CREATE OR REPLACE FUNCTION employee_with_most_transactions()
RETURNS VARCHAR(100)
LANGUAGE plpgsql
AS $$
	DECLARE employee VARCHAR(100);
BEGIN
	SELECT concat(first_name, ' ', last_name) INTO employee 
	FROM staff
	WHERE staff_id = (
		SELECT staff_id 
		FROM payment
		GROUP BY staff_id 
		ORDER BY COUNT(*) DESC 
		LIMIT 1
	);

	RETURN employee;
END
$$

SELECT employee_with_most_transactions();



-- Create a function that will display all customers and their address from a certain country
CREATE OR REPLACE FUNCTION customer_in_country(country_name VARCHAR)
RETURNS TABLE(
	first_name VARCHAR,
	last_name VARCHAR,
	address VARCHAR,
	district VARCHAR,
	city VARCHAR,
	country VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY
	SELECT c.first_name, c.last_name, a.address, a.district, ci.city, co.country
	FROM customer c 
	JOIN address a 
	ON c.address_id = a.address_id 
	JOIN city ci 
	ON ci.city_id = a.city_id 
	JOIN country co
	ON co.country_id = ci.country_id
	WHERE co.country = country_name;
END
$$


SELECT *
FROM customer_in_country('United States')
WHERE last_name LIKE 'S%';


DROP FUNCTION IF EXISTS abc;





