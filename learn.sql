SELECT * FROM film;
SELECT title, description FROM film ORDER BY title DESC LIMIT 100;
SELECT first_name, last_name, email FROM customer;
SELECT DISTINCT rental_duration FROM film ORDER BY rental_duration;
SELECT COUNT(rating) FROM film;
SELECT COUNT(DISTINCT rating) FROM film;
SELECT film_id, title, description  FROM film WHERE length = 117;
SELECT film_id, title, description  FROM film WHERE title = 'Graffiti Love';
SELECT film_id, title, description  FROM film WHERE title = 'Graffiti Love' OR length = 117;
SELECT COUNT(*)  FROM film WHERE title != 'Graffiti Love';

SELECT * FROM customer;
SELECT email FROM customer WHERE first_name = 'Nancy' AND  last_name = 'Thomas';
SELECT description FROM film WHERE title = 'Outlaw Hanky';

SELECT * FROM address;
SELECT phone FROM address WHERE address = '259 Ipoh Drive';

SELECT rental_duration, title, description FROM film ORDER BY rental_duration, title;

/*
	ORDER BY CAN BE APPLIED TO MORE THAN ONE FIELD AND ORDERS CAN ALSO BE CHANGED
*/
SELECT rental_duration, title, description FROM film ORDER BY rental_duration DESC, title ASC;

/*
	Last 5 payment transactions
*/
SELECT * FROM payment WHERE amount > 0 ORDER BY payment_date DESC LIMIT 5;

SELECT customer_id FROM payment WHERE AMOUNT != 0.00 ORDER BY payment_date ASC LIMIT 10;

SELECT title FROM film ORDER BY length LIMIT 5;

SELECT count(*) FROM film WHERE length <= 50;

/*
	10 AND 30 IS INCLUSIVE
*/
SELECT * FROM film WHERE film_id BETWEEN 10 AND 30;

/*
	10 AND 30 IS EXCLUSIVE
*/
SELECT * FROM film WHERE film_id NOT BETWEEN 10 AND 30 ORDER BY film_id ASC;


/*

* BETWEEN CAN ALSO BE APPLIED TO DATES BUT THE DATES SHOULD BE IN ISO 8601 FORMAT - (YYYY-MM-DD)

* ALSO BE CAREFUL WHILE USING BETWEEN FOR DATE TIME DUE TO THE EXCLUSIVITY OF TIME
  EG: 2007-02-01 TO 2007-02-14 INLCUDES 00:00:00 OF 1ST TO ONLY 00:00:00 TIME OF 14TH 
  IE 2007-02-14 15:43:55 WONT BE INCLUDED

*/ 
SELECT COUNT(*) FROM customer;
SELECT * FROM customer WHERE create_date BETWEEN '2006-02-12' AND '2006-02-14';

SELECT * FROM payment WHERE payment_date BETWEEN '2007-02-01' AND '2007-02-15';

SELECT * FROM payment WHERE amount IN(2.99, 5.99);
SELECT * FROM payment WHERE amount NOT IN(2.99, 5.99);
SELECT * FROM customer WHERE first_name IN('Jake', 'John', 'Julie');

/*
	LIKE is case sensitive 
	ILIKE is case insensitive
	LIKE opertator allows us to perform pattern matching against string data
	It uses wildcard % and _ 
	% - matches any sequence of characters
	_ - matches single character
*/

/*
	First name starts with J
*/
SELECT * FROM customer WHERE first_name LIKE 'J%';
SELECT * FROM customer WHERE first_name LIKE 'J%' AND last_name LIKE 'S%';
SELECT * FROM customer WHERE first_name LIKE '%er%';
/*
	Starts with any char, has her as 2nd, 3rd and 4th characters and has any characters after that
*/
SELECT * FROM customer WHERE first_name LIKE '_her%';
SELECT * FROM customer WHERE first_name NOT LIKE '_her%';

SELECT * FROM customer WHERE first_name LIKE 'A%' ORDER BY last_name;

SELECT COUNT(*) FROM payment WHERE amount > 5.00;
SELECT COUNT(*) FROM actor WHERE first_name LIKE 'P%';
SELECT * FROM address;
SELECT DISTINCT district FROM address;

SELECT COUNT(*) FROM film WHERE rating = 'R' AND replacement_cost BETWEEN 5.00 AND 10.00;

/*
	The main idea behind aggregate functions is to take multiple inputs and produce a single output 
	Common aggregate functions
	--------------------------
		AVG() - gives floating point output use ROUND() to round it off
		COUNT()
		MAX()
		MIN()
		SUM()
	
	Aggregate function calls can only happen during WHERE clause or HAVING clause
*/

SELECT MIN(replacement_cost) FROM film;
SELECT MAX(replacement_cost) FROM film;
SELECT MIN(replacement_cost), MAX(replacement_cost) FROM film;
SELECT AVG(replacement_cost) FROM film;
SELECT ROUND(AVG(replacement_cost), 3) FROM film;


/*
	Inorder to use more than one columns on this agg function we need to use GROUP BY statement

	SELECT category_col, AGG(data_col) FROM table_name GROUP BY category_col

	GROUP BY must come after FROM or WHERE clause
	Of all columns mentioned after select statement the ones without agg fucntions must be mentioned after GROUP BY as well

	SELECT company, division, SUM(sales) FROM finance_table GROUP BY company, division;
	SELECT company, division, SUM(sales) FROM finance_table WHERE division IN('marketing', 'transport') GROUP BY company, division;

	WHERE clause cannot compare or operate on the output of agg column SUM(sales)

	If we want to sort based on the output of agg we need to mention the total agg function
	SELECT company, division, SUM(sales) FROM finance_table GROUP BY company, division ORDER BY SUM(sales);
*/

/*
	Simplest group by statement - similar to DISTINCT 
*/
SELECT customer_id FROM payment GROUP BY customer_id;
/*
	Top 5 revenue generating customers
*/
SELECT customer_id, SUM(amount) FROM payment GROUP BY customer_id ORDER BY SUM(amount) DESC LIMIT 5;
/*
	Amount spend by a customer per staff
*/
SELECT customer_id, staff_id, SUM(amount) FROM payment GROUP BY customer_id, staff_id ORDER BY customer_id, staff_id;
/*
	For timestamp data type use DATE(timestamp_col) function before GROUP BY , this converts date time to date
*/

SELECT DATE(payment_date) FROM payment;

/*
	Revenue per day
*/

SELECT DATE(payment_date), SUM(amount) FROM payment GROUP BY DATE(payment_date) ORDER BY DATE(payment_date);

/*
	Top 5 revenue dates 
*/

SELECT DATE(payment_date), SUM(amount) FROM payment GROUP BY DATE(payment_date) ORDER BY SUM(amount) DESC LIMIT 5;
/*
	No of transactions handled by staff one and two
*/
SELECT staff_id, COUNT(amount) FROM payment WHERE staff_id IN(1, 2) GROUP BY staff_id ORDER BY COUNT(amount) DESC;
/*
	Most transactions handled bonus winner between staff one and two
*/
SELECT staff_id, COUNT(amount) FROM payment WHERE staff_id IN(1, 2) GROUP BY staff_id ORDER BY COUNT(amount) DESC LIMIT 1;
/*
	Avg replacement cost per movie rating
*/
SELECT rating, AVG(replacement_cost) FROM film GROUP BY rating ORDER BY AVG(replacement_cost) DESC;

/*
	HAVING clause allows us to filter after an agg has taken place, so it comes after GROUP BY
	
	SELECT company, division, SUM(sales) FROM finance_table WHERE division IN('marketing', 'transport') GROUP BY company, division;
	
	In above mentioned query we filtered division, since its not a column under agg function, but SUM(sales) column that we are selecting 
	forms only after the GROUP BY clause is executed, so filtering based on the SUM(sales) column should happen after GROUP BY and we use 
	HAVING clause for it.
	
	SELECT company, division, SUM(sales) FROM finance_table WHERE division IN('marketing', 'transport') GROUP BY company, division HAVING SUM(sales) > 1000;
*/
SELECT * FROM payment;
SELECT customer_id, SUM(amount) FROM payment GROUP BY customer_id HAVING SUM(amount) > 200 ORDER BY SUM(amount) DESC ;






