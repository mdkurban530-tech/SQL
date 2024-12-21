-- Subquery Example
select film_id,title,rental_count from 
 (select f.film_id,f.title,count(r.rental_id) as rental_count from film f
  join inventory i 
  on f.film_id=i.film_id
  join rental r
  on i.inventory_id=r.inventory_id
  group by f.film_id,f.title) as film_rentals
  where rental_count>30


-- CTE Example
with cte as ( select f.film_id,f.title,count(r.rental_id) as rental_count from film f
  join inventory i 
  on f.film_id=i.film_id
  join rental r
  on i.inventory_id=r.inventory_id
  group by f.film_id,f.title)
  select film_id,title,rental_count from cte
    where rental_count>30