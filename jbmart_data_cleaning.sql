/* I use a C-L-E-A-N framework

C for Conceptualize
- Identify the grain, understand the definition of each measure and dimension
- Identy critical vs. non-critical columns, the goal is to have usable critical columns, then move forward with the analysis,
don't stuck at data cleaning phase, it's an iterative process
* C for Copy too, keep a copy of raw data, do not overwrite the raw data

L for Locate solvable issue
- Duplicates 
- Formatting - number(commonly currency sign), date, wrong datatype
- Consistency - spelling, spacing

E for Evaluate unsolvable issue
- Empty strings, nulls, missing data
- Non-sensical data eg. refund date before sale or region code that doesn't exist
* Evaluate the % of data impacted
- If >70% of records are unsolvable issues, the column is unusable
- If <10% of records are unsolvable issues, can likely keep the data as is
- If in the middle, make a judgement depending on how critical the column is. 

A for Augment
- Create additional calculated fields 
eg. days_to_ship (calculate from the difference between purchase_date and ship_date)
- Add supplementary info from another source 
eg. add region to better understand the data at another geographic dimension

Note and documentation
- Create a changelog 
issue_id, description, type, resolved, notes are logged in an excel file
*/ 



###1 Conceptualize

##1a Copy the raw 

CREATE DATABASE jbmart_raw;

CREATE TABLE jbmart_raw.orders_raw LIKE jbmart.orders;
INSERT INTO jbmart_raw.orders_raw SELECT * FROM jbmart.orders;

CREATE TABLE jbmart_raw.customers_raw LIKE jbmart.customers;
INSERT INTO jbmart_raw.customers_raw SELECT * FROM jbmart.customers;

CREATE TABLE jbmart_raw.order_status_raw LIKE jbmart.order_status;
INSERT INTO jbmart_raw.order_status_raw SELECT * FROM jbmart.order_status;

CREATE TABLE jbmart_raw.geo_lookup_raw LIKE jbmart.geo_lookup;
INSERT INTO jbmart_raw.geo_lookup_raw SELECT * FROM jbmart.geo_lookup;
-- Created a raw copy of database and tables


##1b Identify the grain, critical vs. non-critical measures & dimensions

SELECT *
FROM orders
;
-- Each row represents an order. 
-- currency, local_price are not critical for this analysis.
-- Logged issue_1, purchase_ts is date, not a timestamp

ALTER TABLE orders RENAME COLUMN purchase_ts TO purchase_date;
-- Successfully rename to avoid confusion. 


SELECT COUNT(*)
FROM orders
;
-- There are 78846 orders rows.

SELECT *
FROM customers
;
-- Each row represents a customer. 

SELECT COUNT(*)
FROM customers
;
-- There are 74904 customer rows. Sounds reasonable as each customer can purchase multiple orders.

SELECT *
FROM geo_lookup
;
-- Reference table to map country to region. 

SELECT *
FROM order_status
;
-- Each row represents an order with status dates. 
-- Logged issue_2/3/4/5, purchase_ts, ship_ts, delivery_ts and refund_ts columns are dates, not a timestamp

ALTER TABLE order_status RENAME COLUMN purchase_ts TO purchase_date;
ALTER TABLE order_status RENAME COLUMN ship_ts TO ship_date;
ALTER TABLE order_status RENAME COLUMN delivery_ts TO delivery_date;
ALTER TABLE order_status RENAME COLUMN refund_ts TO refund_date;
-- Successfully rename to avoid confusion. 


SELECT COUNT(*)
FROM order_status
;
-- There are 108127 rows, way more than the 78846 orders table rows. I wonder if there are duplicates? 



###2 Locate solvable issue

##2a Duplication check

SELECT 
    orders.id, 
    COUNT(orders.id)
FROM orders
GROUP BY orders.id
HAVING COUNT(orders.id) > 1
;
-- No duplicates found

SELECT 
    customers.id, 
    COUNT(customers.id)
FROM customers
GROUP BY customers.id
HAVING COUNT(customers.id) > 1
;
-- No duplicates found

SELECT 
    order_status.order_id, 
    COUNT(order_status.order_id)
FROM order_status
GROUP BY order_status.order_id
HAVING COUNT(order_status.order_id) > 1
;
-- Logged issue_6, 14081 duplicates found with some duplicate twice or thrice

WITH duplicates AS
(
SELECT
    order_id,
    ROW_NUMBER() OVER (PARTITION BY order_id) AS row_num
FROM order_status
)

DELETE FROM order_status
WHERE order_id IN (
    SELECT order_id
    FROM duplicates
    WHERE row_num > 1
);

SELECT COUNT(*)
FROM order_status
;
-- Successfully de-duplicate, before is 108127 rows, after de-duplication is 78849 rows. 
-- Now order table has 78846 rows, order_status table has 78849 rows, almost 1-to-1 map.



##2b Datatype, number and date formatting check

DESCRIBE orders
;
SELECT *
FROM orders
;
-- Logged issue_7/8, purchase_date & usd_price have wrong datatype

# Modify purchase_date datatype from TEXT to DATE

ALTER TABLE orders ADD COLUMN purchase_date_new DATE;
UPDATE orders SET purchase_date_new = STR_TO_DATE(purchase_ts, '%m/%d/%y');
ALTER TABLE orders DROP COLUMN purchase_date;
ALTER TABLE orders RENAME COLUMN purchase_date_new TO purchase_date;
-- create a new column with DATE datatype, then update the new column with correct date format
-- drop the old column and rename the new column
-- successfully ended up with DATE datatype for purchase_date

# Modify usd_price datatype from TEXT to FLOAT

ALTER TABLE orders MODIFY COLUMN usd_price float;
-- not succesful, unable to modify usd_price datatype to float because it contains blank

UPDATE orders SET usd_price = NULL WHERE usd_price = ''; 
ALTER TABLE orders MODIFY COLUMN usd_price float;
-- update blank to NULL
-- successfully modify usd_price datatype


DESCRIBE customers
;
SELECT *
FROM customers
;
-- logged issue_9, created_on has wrong datatype

# Modify created_on datatype from TEXT to DATE

ALTER TABLE customers ADD COLUMN created_on_new DATE;
UPDATE customers SET created_on_new = STR_TO_DATE(created_on, '%m/%d/%y');
ALTER TABLE customers DROP COLUMN created_on;
ALTER TABLE customers RENAME COLUMN created_on_new TO created_on;
-- create a new column with DATE datatype, then update the new column with correct date format
-- drop the old column and rename the new column
-- successfully ended up with DATE datatype for created_on

DESCRIBE order_status
;
SELECT *
FROM order_status_jbmart
;
-- No datatype, number or date formatting issues found. 

DESCRIBE geo_lookup
;
SELECT *
FROM geo_lookup
;
-- No datatype, number or date formatting issues found. 


##2c Consistency check - spelling, spacing

SELECT DISTINCT product_name
FROM orders
ORDER BY 1
;
-- Logged issue_10, error in product_name - 27""" and 27in 4K gaming monitor


UPDATE orders 
SET product_name = '27in 4K gaming monitor' 
WHERE product_name LIKE '%27in%'
;
-- Successfully fix the inconsistent product_name issue

UPDATE orders
SET product_name = 

SELECT DISTINCT purchase_platform
FROM orders
ORDER BY 1
;
-- No inconsistency issues.

SELECT DISTINCT marketing_channel
FROM customers
ORDER BY 1
;
-- Logged issue_11, contains both blank and unknown

UPDATE customers
SET marketing_channel = NULL
WHERE marketing_channel = '' OR marketing_channel = 'unknown'
;
-- Successfully consolidate both blank and unknown to NULL

SELECT DISTINCT account_creation_method
FROM customers
ORDER BY 1
;
-- Logged issue_12, contains both blank and unknown

UPDATE customers
SET account_creation_method = NULL
WHERE account_creation_method = '' OR account_creation_method = 'unknown'
;
-- Successfully consolidate both blank and unknown to NULL

SELECT DISTINCT country_code
FROM customers
ORDER BY 1
;
-- Logged issue_13, contains blank and A1 is not a country code

UPDATE customers
SET country_code = NULL
WHERE country_code = '' OR country_code = 'A1'
;
-- Successfully consolidate and set both blank and A1 to NULL

SELECT DISTINCT country
FROM geo_lookup
ORDER BY 1
;
-- Logged issue_14, A1 is not a country code

DELETE FROM geo_lookup
WHERE country = 'A1'
;
-- Successfully delete A1 row

SELECT DISTINCT region
FROM geo_lookup
ORDER BY 1
;
-- Logged issue_15, contains blank

UPDATE geo_lookup
SET region = NULL
WHERE region = ''
;
-- Successfully set blank to NULL


###3 Evaluate unsolvable issue

##3a Null check

SELECT 
    SUM(CASE WHEN orders.customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id_nullcount,
    SUM(CASE WHEN orders.id IS NULL THEN 1 ELSE 0 END) AS order_id_nullcount,
    SUM(CASE WHEN orders.purchase_date IS NULL THEN 1 ELSE 0 END) AS purchase_ts_nullcount,
    SUM(CASE WHEN orders.product_id IS NULL THEN 1 ELSE 0 END) AS product_id_nullcount,
    SUM(CASE WHEN orders.product_name IS NULL THEN 1 ELSE 0 END) AS product_name_nullcount,
    SUM(CASE WHEN orders.currency IS NULL THEN 1 ELSE 0 END) AS currency_nullcount,
    SUM(CASE WHEN orders.local_price IS NULL THEN 1 ELSE 0 END) AS local_price_nullcount,
    SUM(CASE WHEN orders.usd_price IS NULL THEN 1 ELSE 0 END) AS usd_price_nullcount,
    SUM(CASE WHEN orders.purchase_platform IS NULL THEN 1 ELSE 0 END) AS purchase_platform_nullcount
FROM orders
;
-- Logged issue_16, usd_price contains 23 NULLs

SELECT * 
FROM orders
WHERE usd_price IS NULL
;

WITH exchange_rates AS (
    SELECT 'KES' AS currency, 0.0088 AS exchange_rate
    UNION ALL
    SELECT 'LKR', 0.0031
    UNION ALL
    SELECT 'GHS', 0.15
    UNION ALL
    SELECT 'MAD', 0.1
    UNION ALL
    SELECT 'BOB', 0.14
    UNION ALL
    SELECT 'PYG', 0.00014
    UNION ALL
    SELECT 'RSD', 0.0093
    UNION ALL
    SELECT 'MMK', 0.00048
    UNION ALL
    SELECT 'JOD', 1.409
    UNION ALL
    SELECT 'DZD', 0.007369
)
UPDATE orders as o
JOIN exchange_rates AS e
ON o.currency = e.currency
SET o.usd_price = ROUND(o.local_price * e.exchange_rate,2)
WHERE o.usd_price IS NULL
;
-- Successfully impute usd_price following the exchange_rates on 2025-02-04. 


SELECT
    SUM(CASE WHEN customers.id IS NULL THEN 1 ELSE 0 END) AS customer_id_nullcount,
    SUM(CASE WHEN customers.marketing_channel IS NULL THEN 1 ELSE 0 END) AS marketing_channel_nullcount,
    SUM(CASE WHEN customers.account_creation_method IS NULL THEN 1 ELSE 0 END) AS account_creation_method_nullcount,
    SUM(CASE WHEN customers.country_code IS NULL THEN 1 ELSE 0 END) AS country_code_nullcount,
    SUM(CASE WHEN customers.loyalty_program IS NULL THEN 1 ELSE 0 END) AS loyalty_program_nullcount,
    SUM(CASE WHEN customers.created_on IS NULL THEN 1 ELSE 0 END) AS created_on_nullcount
FROM customers
;
-- Logged issue_17, marketing_channel contains 1023 NULLs
-- Logged issue_18, account_creation_method contains 2829 NULLs
-- Logged issue_19, country_code contains 97 NULLs

SELECT * 
FROM customers
WHERE marketing_channel IS NULL
;
SELECT SUM(CASE WHEN marketing_channel IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100 AS null_percentage
FROM customers
;
-- Unable to confidently impute, affects 1.3% of marketing_channel data, leave as is.

SELECT * 
FROM customers
WHERE account_creation_method IS NULL
;
SELECT SUM(CASE WHEN account_creation_method IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100 AS null_percentage
FROM customers
;
-- Unable to confidently impute, affects 3.8% of account_creation_method data, leave as is. 

SELECT * 
FROM customers
WHERE country_code IS NULL
;
SELECT SUM(CASE WHEN country_code IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100 AS null_percentage
FROM customers
;
-- Unable to confidently impute, affects 0.1% of country_code data, leave as is. 


SELECT 
    SUM(CASE WHEN order_status.order_id IS NULL THEN 1 ELSE 0 END) AS order_id_nullcount,
    SUM(CASE WHEN order_status.purchase_date IS NULL THEN 1 ELSE 0 END) AS purchase_date_nullcount,
    SUM(CASE WHEN order_status.ship_date IS NULL THEN 1 ELSE 0 END) AS ship_date_nullcount,
    SUM(CASE WHEN order_status.delivery_date IS NULL THEN 1 ELSE 0 END) AS delivery_date_nullcount,
    SUM(CASE WHEN order_status.refund_date IS NULL THEN 1 ELSE 0 END) AS refund_date_nullcount
FROM order_status
;
-- Logged issue_20, purchase_date contains 3 NULLs
-- refund_date contains 74786 NULLs, this is expected as most orders will not have a refund

SELECT * 
FROM order_status
WHERE purchase_date IS NULL
;
SELECT SUM(CASE WHEN purchase_date IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100 AS null_percentage
FROM order_status
;
-- Unable to confidently impute, affects only 3 rows or <0.1% of purchase_date, leave as is. 


##3 Number logic check

SELECT *
FROM orders
WHERE usd_price <= 0
;
-- Logged issue_21, usd_price contains 115 rows with value 0
-- These 115 rows with value 0 are giveaways, exclude them from analysis


##3b Date logic check eg. refund_ts must be after purchase_ts

SELECT *
FROM order_status
WHERE refund_date < purchase_date
; 
-- No issues. 

SELECT *
FROM order_status
WHERE delivery_date < purchase_date
; 
-- Logged issued_22, 11 rows have delivery_date earlier than purchase_date which doesn't make sense. 

UPDATE order_status
SET delivery_date = NULL
WHERE delivery_date < purchase_date
;
-- Successfully set the 11 rows delivery_date to NULLs

SELECT *
FROM order_status
WHERE ship_date < purchase_date
; 
-- Logged issue_23, 12 rows have ship_date earlier than purchase_date which doesn't make sense. 

UPDATE order_status
SET ship_date = NULL
WHERE ship_date < purchase_date
;
-- Successfully set the 12 rows delivery_date to NULLs

###4 Augment the dataset

SELECT *
FROM order_status
;
-- Logged issue_24, days_to_ship is an important metric for this analysis
-- Loggd issue_25, days_to_delivery is an important metric for this analysis

ALTER TABLE order_status ADD COLUMN days_to_ship INT;

UPDATE order_status
SET days_to_ship = DATEDIFF(ship_date, purchase_date)
;
-- Successfully added days_to_ship calculated column

ALTER TABLE order_status ADD COLUMN days_to_delivery INT;

UPDATE order_status
SET days_to_delivery = DATEDIFF(delivery_date, purchase_date)
;
-- Successfully added days_to_delivery calculated column