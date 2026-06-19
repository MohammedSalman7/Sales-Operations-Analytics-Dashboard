CREATE DATABASE sales_operations_dashboard;
USE sales_operations_dashboard;


-- Customers Table
CREATE TABLE `customers` (
   `customer_id` int NOT NULL AUTO_INCREMENT,
   `customer_name` varchar(100) DEFAULT NULL,
   `gender` varchar(10) DEFAULT NULL,
   `city` varchar(50) DEFAULT NULL,
   `state` varchar(50) DEFAULT NULL,
   `customer_segment` varchar(30) DEFAULT NULL,
   PRIMARY KEY (`customer_id`)
 ) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



 -- Products Table
CREATE TABLE `products` (
   `product_id` int NOT NULL AUTO_INCREMENT,
   `product_name` varchar(100) DEFAULT NULL,
   `category` varchar(50) DEFAULT NULL,
   `price` decimal(10,2) DEFAULT NULL,
   PRIMARY KEY (`product_id`)
 ) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



 -- Employees Table
CREATE TABLE `employees` (
   `employee_id` int NOT NULL AUTO_INCREMENT,
   `employee_name` varchar(100) DEFAULT NULL,
   `department` varchar(50) DEFAULT NULL,
   `designation` varchar(50) DEFAULT NULL,
   `city` varchar(50) DEFAULT NULL,
   `salary` decimal(10,2) DEFAULT NULL,
   PRIMARY KEY (`employee_id`)
 ) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



 -- Sales Table
CREATE TABLE `sales` (
   `sale_id` int NOT NULL AUTO_INCREMENT,
   `customer_id` int DEFAULT NULL,
   `product_id` int DEFAULT NULL,
   `employee_id` int DEFAULT NULL,
   `quantity` int DEFAULT NULL,
   `sale_amount` decimal(10,2) DEFAULT NULL,
   `sale_date` date DEFAULT NULL,
   PRIMARY KEY (`sale_id`),
   KEY `customer_id` (`customer_id`),
   KEY `product_id` (`product_id`),
   KEY `employee_id` (`employee_id`),
   CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`),
   CONSTRAINT `sales_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
   CONSTRAINT `sales_ibfk_3` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`)
 ) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



 -- Reporting View
CREATE VIEW master_sales_data AS
SELECT
    s.sale_id,
    s.sale_date,
    c.customer_name,
    c.city,
    c.state,
    c.customer_segment,
    p.product_name,
    p.category,
    e.employee_name,
    e.department,
    s.quantity,
    s.sale_amount
FROM sales s
JOIN customers c
    ON s.customer_id = c.customer_id
JOIN products p
    ON s.product_id = p.product_id
JOIN employees e
    ON s.employee_id = e.employee_id;





-- =====================================
-- DATA IMPORT INFORMATION
-- =====================================

-- customers.csv imported into customers table
-- products.csv imported into products table
-- employees.csv imported into employees table
-- sales.csv imported into sales table

-- Data imported using MySQL Workbench Table Data Import Wizard.



-- =====================================
-- BUSINESS ANALYTICS QUERIES
-- =====================================

-- 1.Total Sales
SELECT
    SUM(sale_amount) AS Total_Sales
FROM sales;

-- 2.Total Orders
SELECT
    COUNT(*) AS Total_Orders
FROM sales;

-- 3.Total Quantity Sold
SELECT
    SUM(quantity) AS Total_Quantity
FROM sales;

-- 4.Average Sale Value
SELECT
    AVG(sale_amount) AS Average_Sale_Value
FROM sales;

-- 5.Top 5 Products
SELECT
    p.product_name,
    SUM(s.sale_amount) AS Total_Sales
FROM sales s
JOIN products p
ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY Total_Sales DESC
LIMIT 5;

-- 6.Sales by Category
SELECT
    p.category,
    SUM(s.sale_amount) AS Total_Sales
FROM sales s
JOIN products p
ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY Total_Sales DESC;

-- 7.State-wise Sales
SELECT
    c.state,
    SUM(s.sale_amount) AS Total_Sales
FROM sales s
JOIN customers c
ON s.customer_id = c.customer_id
GROUP BY c.state
ORDER BY Total_Sales DESC;

-- 8.Customer Segment Analysis
SELECT
    c.customer_segment,
    SUM(s.sale_amount) AS Total_Sales
FROM sales s
JOIN customers c
ON s.customer_id = c.customer_id
GROUP BY c.customer_segment
ORDER BY Total_Sales DESC;

-- 9.Department Performance
SELECT
    e.department,
    SUM(s.sale_amount) AS Total_Sales
FROM sales s
JOIN employees e
ON s.employee_id = e.employee_id
GROUP BY e.department
ORDER BY Total_Sales DESC;

-- 10.Monthly Sales Trend
SELECT
    MONTH(sale_date) AS Month_Number,
    SUM(sale_amount) AS Total_Sales
FROM sales
GROUP BY MONTH(sale_date)
ORDER BY Month_Number;