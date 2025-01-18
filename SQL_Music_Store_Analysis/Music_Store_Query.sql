-- sql practice sets
                      /*Question Set 1 - Easy*/
-- senior most employee
select * from employee
order by levels desc
limit 1;

--- which country has most invoices?
select count(*),billing_country from invoice
group by billing_country order by 1 desc;
-- what are top 3 values of total invoice
select * from invoice
order by total desc
limit 3;

-- most sales city as we would like to promote music festival there. 
--write a query to return the city name along with sum of invoice total 
select billing_city,sum(total)  from invoice
group by billing_city
order by 2 desc

--- write a query that returns the person who spent the most and considered as Best Customer
select c.customer_id,(first_name ||' '||last_name) as customer_name, sum(total)
from customer c 
inner join invoice i
on c.customer_id=i.customer_id
group by c.customer_id, customer_name
order by 3 desc
limit 1 ;
                      /* Question Set 2 - Moderate */
 /* Write query to return the email, first name, last name, & Genre of all Rock Music
listeners. Return your list ordered alphabetically by email starting with A  */
select c.email,c.first_name,c.last_name, g.name from customer c
join invoice i on c.customer_id=i.customer_id
join invoice_line il on i.invoice_id=il.invoice_id
join track t on il.track_id=t.track_id
join genre g on t.genre_id=g.genre_id
where g.name like 'Rock';

/*Let's invite the artists who have written the most rock music in our dataset. Write a
query that returns the Artist name and total track count of the top 10 rock bands*/
select ar.name,count(g.genre_id) as track_count,ar.artist_id from track t 
join genre g on t.genre_id=g.genre_id 
join album a on t.album_id=a.album_id 
join artist ar on a.artist_id=ar.artist_id 
where g.name like 'Rock'
group by 1,3
order by 2 desc
limit 10;

/*Return all the track names that have a song length longer than the average song length.
Return the Name and Milliseconds for each track. Order by the song length with the
longest songs listed first*/
select name as track_name, milliseconds as song_length from track
where milliseconds>(select avg(milliseconds) from track)
order by song_length desc;
                
                /* Question Set 3 - Advance */
/*Find how much amount spent by each customer on top artists? Write a query to return
customer name, artist name and total spent*/

with best_selling_artist as ( select ar.artist_id, ar.name as artist_name,sum(il.unit_price*il.quantity) as total_sales from artist ar
 join album a on ar.artist_id=a.artist_id
 join track t on a.album_id=t.album_id
 join invoice_line il on t.track_id=il.track_id
 group by 1
 order by 3 desc
 limit 1)
select (first_name||' '||last_name||' '||last_name) as customer_name, bsa.artist_name, sum(il.unit_price*il.quantity) as total_amount from customer c 
join invoice i on c.customer_id=i.customer_id
join invoice_line il on i.invoice_id=il.invoice_id 
join track t on il.track_id=t.track_id
join album a on t.album_id=a.album_id
join best_selling_artist bsa on a.artist_id=bsa.artist_id
group by 1,2
order by 3 desc;

/*We want to find out the most popular music Genre for each country. We determine the
most popular genre as the genre with the highest amount of purchases. Write a query
that returns each country along with the top Genre. For countries where the maximum
number of purchases is shared return all Genres*/

with popular_genre as(
select count(il.quantity) as purchases,c.country , g.genre_id,g.name as genre_name,
row_number() over(partition by c.country order by count(il.quantity) desc) as row_no  from invoice_line il
join track t on il.track_id=t.track_id
join genre g on t.genre_id=g.genre_id
join invoice i on il.invoice_id=i.invoice_id
join customer c on i.customer_id=c.customer_id
group by 2,3,4
order by 1 desc
)
select * from popular_genre
where row_no <=1
order by 2 asc;

/*Write a query that determines the customer that has spent the most on music for each
country. Write a query that returns the country along with the top customer and how
much they spent. For countries where the top amount spent is shared, provide all
customers who spent this amount*/                

with customer_with_country as(
    select c.customer_id,c.first_name||' '||c.last_name as customer_name,i.billing_country,sum(i.total),
    row_number()over(partition by i.billing_country order by sum(i.total) desc) as row_no
    from customer c 
    join invoice i on c.customer_id=i.customer_id
    group by 1,2,3
    order by 3 asc ,4 desc
)
select * from customer_with_country
where row_no<=1
