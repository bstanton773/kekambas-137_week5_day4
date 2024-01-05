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

CREATE OR REPLACE FUNCTION get_actor_count(letter VARCHAR(1), last_letter VARCHAR(1))
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


