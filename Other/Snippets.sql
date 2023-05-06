------------------------------------------------------------------------------------
--- SELECT -------------------------------------------------------------------------
------------------------------------------------------------------------------------

-- Joins, aliases
SELECT
	O.order_id AS 'Order ID',
    P.product_name AS 'Product',
    S.company_name AS 'Supplier',
    C.category_name AS 'Category'
FROM orders AS O
INNER JOIN order_details AS OD ON O.order_id = OD.order_id
INNER JOIN products AS P ON OD.product_id = P.product_id
LEFT JOIN suppliers AS S ON P.supplier_id = S.supplier_id
INNER JOIN categories AS C ON P.category_id = C.category_id
WHERE
	Year(O.order_date) BETWEEN 2016 AND 2018
    AND O.shipped_date IS NOT NULL
    AND OD.quantity > 100
    AND C.category_name IN ('Meat/Poultry', 'Seafood', 'Dairy Products')
ORDER BY C.category_name, S.company_name, P.product_name
LIMIT 100;

-- Subquery - In
SELECT *
FROM products
WHERE category_id IN (
    SELECT category_id
    FROM categories
    WHERE category_name = 'Seafood'
);

-- Subquery - Exists
SELECT *
FROM products AS P
WHERE EXISTS (
    SELECT 1
    FROM order_details AS OD
    WHERE 
        P.product_id = OD.product_id
        AND quantity > 100
);

-- Subquery - Any
SELECT *
FROM products
WHERE product_id = ANY(
    SELECT product_id
    FROM order_details
    WHERE quantity > 100
);

-- Top and Limit
SELECT TOP 100 * FROM orders;       -- SQL Server
SELECT * FROM orders LIMIT 100;     -- MYSQL

-- Like
SELECT * FROM employees WHERE first_name LIKE 'a%';     -- Starts with 'a'
SELECT * FROM employees WHERE first_name LIKE '%t';     -- Ends with 't'
SELECT * FROM employees WHERE first_name LIKE '%an%';   -- Contains 'an'

-- Distinct
SELECT DISTINCT country FROM suppliers;

-- Order by date, show newest first
SELECT * FROM orders ORDER BY order_date DESC;

-- Select Case
SELECT *,
CASE
	WHEN country = 'USA' THEN 'North America'
    WHEN country = 'Brazil' THEN 'South America'
    WHEN country = 'UK' THEN 'Europe'
    WHEN country = 'Japan' THEN 'Asia'
    WHEN country = 'Egypt' THEN 'Africa'
    WHEN country = 'Australia' THEN 'Australia'
    ELSE NULL
END AS continent
FROM suppliers;

------------------------------------------------------------------------------------
--- GROUP BY AND AGGREGATE FUNCTIONS -----------------------------------------------
------------------------------------------------------------------------------------

-- Count with Where and Having
SELECT
	COUNT(1) AS 'Number of customers',
    country 'Country' 
FROM customers
WHERE country IS NOT NULL
GROUP BY country
HAVING COUNT(customer_id) > 1
ORDER BY COUNT(customer_id) DESC;

-- Count, Min, Max, Avg, Sum
SELECT
	C.category_name AS 'Category',
    COUNT(1) AS 'Number of products',
    MIN(P.unit_price) AS 'Min price',
    MAX(P.unit_price) AS 'Max price',
    AVG(P.unit_price) AS 'Avg price',
    AVG(P.units_in_stock) AS 'Avg units in stock',
    SUM(P.unit_price * P.units_in_stock) AS 'Total stock value',
    SUM(P.unit_price * P.units_on_order) AS 'Total orders value'
FROM products AS P
INNER JOIN categories AS C ON P.category_id = C.category_id
GROUP BY category_name;

------------------------------------------------------------------------------------
--- OTHER FUNCTIONS ----------------------------------------------------------------
------------------------------------------------------------------------------------

-- String: Concat, Len
SELECT
	CONCAT(first_name, ' ', last_name) AS 'Full name',
    LEN(CONCAT(first_name, ' ', last_name)) AS 'Name length'
FROM employees;

-- Math: Round, Floor, Ceil
SELECT
    order_id AS 'Order ID',
    ROUND(unit_price * quantity * (1 - discount), 2) AS 'Total Price - round',
    FLOOR(unit_price * quantity * (1 - discount)) AS 'Total Price - floor',
    CEIL(unit_price * quantity * (1 - discount)) AS 'Total Price - ceil'
FROM order_details;

-- Date: Day, Month, Year
SELECT
	first_name AS 'First name',
    last_name AS 'Last name',
    DAY(birth_date) AS 'Day of birth',
    MONTH(birth_date) AS 'Month of birth',
    YEAR(birth_date) AS 'Year of birth'
FROM employees;

------------------------------------------------------------------------------------
--- SET OPERATIONS -----------------------------------------------------------------
------------------------------------------------------------------------------------

SELECT company_name, contact_name, 'Customer' AS 'role' FROM customers
UNION
UNION ALL
EXCEPT -- or MINUS in Oracle
INTERSECT
SELECT company_name, contact_name, 'Supplier' AS 'role' FROM suppliers;

------------------------------------------------------------------------------------
--- INSERT, UPDATE, DELETE ---------------------------------------------------------
------------------------------------------------------------------------------------

INSERT INTO categories (category_name, description)
VALUES ('Greens', 'Fruits and vegetables');

UPDATE categories
SET description = 'Fruits, vegetables and mushrooms'
WHERE category_name = 'Greens';

DELETE FROM categories
WHERE category_name = 'Greens';


-- northwind.db from https://www.sql-practice.com/