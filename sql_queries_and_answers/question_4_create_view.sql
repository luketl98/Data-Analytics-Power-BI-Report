CREATE VIEW store_sales_summary AS
SELECT 
    dim_stores.store_type,
    SUM(orders.product_quantity * dim_products.sale_price) AS total_sales,
    SUM(orders.product_quantity * dim_products.sale_price) * 100.0 / 
        (SELECT SUM(product_quantity * sale_price) FROM orders 
         JOIN dim_products ON orders.product_code = dim_products.product_code) AS percentage_of_total_sales,
    COUNT(DISTINCT orders.index) AS order_count
FROM orders
JOIN dim_stores ON orders.store_code = dim_stores.store_code
JOIN dim_products ON orders.product_code = dim_products.product_code
GROUP BY dim_stores.store_type;
