USE [Pizza Store Sales Analysis]

-- Pizza Store Sales Analysis AdHoc Queries
------------------------------------
-- Data Transformation and Data Cleaning
------------------------------------

-- Convert time to hour only [e.g., 11:38:36:000000 >>>>> 12]
ALTER TABLE orders
ADD hourOfOrder AS (
    CASE 
        WHEN DATEPART(MINUTE, [time]) > 30 THEN DATEPART(HOUR, [time]) + 1
        ELSE DATEPART(HOUR, [time])
    END
);

-- Add columns for financial week number, weekday, and month
ALTER TABLE orders
ADD financial_week_number INT,
    weekday VARCHAR(9), -- Assuming weekday names like "Monday", "Tuesday", etc.
    order_month VARCHAR(20); -- Assuming month names like "January", "February", etc.

-- Update financial week number
UPDATE orders
SET financial_week_number = DATEDIFF(WEEK, '2015-01-01', [date]) + 1;

-- Update weekday
UPDATE orders
SET weekday = DATENAME(WEEKDAY, [date]);

-- Update month
UPDATE orders
SET order_month = DATENAME(MONTH, [date]);

-- Renamed some columns from 
-- order_month to month 
-- financial_week_number to Fin_Week


-- Add column for sale amount
ALTER TABLE order_details
ADD sale DECIMAL(10, 2); -- Assuming the sale amount will be in decimal format

-- Update sale amount based on quantity and price
UPDATE od
SET od.sale = od.quantity * p.price
FROM order_details od
INNER JOIN pizzas p ON od.pizza_id = p.pizza_id;


select *
from order_details

----------------------------------
-------Extracted Insights
----------------------------------

-- Each kind of pizza and its yearly sale.
SELECT Pzt.name, SUM(Od.quantity * Pz.price) AS Sale
FROM order_details Od
JOIN pizzas Pz ON Od.pizza_id = Pz.pizza_id
JOIN pizza_types Pzt ON Pz.pizza_type_id = Pzt.pizza_type_id
GROUP BY Pzt.name
ORDER BY Sale DESC;

-- Each kind of pizza and its total sold quantity
SELECT Pzt.name, SUM(Od.quantity) AS SoldQuantity
FROM order_details Od
JOIN pizzas Pz ON Od.pizza_id = Pz.pizza_id
JOIN pizza_types Pzt ON Pz.pizza_type_id = Pzt.pizza_type_id
GROUP BY Pzt.name
ORDER BY SoldQuantity DESC;


-- Pizza Size and Sold Quantity
SELECT Pz.size, SUM(Od.quantity) AS SoldQuantity, cast(SUM(Od.sale)as int) AS Sale, cast((SUM(Od.sale)/SUM(oD.quantity)) as int) as AverageSalePerPizza
FROM order_details Od
JOIN pizzas Pz ON Od.pizza_id = Pz.pizza_id
GROUP BY Pz.size


-- Total sold pizza - Month [Jan,Feb,March etc.]
SELECT Ods.month, SUM(quantity) as SoldPizzas
FROM order_details Od
JOIN orders Ods ON Od.order_id = Ods.order_id
GROUP BY Ods.month
order by SoldPizzas DESC


-- Total sold pizza - weekday [Mon, Tues, Wed etc.] 
SELECT Ods.weekday, SUM(quantity) as SoldPizzas
FROM order_details Od
JOIN orders Ods ON Od.order_id = Ods.order_id
GROUP BY Ods.weekday
order by SoldPizzas DESC


-- Total sold pizza - financial week[Financial weeek begins from january 01 2015 ]
SELECT Ods.fin_week, SUM(quantity) as SoldPizzas
FROM order_details Od
JOIN orders Ods ON Od.order_id = Ods.order_id
GROUP BY Ods.fin_week
order by SoldPizzas DESC


-- Total sold pizza - hous of day[Time : 11, 12 0' Clock etc.]
SELECT Ods.hourOfOrder, SUM(quantity) as SoldPizzas
FROM order_details Od
JOIN orders Ods ON Od.order_id = Ods.order_id
GROUP BY Ods.hourOfOrder
order by SoldPizzas DESC


-- Total sold Pizzas - Day [Day of the Month, Like 1,2,3,4,5....31]
SELECT DAY(Ods.date) AS DayOfMonth, SUM(quantity) as SoldPizzas
FROM order_details Od
JOIN orders Ods ON Od.order_id = Ods.order_id
GROUP BY DAY(Ods.date)
ORDER BY SoldPizzas;
