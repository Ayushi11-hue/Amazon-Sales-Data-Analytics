use ecom;
SELECT DATABASE();
CREATE TABLE ecommerce (
    order_id VARCHAR(50),
    order_date DATE,
    status VARCHAR(50),
    fulfilment VARCHAR(50),
    sales_channel VARCHAR(50),
    ship_service_level VARCHAR(50),
    style VARCHAR(100),
    sku VARCHAR(100),
    category VARCHAR(100),
    size VARCHAR(20),
    asin VARCHAR(50),
    courier_status VARCHAR(50),
    qty INT,
    currency VARCHAR(10),
    amount DECIMAL(10,2),
    ship_city VARCHAR(100),
    ship_state VARCHAR(100),
    ship_postal_code VARCHAR(20),
    ship_country VARCHAR(50),
    promotion_ids TEXT,
    b2b BOOLEAN,
    fulfilled_by VARCHAR(50)
);
SET GLOBAL local_infile = 1;
delete from ecommerce;
LOAD DATA LOCAL INFILE 'C:/Users/ayush/OneDrive/Desktop/New folder/zodecode/stud/APPLICATIONS/Pic&Sign/Resume/Analyst/ecommerce-analytics-project/data/cleaned/ecommerce_cleaned.csv'
INTO TABLE ecommerce
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, @order_date, status, fulfilment, sales_channel, ship_service_level, style, sku, category, size, asin, courier_status, qty, currency, amount, ship_city, ship_state, ship_postal_code, ship_country, promotion_ids, b2b, fulfilled_by)
SET order_date = STR_TO_DATE(@order_date, '%d-%m-%Y');

SELECT * FROM ecommerce;
/* Total Revenue and Orders */

CREATE VIEW dashboard_rev AS SELECT COUNT(DISTINCT order_id) AS total_orders, SUM(amount) AS total_revenue FROM ecommerce;
/* Monthly Sales Trend */
CREATE VIEW dashboard_monthwise AS SELECT monthname(order_date) AS month, SUM(amount) AS revenue, COUNT(order_id) AS orders FROM ecommerce GROUP BY month ORDER BY month;
/* Top 10 selling categories*/
CREATE VIEW dashboard_top10 AS SELECT category, SUM(qty) AS total_quantity, SUM(amount) AS revenue FROM ecommerce GROUP BY category ORDER BY revenue DESC LIMIT 10;
/*Top States By Revenue*/
CREATE VIEW dashboard_statewise AS SELECT ship_state, SUM(amount) AS revenue FROM ecommerce GROUP BY ship_state ORDER BY revenue DESC LIMIT 10;
/* Top Cities by order*/
CREATE VIEW dashboard_cities AS SELECT ship_city, COUNT(order_id) AS total_orders FROM ecommerce GROUP BY ship_city ORDER BY total_orders DESC LIMIT 10;
/* Courier Performance*/
CREATE VIEW dashboard_courier AS SELECT courier_status, COUNT(*) AS total_orders FROM ecommerce GROUP BY courier_status;
/*Fulfilment Analysis*/
CREATE VIEW dashboard_fulfilment AS SELECT fulfilled_by, COUNT(*) AS total_orders, SUM(amount) AS revenue FROM ecommerce GROUP BY fulfilled_by;
/*B2B vs B2C*/
CREATE VIEW dashboard_b2b AS SELECT b2b, COUNT(order_id) AS total_orders, SUM(amount) AS revenue FROM ecommerce GROUP BY b2b;
/*Average Order Value*/
CREATE VIEW dashboard_AOV AS SELECT SUM(amount) / COUNT(DISTINCT order_id) AS avg_order_value FROM ecommerce;
/*Top Products (SKU Level)*/
CREATE VIEW dashboard_size AS SELECT size, SUM(qty) AS total_qty, SUM(amount) AS revenue FROM ecommerce GROUP BY size ORDER BY revenue DESC;
/*Cancelled order*/
CREATE VIEW dashboard_cancel AS SELECT status, COUNT(*) AS total_orders FROM ecommerce GROUP BY status;
/*Sales Cahnnel*/
CREATE VIEW dashboard_channel AS SELECT sales_channel, SUM(amount) AS revenue, COUNT(order_id) AS orders FROM ecommerce GROUP BY sales_channel;
/*High value orders*/
CREATE VIEW dashboard_hvo AS SELECT * FROM ecommerce WHERE amount > 1000 ORDER BY amount DESC;
/* Service Level*/
CREATE VIEW dashboard_servicelevel AS SELECT ship_service_level, COUNT(*) AS orders, SUM(amount) AS revenue FROM ecommerce GROUP BY ship_service_level;
/*Daily Sales*/
CREATE VIEW dashboard_dailysales AS SELECT order_date, SUM(amount) AS revenue FROM ecommerce GROUP BY order_date ORDER BY order_date;

SELECT * from ecommerce;

