use sakila;

--1a. Display the first and last names of all actors from the table `actor`.
SELECT 
    first_name, last_name
FROM
    actor

--1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name
SELECT 
    UPPER(CONCAT(first_name, ' ', last_name)) AS 'Actor Name'
FROM
    actor

--2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT 
    actor_id, first_name, last_name
FROM
    actor
WHERE
    first_name = 'Joe'

--2b. Find all actors whose last name contain the letters `GEN`:
SELECT 
    *
FROM
    actor
WHERE
    last_name LIKE '%GEN%'

--2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:   
SELECT 
    *
FROM
    actor
WHERE
    last_name LIKE '%LI%'
ORDER BY last_name , first_name

--2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT 
    country_id, Country
FROM
    country
WHERE
    country IN ('Afghanistan' , 'Bangladesh', 'China')

--3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB`
alter table actor
add column description blob

--3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
alter table actor
drop column description

--4a. List the last names of actors, as well as how many actors have that last name.
SELECT 
    last_name, COUNT(last_name) AS count_of_last_name
FROM
    actor
GROUP BY last_name

--4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
SELECT 
    last_name, COUNT(last_name) AS count_of_last_name
FROM
    actor
GROUP BY last_name
HAVING COUNT(last_name) > 1

--4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
update actor
set first_name = 'HARPO'
where first_name = 'GROUCHO' and last_name = 'Williams'

--4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
update actor
set first_name = 'GROUCHO'
where actor_id = 172

--5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
CREATE TABLE address (
    address_id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    address VARCHAR(100),
    address2 VARCHAR(60),
    district VARCHAR(25),
    city_id INT,
    postal_code INT,
    phone VARCHAR(20),
    location BLOB,
    last_update TIMESTAMP
)

--6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
SELECT 
    first_name, last_name, address
FROM
    staff s
        JOIN
    address a ON s.address_id = a.address_id

--6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT 
    first_name, last_name, SUM(amount)
FROM
    staff s
        JOIN
    payment p ON s.staff_id = p.staff_id
WHERE
    payment_date BETWEEN '2005-08-01' AND '2005-08-31'
GROUP BY first_name , last_name

--6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use JOIN.
SELECT 
    title, COUNT(actor_id) count_of_actors
FROM
    film f
        JOIN
    film_actor fa ON f.film_id = fa.film_id
GROUP BY title

--6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT 
    title, COUNT(inventory_id) count_in_inventory
FROM
    film f
        JOIN
    inventory i ON f.film_id = i.film_id
WHERE
    title = 'Hunchback Impossible'
GROUP BY title

--6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT 
    first_name, last_name, SUM(amount) total_customer_payment
FROM
    customer c
        JOIN
    payment p ON c.customer_id = p.customer_id
GROUP BY first_name , last_name
ORDER BY last_name

--7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT 
    title
FROM
    (SELECT 
        *
    FROM
        film
    WHERE
        title LIKE 'Q%' OR title LIKE 'K%') films

--7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT 
    CONCAT(first_name, ' ', last_name) actors_in_Alone_Trip
FROM
    (SELECT 
        a.actor_id, title, first_name, last_name
    FROM
        film f
    JOIN film_actor fa ON f.film_id = fa.film_id
    JOIN actor a ON fa.actor_id = a.actor_id
    WHERE
        title = 'Alone Trip') actors_in_movies

--7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT 
    first_name, last_name, email
FROM
    customer cust
        JOIN
    address a ON a.address_id = cust.address_id
        JOIN
    city cit ON a.city_id = cit.city_id
        JOIN
    country cntry ON cit.country_id = cntry.country_id
WHERE
    country = 'Canada'

--7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.
SELECT DISTINCT
    title
FROM
    (SELECT 
        f.title, i.*
    FROM
        inventory i
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE
        c.category_id = 8) movies

--7e. Display the most frequently rented movies in descending order.
SELECT 
    title, COUNT(r.inventory_id) times_rented
FROM
    inventory i
        JOIN
    rental r ON i.inventory_id = r.inventory_id
        JOIN
    film f ON i.film_id = f.film_id
GROUP BY title
ORDER BY times_rented DESC

--7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, SUM(amount) AS Gross
                 FROM payment p
                 JOIN rental r
                 ON (p.rental_id = r.rental_id)
                 JOIN inventory i
                 ON (i.inventory_id = r.inventory_id)
                 JOIN store s
                 ON (s.store_id = i.store_id)
                 GROUP BY s.store_id;

--7g. Write a query to display for each store its store ID, city, and country.
SELECT 
    s.store_id, c.city, ctry.country
FROM
    store s
        JOIN
    address a ON s.address_id = a.address_id
        JOIN
    city c ON a.city_id = c.city_id
        JOIN
    country ctry ON c.country_id = ctry.country_id

--7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT 
    cat.name, SUM(p.amount)
FROM
    rental r
        JOIN
    payment p ON r.rental_id = p.rental_id
        JOIN
    inventory i ON r.inventory_id = i.inventory_id
        JOIN
    film_category fc ON i.film_id = fc.film_id
        JOIN
    category cat ON fc.category_id = cat.category_id
GROUP BY cat.name
ORDER BY SUM(p.amount) DESC
LIMIT 5

--8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_five_selling_genres AS
    (SELECT 
        cat.name, SUM(p.amount)
    FROM
        rental r
            JOIN
        payment p ON r.rental_id = p.rental_id
            JOIN
        inventory i ON r.inventory_id = i.inventory_id
            JOIN
        film_category fc ON i.film_id = fc.film_id
            JOIN
        category cat ON fc.category_id = cat.category_id
    GROUP BY cat.name
    ORDER BY SUM(p.amount) DESC
    LIMIT 5)

--8b. How would you display the view that you created in 8a?
SELECT 
    *
FROM
    top_five_selling_genres

--8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
drop view top_five_selling_genres

