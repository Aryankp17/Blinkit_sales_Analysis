#Get Total Orders per Day
create view Get_Total_Orders_per_Day as
select Day,count(order_id) as total_order from sales.orders group by Day order by total_order desc;

#Find Customers Who Ordered More Than multiple Times
create view customers_Ordered_multiple_Times as 
select customer_id,count(order_id) as order_count from sales.orders group by customer_id having order_count >1;

#Find the Most Popular Payment Method
create view Most_Popular_Payment_Method as
select payment_method,count(order_id) as payment from sales.orders group by payment_method order by payment desc;

#Join Order and Order Items to Find High-Value Orders
create view High_Value_Orders as
select sales.orders.order_id,sales.orders.customer_id,sum(sales.order_items.revenue) as revenue from sales.orders
join sales.order_items on sales.orders.order_id = sales.order_items.order_id
group by sales.orders.order_id,sales.orders.customer_id
order by revenue desc;

#Identify Delayed Deliveries
create view Identify_Delayed_Deliveries as 
select delivery_status,count(order_id) as total_order,sum(order_total) as order_value from sales.orders
group by delivery_status;

#Find Top 5 Best-Selling Products
create view Find_Top_5_Best_Selling_Products as
select sales.product.product_name,sum(sales.order_items.quantity) as total_product from sales.product join sales.order_items
on sales.product.product_id = sales.order_items.product_id
group by sales.product.product_name
order by total_product desc limit 5;

#Check Inventory Status for Products in Orders
create view Inventory_Status_for_Products as 
select sales.product.product_name,sum(sales.inventory.usable_stock) as usable_stock ,sum(sales.order_items.quantity) as order_quantity
 from sales.product cross join sales.order_items on sales.product.product_id = sales.order_items.product_id
 cross join sales.inventory on order_items.product_id = inventory.product_id
 group by product.product_name,inventory.usable_stock
 having sum(inventory.usable_stock) > sum(order_items.quantity)
 order by usable_stock asc;
 
 #Find Products with Highest Profit Margins
 create view Products_with_Highest_Profit_Margins as 
 select product_name,margin_percentage from sales.product order by margin_percentage desc ;
 
 
 #Find Customers Who Ordered Across Multiple Categories
 create view Customers_Ordered_Multiple_Categories as
 select sales.orders.customer_id,count(distinct sales.product.category ) as multiple_category from sales.product
 join sales.order_items on product.product_id = order_items.product_id
 join sales.orders on order_items.order_id = orders.order_id
 group by customer_id
 having multiple_category >1
 order by multiple_category desc;

#Total Revenue by Category
create view Total_Revenue_by_category as
select sales.product.category,sum(sales.order_items.revenue) as total_revenue from sales.order_items join
sales.product on sales.order_items.product_id = sales.product.product_id
group by sales.product.category order by total_revenue desc ;
 