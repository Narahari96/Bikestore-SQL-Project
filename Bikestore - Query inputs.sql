-- 1. Top 5 products with the highest total sales amount.

SELECT 
    Pro.Product_name AS Product_name,
    Bra.Brand_Name AS brand_name,
    Cat.Category_Name AS category_name,
    SUM(Ord.list_price * quantity) AS total_sales_amount,
    Orders.Order_Date
FROM
    productions.products AS Pro
        JOIN
    productions.brands AS Bra ON Pro.Product_Id = Bra.brand_id
        JOIN
    productions.categories AS Cat ON Bra.brand_id = Cat.Category_Id
        JOIN
    sales.order_items AS Ord ON Ord.order_id = Cat.Category_Id
        JOIN
    sales.orders AS Orders ON Orders.order_id = Ord.order_id
GROUP BY Pro.Product_Id , Pro.Product_name , Orders.Order_Date
ORDER BY total_sales_amount DESC
LIMIT 5;

-- 2. Categorize the customers based on their total purchase amount into three categories: 'High Value', 'Medium Value', and 'Low Value'.

SELECT 
    Cus.Customer_Id AS Customer_id,
    CONCAT(cus.first_name, ' ', cus.last_name) AS Full_name,
    Cat.Category_Name AS Category_Name,
    SUM(Ord.list_price * Ord.quantity) AS total_purchase_amount,
    CASE
        WHEN SUM(Ord.list_price * Ord.quantity) > 8000 THEN 'High Value'
        WHEN
            SUM(Ord.list_price * Ord.quantity) >= 2500
                AND SUM(Ord.list_price * Ord.quantity) <= 8000
        THEN
            'Medium Value'
        WHEN SUM(Ord.list_price * quantity) < 2500 THEN 'Low Value'
    END AS Customer_Category
FROM
    Sales.customers AS Cus
        JOIN
    Sales.Order_items AS Ord ON Cus.Customer_id = Ord.order_id
        JOIN
    productions.categories AS Cat ON Cat.Category_Id = Ord.Order_id
GROUP BY cus.first_name , cus.last_name , Cus.Customer_id , Cat.Category_Name
ORDER BY customer_id ASC;

-- 3. Customers with the highest average transaction amount.

Select Cust.Customer_id, concat(Cust.first_name, ' ',Cust.last_name) as Full_Name, CustAvg.Avg_transaction_amount
from Sales.Customers as Cust
join (
			Select Ord.order_id , round(avg(ord.list_price),2) as Avg_transaction_amount
            from sales.order_items as Ord
            group by Ord.order_id 
		) as CustAvg
on Cust.Customer_id = CustAvg.Order_id
order by avg_transaction_amount desc
limit 10;

--  4. Show the total sales amount for each store.

SELECT 
    Sal.store_id,
    Sal.store_name,
    CONCAT(sta.first_name, ' ', sta.last_name) AS staff_name,
    SUM(ord.list_price * quantity) AS total_sales
FROM
    sales.stores AS Sal
        JOIN
    sales.staffs AS Sta ON sal.store_id = sta.staff_id
        JOIN
    sales.order_items AS ord ON ord.order_id = sta.staff_id
GROUP BY ord.order_id;

-- 5. Using a recursive CTE, generate a report of all staff members and their reporting hierarchy. 

WITH RECURSIVE emp_hierarchy AS (
SELECT staff_id, 
				CONCAT(first_name, ' ', last_name) AS Staff_Name,
				manager_id, 
				store_id
    FROM sales.staffs 
    WHERE manager_id IS NULL
    UNION ALL
    SELECT Staf.staff_id, 
					CONCAT(Staf.first_name, ' ', Staf.last_name) AS Staff_Name,
					Staf.manager_id, 
					Staf.store_id
    FROM sales.staffs AS Staf
    JOIN emp_hierarchy AS emp ON Staf.manager_id = emp.staff_id
)
SELECT * FROM emp_hierarchy;


-- 6. Create a view for order summary:

CREATE VIEW order_summary AS
    (
    SELECT 
        ord.order_id,
        ord.order_date,
        CONCAT(cust.first_name, ' ', cust.last_name) AS Customer_name,
        stor.store_name,
        SUM(item.List_Price * item.quantity) AS total_order_amount
    FROM
        sales.orders AS ord
            JOIN
        sales.customers AS cust ON ord.customer_id = cust.customer_id
            RIGHT JOIN
        sales.stores AS stor ON ord.Store_Id = stor.Store_Id
            RIGHT JOIN
        sales.order_items AS item ON ord.order_id = item.order_id
    GROUP BY ord.order_id , ord.Order_Date , stor.store_name
    );
    
-- 7. Calculate the total sales amount for each staff member:

SELECT 
    staff.staff_id,
    CONCAT(staff.first_name, ' ', staff.last_name) AS Staff_name,
    SUM(item.list_price * quantity) AS sales_amount
FROM
    sales.staffs AS staff
        JOIN
    sales.orders AS ord ON staff.staff_id = ord.staff_id
        JOIN
    sales.order_items AS item ON item.order_id = ord.order_id
GROUP BY staff_id
ORDER BY sales_amount DESC;

-- 8. Create a stored procedure to insert a new customer

DELIMITER //

CREATE PROCEDURE AddNewCustomer(
	IN p_customer_id INT,
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_phone VARCHAR(15),
    IN p_email VARCHAR(100),
    IN p_street VARCHAR(100),
    IN p_city VARCHAR(50),
    IN p_state VARCHAR(50),
    IN p_zip_code VARCHAR(10)
)
BEGIN
    INSERT INTO sales.customers (customer_id, first_name, last_name, phone, email, street, city, state, zip_code)
    VALUES (p_customer_id, p_first_name, p_last_name, p_phone, p_email, p_street, p_city, p_state, p_zip_code);
END //

DELIMITER ;

Call AddNewCustomer ( 1450, 'Narahari', 'Naik', 9019370935, 'naraharinaik.d@gmail.com', '36 East Stonybrook Rd', 'Richardson', 'TX',	'75080');

-- 9. Transfer production stocks between stores.

Start transaction;

UPDATE productions.stocks 
SET 
    quantity = quantity - 15
WHERE
    product_id = 300 AND store_id = 3;

UPDATE productions.stocks 
SET 
    quantity = quantity + 15
WHERE
    product_id = 200 AND store_id = 2; 

commit;




