use sakila;

Set sql_safe_updates = 0;

-- Question 1a & 1b

alter table actor add column Actor_name varchar(30);
update actor set Actor_name = concat(first_name, ' ', last_name);
-- drop column Actor_name;

-- Question 2a

Select * from actor
where first_name = "Joe";

-- Question 2b

Select * from actor
Where last_name like "%Gen%";

-- Question 2c

Select last_name, first_name from actor
Where last_name like "%li%";

-- Question 2d

Select country_id, country from country
Where country in ("Afghanistan","Bangladesh", "China");

-- Question 3a

alter table actor
add column middle_name varchar(30) after first_name;

-- Question 3b

alter table actor
modify column middle_name blob;

-- Question 3c

alter table actor
drop column middle_name;

-- Question 4a

Select last_name, Count(*) as 'num'
from actor
Group by last_name;

-- Question 4b

Select last_name, Count(*) as 'num'
from actor
Group by last_name
Having Count(*) > 1;

-- Question 4c

Update actor
Set first_name = "HARPO", Actor_name = "HARPO WILLIAMS"
Where first_name = "GROUCHO" and Actor_name = "GROUCHO WILLIAMS";

-- Question 4d

Select
	Case
    when actor.first_name = "HARPO" then "GROUCHO"
    when actor.first_name = "GROUCHO" then "MUCHO GROUCHO"
    else actor.first_name
End
from actor;

-- Question 5a

Select * from sakila.address;

-- Question 6a

Select staff.first_name, staff.last_name, address.address
from address
inner join staff
on address.address_id = staff.address_id;

-- Question 6b

Select s.staff_id, sum(s.amount) as August_sales
from (Select staff.staff_id, payment.amount, payment.payment_date  
	  from payment
	  inner join staff
	  on staff.staff_id = payment.staff_id
	  where payment.payment_date between "2005-08-01 00:00:00" and "2005-08-30 00:00:00") as s
Group by s.staff_id;

 -- Question 6c
 
Select count(film_actor.actor_id) as Number_of_actors, film.title
from film
inner join film_actor
on film.film_id = film_actor.film_id
Group by film.title;

-- Question 6d

Select title, Copies_of_title
from (Select count(inventory.inventory_id) as Copies_of_title, film.title
	  from inventory
	  inner join film
	  on inventory.film_id = film.film_id
	  Group by film.title
	  limit 10000) as s
where title = "Hunchback Impossible";

-- Question 6e

Select customer.last_name, sum(payment.amount) as Total_Payment
from customer
Inner join payment
on customer.customer_id = payment.customer_id
Group by customer.last_name;

-- Question 7a

Select * 
from (Select * from film
where title >= "K" and title <= "Q") as s
where language_id = 1;

-- Question 7b

Select title, Actor_name
from (Select title, actor.Actor_name
	  from (Select film.title, film_actor.actor_id
		    from film
		    inner join film_actor
		    on film.film_id = film_actor.film_id) as s
	  inner join actor
	  on s.actor_id = actor.actor_id) as t
where title = "ALONE TRIP";

-- Question 7c

Select u.first_name, u.last_name, u.email, u.country
from (Select t.first_name, t.last_name, t.email, country.country_id, country.country
	  from (Select s.first_name, s.last_name, s.email, city.country_id
		    from (Select customer.first_name, customer.last_name, customer.email, address.city_id
			      from customer
			      Inner join address
				  on customer.address_id = address.address_id) as s
		    inner join city
		    on s.city_id = city.city_id) as t
	  inner join country
	  on t.country_id = country.country_id) as u
where u.country = "Canada";

-- Question 7d

Select t.title, t.name
from (Select s.title, category.name
	  from (Select film.title, film_category.category_id
		    from film
		    inner join film_category
			on film.film_id = film_category.film_id) as s
	  inner join category
	  on s.category_id = category.category_id) as t
where t.name = "Family";

-- Question 7e

Select s.title, count(rental.rental_id) as Rental_Count
from (Select film.title, inventory.inventory_id
	  from film
	  inner join inventory
	  on film.film_id = inventory.film_id
      limit 20000) as s
inner join rental
on s.inventory_id = rental.inventory_id
Group by s.title
Order by Rental_Count desc
limit 20000;

-- Question 7f

Select payment.staff_id as Store, sum(payment.amount) as Store_totals
from (Select s.film_id, rental.rental_id
	  from (Select film.film_id, inventory.inventory_id
			from film
			inner join inventory
			on film.film_id = inventory.film_id
			limit 20000) as s
	  inner join rental
	  on s.inventory_id = rental.inventory_id
	  limit 20000) as t
inner join payment
on t.rental_id = payment.rental_id
Group by payment.staff_id
limit 20000;

-- Question 7g

Select t.store_id, t.city, country.country
from (Select s.store_id, city.city, city.country_id
	  from (Select store.store_id, address.city_id
			from store
			inner join address
			on store.address_id = address.address_id) as s
	  inner join city
	  on s.city_id = city.city_id) as t
inner join country
on t.country_id = country.country_id;

-- Question 7h,8a,8b

Create view Gross_table as
Select category.name, sum(u.amount) as Total_Gross
from (Select t.amount, film_category.category_id
	  from (Select s.amount, inventory.film_id
			from (Select payment.amount, rental.inventory_id
				  from payment
				  inner join rental
				  on payment.rental_id = rental.rental_id) as s
			inner join inventory
			on s.inventory_id = inventory.inventory_id)as t
	  inner join film_category
	  on t.film_id = film_category.film_id) as u
inner join category
on u.category_id = category.category_id
Group by category.name
Order by Total_Gross desc;

-- Question 8c

Drop view Gross_table;

