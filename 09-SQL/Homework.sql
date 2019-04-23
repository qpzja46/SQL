Use sakila


-- 1a. Display the first and last names of all actors from the table actor.
Select first_name, last_name 
from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
Select upper(concat(first_name, ' ', last_name)) as 'Actor Name'
from actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name
from actor
where first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN:
select actor_id, first_name, last_name
from actor
where last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select actor_id, last_name, first_name
from actor
where last_name like '%LI%';

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
alter table actor
add description blob;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
alter table actor
drop column description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(*)
from actor
group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(*) as occur
from actor
group by last_name
having occur > 1;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
update actor
set first_name = 'HARPO'
where first_name = 'GROUCHO'
and last_name = 'WILLIAMS';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
update actor
set first_name = 'GROUCHO'
where first_name = 'HARPO';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select first_name, last_name, address
from staff s
left join address a
on s.address_id = a.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select first_name, last_name, sum(amount) as 'Total Amount'
from staff s
left join payment p
on s.staff_id = p.staff_id
where p.payment_date like '2005-08%'
group by s.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT f.title as 'Film Title', count(fa.actor_id) as 'The number of actors'
FROM film_actor fa
inner join film f
on f.film_id = fa.film_id
group by f.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT title,
    (SELECT COUNT(inventory_id)
        FROM inventory i
        WHERE f.film_id = i.film_id) AS 'Copies of the film'
FROM film f
WHERE title = 'Hunchback Impossible'

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select c.last_name, sum(p.payment_id) as 'Total Paid'
from customer c
join payment p
on c.customer_id = p.customer_id
group by c.last_name asc;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select f.title 
from film f
where title like 'Q%' or title like 'K%';
and title in
(select title from film where language_id = 1);

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select first_name, last_name
from actor
where actor_id in
(select actor_id from film_actor where film_id in
 (select film_id from film where title = 'Alone Trip'));
 
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select * from customer;
select * from address;
select * from city;
select * from country;

select cus.first_name, cus.last_name
from customer cus
join address a
on (cus.address_id = a.address_id)
join city cty
on (a.city_id = cty.city_id)
join country 
on (cty.country_id = country.country_id)
where country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select * from film;
select * from film_category;
select * from category;

select title 
from film
where film_id in
(select film_id from film_category where category_id in
 (select category_id from category where name = 'Family'));

-- 7e. Display the most frequently rented movies in descending order.
select * from rental;
select * from inventory;
select * from film;

select f.title, count(rental_id) as 'Times rented'
from rental r
join inventory i
on (r.inventory_id = i.inventory_id)
join film f
on (i.film_id = f.film_id)
group by f.title
order by count(rental_id) desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
select * from payment;
select * from rental;
select * from inventory;
select * from store;

select s.store_id, sum(amount) as 'Each store Revenue'
from payment p
join rental r
on (p.rental_id = r.rental_id)
join inventory i
on (r.inventory_id = i.inventory_id)
join store s
on (i.store_id = s.store_id)
group by store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
select * from store;
select * from address;
select * from city;
select * from country;

select s.store_id, c.city, country.country
from store s
join address a
on (s.address_id = a.address_id)
join city c
on (a.city_id = c.city_id)
join country
on (c.country_id = country.country_id);

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select * from category;
select * from payment;
select * from film_category;
select * from inventory;
select * from rental;

select c.name as 'Genres', sum(p.amount) as 'Gross Revenue'	
from category c
join film_category fc
on (c.category_id = fc.category_id)
join inventory i
on (fc.film_id = i.film_id)
join rental r
on (i.inventory_id = r.inventory_id)
join payment p
on (r.rental_id = p.rental_id)
group by c.name 
order by sum(p.amount) desc limit 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
create view Top_Five_Genres as
select c.name as 'Genres', sum(p.amount) as 'Gross Revenue'	
from category c
join film_category fc
on (c.category_id = fc.category_id)
join inventory i
on (fc.film_id = i.film_id)
join rental r
on (i.inventory_id = r.inventory_id)
join payment p
on (r.rental_id = p.rental_id)
group by c.name 
order by sum(p.amount) desc limit 5;

-- 8b. How would you display the view that you created in 8a?
select * from Top_Five_Genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view Top_Five_Genres;