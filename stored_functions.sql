-- Stored Functions!

-- Quick Example - Concat function
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM actor;


-- Ex. We are often asked to get the count of actors who have a last name starting with _

SELECT COUNT(*)
FROM actor
WHERE last_name LIKE 'S%';

SELECT COUNT(*)
FROM actor 
WHERE last_name LIKE 'T%';

SELECT COUNT(*)
FROM actor 
WHERE last_name LIKE 'R%';


-- Create a Stored Function that will give the count of actors 
-- with a last name starting with *letter*

CREATE OR REPLACE FUNCTION get_actor_count(letter VARCHAR(1))
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
	DECLARE actor_count INTEGER;
BEGIN
	SELECT COUNT(*) INTO actor_count
	FROM actor
	WHERE last_name ILIKE CONCAT(letter, '%');
	RETURN actor_count;
END;
$$;

-- Execute the function - use SELECT
SELECT get_actor_count('S');
SELECT get_actor_count('T');
SELECT get_actor_count('r');


-- TO delete a stored function, use the DROP command
-- DROP FUNCTION IF EXISTS function_name     *if function_name is unique
-- DROP FUNCTION IF EXISTS function_name(argtype)   * if function_name is not unique
DROP FUNCTION IF EXISTS get_actor_count(VARCHAR, VARCHAR);



-- Ex. We are often asked to provide a table of of all of the customers
-- that live in *country* with the first, last, address, city, district, country

SELECT first_name, last_name, address, city, district, country
FROM customer c
JOIN address a
ON c.address_id = a.address_id
JOIN city ci 
ON ci.city_id = a.city_id
JOIN country co
ON ci.country_id = co.country_id
WHERE country = 'United States';


-- Create a function that returns a table
-- When returning a table, we need to define what the table will look like (col_name DATATYPE,)

CREATE OR REPLACE FUNCTION customers_in_country(country_name VARCHAR)
RETURNS TABLE (
	first_name VARCHAR,
	last_name VARCHAR,
	address VARCHAR,
	city VARCHAR,
	district VARCHAR,
	country VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY
	SELECT c.first_name, c.last_name, a.address, ci.city, a.district, co.country
	FROM customer c
	JOIN address a
	ON c.address_id = a.address_id
	JOIN city ci 
	ON ci.city_id = a.city_id
	JOIN country co
	ON ci.country_id = co.country_id
	WHERE co.country = country_name;
END;
$$;

-- Execute a function that returns a table - use SELECT ... FROM function_name();
SELECT *
FROM customers_in_country('Canada');

SELECT *
FROM customers_in_country('Mexico');

SELECT *
FROM customers_in_country('China');

SELECT *
FROM customers_in_country('United States')
WHERE district = 'Texas';

SELECT district, COUNT(*)
FROM customers_in_country('United States')
GROUP BY district
ORDER BY COUNT(*) DESC;

-- To delete a function, use DROP FUNCTION
-- add IF EXISTS to avoid error
DROP FUNCTION IF EXISTS customers_in_country;

