USE [Sales Analyses]

select * 
from fact_events

select distinct promo_type
from fact_events

-- Adding a column named sale_before_promo and adding values to it.
ALTER TABLE fact_events
ADD sale_before_promo INT;

ALTER TABLE fact_events
ALTER COLUMN base_price INT;

UPDATE fact_events
SET sale_before_promo = quantity_sold_before_promo * base_price;

-- Adding a column named sale_after_promo and adding values to it.
ALTER TABLE fact_events
ADD sale_after_promo INT;

UPDATE fact_events
SET sale_after_promo = quantity_sold_after_promo * base_price;

select * 
from fact_events

-- Adding column named promo-price and assigned appropriate values to it.

ALTER TABLE fact_events
ADD promo_price INT;

select distinct promo_type
from fact_events 


UPDATE fact_events
set promo_price = 
	CASE 
		when promo_type = '50% OFF' THEN base_price * 0.50
		when promo_type = '25% OFF' THEN base_price * 0.75
		when promo_type = '33% OFF' THEN base_price * 0.67
		when promo_type = 'BOGOF' THEN base_price * 0.50
		when promo_type = '500 Cashback' THEN [base_price] - 500
		ELSE base_price
	END;

select event_id,base_price,promo_type,promo_price,
from fact_events

select *
from fact_events



---------------------------------------------------- Store Perfromance Analysis---------------------------------------------------------------


--Question 1 : Which are the top 10 stores in terms of incremental Revenue(IR) generated from the promotions?

-- Adding a column named : IR(Incremental Revenue)
ALTER TABLE fact_events
ADD IncrementalRevenue INT;

UPDATE fact_events
set incremental_revenue = [sale_after_promo] - [sale_before_promo]

select TOP 10 dim_stores.store_id,dim_stores.city, SUM(incremental_revenue) AS IncrementalRevenueLakhs
from fact_events
join dim_stores
on fact_events.store_id = dim_stores.store_id
group by dim_stores.store_id,dim_stores.city
ORDER BY IncrementalRevenueLakhs DESC


-- Question 2 : Which are bottom 10 Stores when it comes to  Incremental Sold Units(ISU) during the promotional period

ALTER TABLE fact_events
ADD IncrementalSoldUnits INT;


UPDATE fact_events
set IncrementalSoldUnits = quantity_sold_after_promo - quantity_sold_before_promo


select TOP 10 dim_stores.store_id,dim_stores.city, SUM(IncrementalSoldUnits) AS IncrementalSoldUnits
from fact_events
join dim_stores
on fact_events.store_id = dim_stores.store_id
group by dim_stores.store_id,dim_stores.city
ORDER BY IncrementalSoldUnits ASC

-- Question 3: how does the perfromance of stores vary by city? Are there any common characteristics among the top - performaing stores that could be leveraged across others stores?

select dim_stores.city,sum(sale_before_promo) AS SaleBeforePromo, sum(sale_after_promo) AS SaleAfterPromo
from fact_events
join dim_stores
on fact_events.store_id = dim_stores.store_id
group by dim_stores.city

select * 
from dim_products

select *
from fact_events

select * 
from dim_campaigns

select *
from dim_stores

-- Adhoc Request 1:  Provide a list of products with a base price greater than 500 and that are featured in promo type of 'BOGOF' (Buy One Get One Free). This information will help us identify high-value products that are currently being heavily discounted, which can be useful for evaluating our pricing and promotion strategies.

select fact_events.campaign_id,dim_campaigns.campaign_name,fact_events.product_code,dim_products.product_name,sum(quantity_sold_after_promo) as qtysold_after_promo
from fact_events
join dim_products 
on fact_events.product_code = dim_products.product_code
join dim_campaigns
on fact_events.campaign_id = dim_campaigns.campaign_id
where fact_events.base_price >= 500 and fact_events.promo_type = 'BOGOF'
group by fact_events.campaign_id,dim_campaigns.campaign_name,fact_events.product_code,dim_products.product_name

-- Adhoc Request 2: Generate a report that provides an overview of the number of stores in each city. The results will be sorted in descending order of store counts, allowing us to identify the cities with the highest store presence. The report includes two essential fields: city and store count, which will assist in optimizing our retail operations.

select city, COUNT(city) AS Stores
from dim_stores
group by city


-- Adhoc Request 3: Generate a report that displays each campaign along with the total revenue generated before and after the campaign? The report includes three key fields: campaign _name, total revenue(before_promotion), total revenue(after_promotion). This report should help in evaluating the financial impact of our promotional campaigns. (Display the values in millions)

select fact_events.campaign_id,campaign_name,sum(sale_before_promo)/1000000 as sale_beofre_promo_in_millions, sum(sale_after_promo)/1000000 as sale_after_promo_in_millions
from fact_events
join dim_campaigns
on fact_events.campaign_id = dim_campaigns.campaign_id
group by fact_events.campaign_id, campaign_name


-- Adhoc Request 4: Produce a report that calculates the Incremental Sold Quantity (ISU%) for each category during the Diwali campaign. Additionally, provide rankings for the categories based on their ISU%. The report will include three key fields: category, isu%, and rank order. This information will assist in assessing the category-wise success and impact of the Diwali campaign on incremental sales.
---Note: ISU% (Incremental Sold Quantity Percentage) is calculated as the percentage increase/decrease in quantity sold (after promo) compared to quantity sold (before promo)


ALTER TABLE fact_events
ALTER COLUMN IncrementalSoldUnits FLOAT;


select dim_products.category,ROUND( 100 *sum(IncrementalSoldUnits) / sum(quantity_sold_before_promo),2) AS 'isu%',
RANK() OVER (ORDER BY ROUND(100 * SUM(IncrementalSoldUnits) / SUM(quantity_sold_before_promo), 2) DESC) AS isu_rank
from fact_events
join dim_products
on fact_events.product_code = dim_products.product_code
where campaign_id = 'CAMP_DIW_01'
group by dim_products.category
order by 'isu%' DESC

-- Adhoc Request 5: Create a report featuring the Top 5 products, ranked by Incremental Revenue Percentage (IR%), across all campaigns. The report will provide essential information including product name, category, and ir%. This analysis helps identify the most successful products in terms of incremental revenue across our campaigns, assisting in product optimization. 

SELECT top 5 fact_events.product_code, dim_products.product_name, SUM(fact_events.incremental_revenue) as Total_Sales,
RANK () OVER (ORDER BY SUM(fact_events.incremental_revenue) DESC) AS Ir_Rank
FROM fact_events
JOIN dim_products ON fact_events.product_code = dim_products.product_code
GROUP BY fact_events.product_code, dim_products.product_name;









