Title: Bikestore Database Project

The Bikestore database is a comprehensive dataset designed to manage and track various aspects of a bike store's operations. 
It is divided into two main schemas: 
1. Productions
2. Sales. 

-- Production Schema focuses on the products sold by the store. It includes the following tables:

1. brands: Stores information about the different brands of bikes and accessories available in the store.
Columns: brand_id, brand_name

2. categories: Represents the different categories of products offered, such as bikes, accessories, and clothing.
Columns: category_id, category_name

3. products: Contains detailed information about each product, including the brand, category, model year, and list price.
Columns: product_id, product_name, brand_id, category_id, model_year, list_price

4. stocks: Tracks the inventory levels of products across different store locations.
Columns: store_id, product_id, quantity

-- Sales Schema manages the transactional and customer-related aspects of the business. It includes the following tables:

1. customers: Stores information about the customers, including their contact details and demographic information.
Columns: customer_id, first_name, last_name, phone, email, street, city, state, zip_code

2. order_items: Represents the individual items in each order, including the product, quantity, and price.
Columns: order_id, item_id, product_id, quantity, list_price, discount

3. orders: Contains information about the orders placed by customers, including the order date, status, and the associated store and staff member.
Columns: order_id, customer_id, order_status, order_date, required_date, shipped_date, store_id, staff_id

4. staffs: Holds information about the staff members, including their names, email addresses, and employment details.
Columns: staff_id, first_name, last_name, email, phone, active, store_id, manager_id

5.stores: Contains details about the store locations, including their addresses and contact information.
Columns: store_id, store_name, phone, email, street, city, state, zip_code

-- Key Concepts Covered
1. Data Retrieval
2. Data Manipulation
3. Stored Procedures
4. Transactions
5. Views.



