### I answer some targeted business questions from across the team

# Q1: What is the total number of Macbooks sold and total sales for each quarter in North America?  

SELECT 
    CONCAT(YEAR(o.purchase_date),'-Q',QUARTER(o.purchase_date)) AS quarter,
    COUNT(o.id) AS order_count,
    ROUND(SUM(o.usd_price),2) AS total_sales
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.id
LEFT JOIN geo_lookup g
ON c.country_code = g.country
WHERE o.product_name LIKE '%macbook%' 
    AND g.region = 'NA'
GROUP BY quarter
ORDER BY quarter
;

#Q2: Which region has the average highest time to deliver for website purchases made in 2022? 

SELECT 
    g.region, 
    ROUND(AVG(os.days_to_delivery),2) AS avg_days_to_delivery
FROM orders o
LEFT JOIN order_status os
ON o.id = os.order_id
LEFT JOIN customers c
ON o.customer_id = c.id
LEFT JOIN geo_lookup g
ON c.country_code = g.country
WHERE o.purchase_platform = 'website' AND YEAR(o.purchase_date) = 2022 AND g.region IS NOT NULL
GROUP BY g.region
ORDER BY avg_days_to_delivery DESC
LIMIT 1
;

#Q3: What was the refund rate and refund count for each product per year?

SELECT 
    o.product_name,
    YEAR(o.purchase_date) AS purchase_year,
    SUM(CASE WHEN os.refund_date IS NOT NULL THEN 1 ELSE 0 END) AS refund_count,
    ROUND(SUM(CASE WHEN os.refund_date IS NOT NULL THEN 1 ELSE 0 END)/COUNT(o.id) * 100, 2) AS refund_rate_percentage
FROM orders o
LEFT JOIN order_status os
ON o.id = os.order_id
GROUP BY o.product_name, purchase_year
ORDER BY o.product_name
;

#Q4: Within each region, what is the most popular product? 

WITH orders_by_product_by_region AS (
SELECT 
    g.region, 
    o.product_name, 
    COUNT(o.id) AS order_count
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.id
LEFT JOIN geo_lookup g
ON c.country_code = g.country
WHERE region IS NOT NULL
GROUP BY g.region, o.product_name
)
SELECT *
FROM (
    SELECT 
        *, 
        RANK() OVER (PARTITION BY region ORDER BY order_count DESC) AS ranking
    FROM orders_by_product_by_region
    ) AS ranked
WHERE ranking = 1
;

# Q5: How does the time to make a purchase differ between loyalty customers vs. non-loyalty customers, per purchase plaftorm? 

-- time to make a purchase = created_on - purchased_date
-- loyalty_program: member (1), non-members (0)

SELECT 
    o.purchase_platform, 
    c.loyalty_program, 
    ROUND(AVG(DATEDIFF(o.purchase_date, c.created_on)),1) AS avg_days_to_purchase
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.id
WHERE c.loyalty_program IS NOT NULL
GROUP BY o.purchase_platform, c.loyalty_program
;

#Q6: What is the median order value for each purchase platform? 

WITH median AS (
SELECT 
    usd_price,
    purchase_platform,
    ROW_NUMBER() OVER (PARTITION BY purchase_platform ORDER BY usd_price ASC) AS rn,
    COUNT(*) OVER (PARTITION BY purchase_platform) AS cnt
FROM orders
WHERE usd_price IS NOT NULL
)

SELECT 
    purchase_platform,
    ROUND(AVG(usd_price),2) AS median_order_value
FROM median
WHERE rn = FLOOR((cnt + 1)/2) OR rn = CEIL((cnt + 1)/2)
GROUP BY purchase_platform
;

SELECT COUNT(refund_date)
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.id
;
