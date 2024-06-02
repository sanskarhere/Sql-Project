create database ecommerce
use ecommerce

select* from [dbo].[olist_geolocation_dataset]
select* from [dbo].[olist_order_reviews_dataset]
select* from [dbo].[olist_orders_dataset]
select* from [dbo].[product_category_name_translation]
select* from [dbo].[olist_customers_dataset]
select* from [dbo].[olist_order_payments_dataset]
select* from [dbo].[olist_order_items_dataset]
select* from [dbo].[olist_sellers_dataset]

-- provide supply chain

select product_category_name,price,seller_state ,seller_city,customer_state ,customer_city, order_status from [dbo].[olist_products_dataset] x 
inner join [dbo].[olist_order_items_dataset] y on x.product_id = y.product_id  inner join 
[dbo].[olist_sellers_dataset] a  on  y.seller_id = a.seller_id inner join  [dbo].[olist_geolocation_dataset] b on a.seller_zip_code_prefix = b.geolocation_zip_code_prefix 
left join  [dbo].[olist_customers_dataset]  c on  c.customer_zip_code_prefix  = b.geolocation_zip_code_prefix 
inner join [dbo].[olist_orders_dataset] d on d.customer_id = c.customer_id 

--this query will  provide supply chain that will help marketing team

-- Q Sales team needs your help in working with the vendor and coming up with good offers to sell their products on Flipkart.

select seller_state ,seller_city , seller_zip_code_prefix , review_score , product_id  from [dbo].[olist_sellers_dataset] a inner join [olist_order_items_dataset] b  on a.seller_id = b.seller_id 
inner join [dbo].[olist_order_reviews_dataset] c on c.order_id = b.order_id  
where review_score > (select avg(review_score) from [dbo].[olist_order_reviews_dataset] )
        
--we get highly rated vendor details through this and collborating with highly rated vendors to negotiate better deals and offers will be good

--  Q Marketing team needs your help in making their launch offer in more customized manner.

select c.customer_city, c.customer_state, count(o.customer_id) as order_count from [dbo].[olist_orders_dataset] o JOIN
[olist_customers_dataset] c on o.customer_id = c.customer_id group by c.customer_city, c.customer_state order by order_count desc;

--this query will provide insights into which cities and states have the highest order , allowing the marketing team to make their launch offer accordingly. 

-- Q Identify common customer issues like return,order tracking issue 

select review_id, review_score,  review_comment_title, review_comment_message from [olist_order_reviews_dataset]
where review_score < 3 AND (review_comment_title LIKE '%retornar%' OR review_comment_message LIKE '%retornar%');


select c.customer_unique_id, count(distinct o.order_id) AS total_orders from [dbo].[olist_orders_dataset] o JOIN 
[olist_customers_dataset] c on o.customer_id = c.customer_id group by c.customer_unique_id having count(distinct o.order_id) > 1;

--This query provides a list of customers who have placed multiple orders, which can be further analyzed to identify any patterns related to order tracking issues bcoz due to tacking issue customer may order a same product twice 


-- Q Explore seasonal trends  by analyzing order timestamps.

select  datepart(year, order_purchase_timestamp) as order_year, datepart(month, order_purchase_timestamp) as order_month,count(order_id) 
as total_orders from [dbo].[olist_orders_dataset] group by datepart(year, order_purchase_timestamp), datepart(Month, order_purchase_timestamp)
order by order_year, order_month;

--this query will aggreagate order by month 



select  datepart(year, order_purchase_timestamp) as order_year, datepart(month, order_purchase_timestamp) as order_month,count(order_id) 
as total_orders from [dbo].[olist_orders_dataset] group by datepart(year, order_purchase_timestamp), datepart(Month, order_purchase_timestamp)
order by order_year, order_month;



