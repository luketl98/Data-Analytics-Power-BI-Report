SELECT dim_stores.store_type, 
       SUM(orders.product_quantity * dim_products.sale_price) AS total_revenue
FROM orders
JOIN dim_stores 
    ON orders.store_code = dim_stores.store_code
JOIN dim_products 
    ON orders.product_code = dim_products.product_code
JOIN dim_date 
    ON TO_DATE(orders.order_date, 'DD/MM/YYYY') = TO_DATE(dim_date.date, 'DD/MM/YYYY')
WHERE dim_stores.country = 'Germany' 
AND EXTRACT(YEAR FROM TO_DATE(orders.order_date, 'DD/MM/YYYY')) = 2022
GROUP BY dim_stores.store_type
ORDER BY total_revenue DESC
LIMIT 1;
