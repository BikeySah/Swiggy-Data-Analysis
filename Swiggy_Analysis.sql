create database Swiggy;
Use Swiggy
select * from swiggy_data
sp_help swiggy_data
EXEC sp_rename 'swiggy_data.[State]', 'state', 'COLUMN';
EXEC sp_rename 'swiggy_data.[City]', 'city', 'COLUMN';
EXEC sp_rename 'swiggy_data.[Order Date]', 'order_date', 'COLUMN';
EXEC sp_rename 'swiggy_data.[Restaurant Name]', 'restaurant_name', 'COLUMN';
EXEC sp_rename 'swiggy_data.[Location]', 'location', 'COLUMN';
EXEC sp_rename 'swiggy_data.[Category]', 'category', 'COLUMN';
EXEC sp_rename 'swiggy_data.[Dish Name]', 'dish_name', 'COLUMN';
EXEC sp_rename 'swiggy_data.[Price (INR)]', 'price_inr', 'COLUMN';
EXEC sp_rename 'swiggy_data.[Rating]', 'rating', 'COLUMN';
EXEC sp_rename 'swiggy_data.[Rating Count]', 'rating_count', 'COLUMN';
---Data Validation & Cleaning
-- Null Checks
SELECT
    Sum(CASE WHEN state IS NULL THEN 1 ELSE 0 END) AS null_state,
    Sum(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS null_city,
    Sum(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS null_date,
    Sum(CASE WHEN Location IS NULL THEN 1 ELSE 0 END) AS null_location,
    Sum(CASE WHEN Category IS NULL THEN 1 ELSE 0 END) AS null_category,
    Sum(CASE WHEN dish_name IS NULL THEN 1 ELSE 0 END) AS null_dish_name,
    Sum(CASE WHEN price_inr IS NULL THEN 1 ELSE 0 END) AS null_price,
    Sum(CASE WHEN Rating IS NULL THEN 1 ELSE 0 END) AS null_rating,
    Sum(CASE WHEN rating_count IS NULL THEN 1 ELSE 0 END) AS null_rating_count
FROM swiggy_data;
---Blank or Empty Strings
Select * from swiggy_data where state='' or restaurant_name='' or city=''
 or location='' or category='' or dish_name=''

 --- duplicate detection
 select state, city, order_date, restaurant_name,location,
  category, dish_name, price_inr, rating, 
  rating_count, count(*) as CNT from swiggy_data 
  group by  state, city, order_date, restaurant_name,location,
  category, dish_name, price_inr, rating, 
  rating_count
  having count(*)>1;
  WITH CTE AS 
 ( 
 select *, ROW_NUMBER() over( Partition by state, city, order_date, restaurant_name,location,
  category, dish_name, price_inr, rating, 
  rating_count order by (Select Null) 
  )as rn from swiggy_data
   )
  delete from cte where rn>1
  ---Creating Schema
  ---Dimenison table
  ----Date Table
  create Table dim_date ( 
  date_id INT Identity (1,1) primary key,
  Full_Date date,
  Year int, 
  Month int,
  Month_name varchar(25),
  Quarter int,
  Day int,
  week int)
  select * from dim_date;
  --dim location
  create table dim_location (
  location_id int identity (1,1) Primary key,
  state varchar(100),
  city varchar(100),
  Location Varchar(200)
  );

  --- dim _restaurant
  create table dim_restaurant (
  restaurant_id int identity (1,1) Primary key,
  restaurant_name varchar(200)
  );

  ---dim_category
  create table dim_category (
  category_id int identity (1,1) Primary key,
  category varchar(250)
  );

 --- dim_dish
  create table dim_dish (
  Dish_id int identity (1,1) Primary key,
  Dish_name varchar(250)
  );

  select * from swiggy_data

  ---fact table
CREATE TABLE fact_swiggy_orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,

    date_id INT,
    Price_INR DECIMAL(10,2),
    Rating DECIMAL(4,2),
    Rating_Count INT,

    location_id INT,
    restaurant_id INT,
    category_id INT,
    dish_id INT,

    FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (location_id) REFERENCES dim_location(location_id),
    FOREIGN KEY (restaurant_id) REFERENCES dim_restaurant(restaurant_id),
    FOREIGN KEY (category_id) REFERENCES dim_category(category_id),
    FOREIGN KEY (dish_id) REFERENCES dim_dish(dish_id)
);

insert into dim_date (Full_Date, Year, Month,Month_name,Quarter,Day,week) 
select Distinct 
Order_date,
YEAR(order_date),
Month(order_date),
DATENAME(Month,order_date),
DATEPART(Quarter, order_date),
DAY(order_date),
DATEPART(Week, order_date)
from swiggy_data where order_date is not null;

select * from dim_date

--- dim_location 
insert into dim_location(state,city,Location)
select Distinct 
state,
city,
location
from swiggy_data
select * from dim_location

--- dim restaurant 
insert into dim_restaurant(restaurant_name)
select distinct restaurant_name from swiggy_data
select * from dim_location

--- dim category
insert into dim_category(category)
select distinct category from swiggy_data
select * from dim_category

--- dim dish
insert into dim_dish(Dish_name)
select distinct dish_name from swiggy_data
select * from dim_dish

--- fact table
INSERT INTO fact_swiggy_orders
(
    date_id,
    price_inr,
    rating,
    rating_count,
    location_id,
    category_id,
    dish_id,
    restaurant_id
)
SELECT 
    dd.date_id,
    s.price_inr,
    s.rating,
    s.rating_count,
    dl.location_id,
    dc.category_id,
    dsh.dish_id,
    dr.restaurant_id
FROM swiggy_data AS s
JOIN dim_date AS dd 
    ON dd.full_date = s.order_date
JOIN dim_location AS dl 
    ON dl.state = s.state
   AND dl.city = s.city
   AND dl.location = s.location
JOIN dim_restaurant AS dr 
    ON dr.restaurant_name = s.restaurant_name
JOIN dim_category AS dc 
    ON dc.category = s.category
JOIN dim_dish AS dsh 
    ON dsh.dish_name = s.dish_name;
select * from fact_swiggy_orders
select * from swiggy_data
--- joining tables

select * from fact_swiggy_orders as f
join dim_date as d on f.date_id=d.date_id
join dim_location as l on f.location_id=l.location_id
join dim_restaurant as r on f.restaurant_id=r.restaurant_id
join dim_category as c on f.category_id=c.category_id
join dim_dish di on f.dish_id=di.Dish_id

--- KPIS
---Total_orders
select  count(*) as Total_orders from fact_swiggy_orders

---- Total Revenue
select 
format(sum(convert(Float,price_inr))/1000000,'N2')+'INR_million' as 
Total_revenue from fact_swiggy_orders;
--- average order price
select 
format(avg(convert(Float,price_inr)),'N2')+'INR' as 
avg_order_value from fact_swiggy_orders;

---- average rating
select avg(rating) as average_rating from fact_swiggy_orders;

---- Deep Drive Business Analysis
--- Monthly Order Trends
Select  
d.year, 
d.month,
d.month_name,
count(*) as total_orders
from fact_swiggy_orders as f
join dim_date as d on f.date_id=d.date_id
group by d.year,d.month, d.Month_name
order by count(*) desc

---monthly trend total revenue
Select  
d.year, 
d.month,
d.month_name,
sum(Price_INR) as total_revenue
from fact_swiggy_orders as f
join dim_date as d on f.date_id=d.date_id
group by d.year,d.month, d.Month_name
order by total_revenue desc


---Quaterly Trend
Select  
d.year, 
d.Quarter,
Count(*) as total_orders
from fact_swiggy_orders as f
join dim_date as d on f.date_id=d.date_id
group by d.year,d.Quarter
order by total_orders desc

--- Yearly Trends
Select
d.year, 
Count(*) as total_orders
from fact_swiggy_orders as f
join dim_date as d on f.date_id=d.date_id
group by d.year
order by total_orders desc

---orders by day of week (Mon-Sun)
select
DATENAME(weekday, d.full_date) As day_name,
count(*) as total_orders 
from fact_swiggy_orders as f
join dim_date as d on f.date_id=d.date_id
group by DATENAME(weekday,d.full_date), DATEPART(Weekday,d.full_date)
order by DATEPART(weekday,d.full_date);

--- Top 10 cities by high order volume
select top 10 
l.city,
count(*) as total_orders from fact_swiggy_orders as f
join dim_location as l on
l.location_id=f.location_id
group by l.city 
order by total_orders desc;


--- Top 10 cities by Total revenue
select top 10 
l.city,
sum(Price_INR) as total_revenue from fact_swiggy_orders as f
join dim_location as l on
l.location_id=f.location_id
group by l.city 
order by total_revenue desc;

---Revenue Contribution by state
select 
l.state,
sum(Price_INR) as total_revenue from fact_swiggy_orders as f
join dim_location as l on
l.location_id=f.location_id
group by l.state 
order by total_revenue desc;

--- Top 10 Restaurants by Orders
select top 10
r.restaurant_name,
sum(f.Price_INR) as total_revenue from fact_swiggy_orders as f
join dim_restaurant as r on r.restaurant_id=f.restaurant_id
group by r.restaurant_name
order by total_revenue desc;

---Top categories by order volume
select c.category,count(*) as total_orders
from fact_swiggy_orders as f join
dim_category as c on f.category_id=c.category_id
group by c.category order by total_orders desc;


--- Most Ordered Dish
select d.dish_name,count(*) as order_count
from fact_swiggy_orders as f join
dim_dish as d on f.dish_id=d.Dish_id
group by d.Dish_name order by order_count desc;


--- Cusine Performance (Orders + Avg rating)
select c.category, count(*) as total_orders,
avg(convert(Float,f.rating)) as avg_rating
from fact_swiggy_orders as f
Join dim_category as c on f.category_id=c.category_id
group by c.category
order by total_orders desc;


-- Total Orders by Price Range

SELECT
    CASE
        WHEN CONVERT(FLOAT, price_inr) < 100 THEN 'Under 100'
        WHEN CONVERT(FLOAT, price_inr) BETWEEN 100 AND 199 THEN '100 - 199'
        WHEN CONVERT(FLOAT, price_inr) BETWEEN 200 AND 299 THEN '200 - 299'
        WHEN CONVERT(FLOAT, price_inr) BETWEEN 300 AND 499 THEN '300 - 499'
        ELSE '500+'
    END AS price_range,
    COUNT(*) AS total_orders
FROM fact_swiggy_orders
GROUP BY
    CASE
        WHEN CONVERT(FLOAT, price_inr) < 100 THEN 'Under 100'
        WHEN CONVERT(FLOAT, price_inr) BETWEEN 100 AND 199 THEN '100 - 199'
        WHEN CONVERT(FLOAT, price_inr) BETWEEN 200 AND 299 THEN '200 - 299'
        WHEN CONVERT(FLOAT, price_inr) BETWEEN 300 AND 499 THEN '300 - 499'
        ELSE '500+'
    END
ORDER BY total_orders DESC;

--- Rating Count Distribution
Select rating, count(*) as rating_count from 
fact_swiggy_orders group by Rating
order by Rating_count desc