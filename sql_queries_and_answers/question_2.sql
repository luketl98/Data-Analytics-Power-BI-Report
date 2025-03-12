SELECT dim_date.month_name, 
       SUM(orders.product_quantity * dim_products.sale_price) AS total_revenue
FROM orders
JOIN dim_date 
    ON TO_DATE(orders.order_date, 'DD/MM/YYYY') = TO_DATE(dim_date.date, 'DD/MM/YYYY')
JOIN dim_products 
    ON orders.product_code = dim_products.product_code
WHERE EXTRACT(YEAR FROM TO_DATE(orders.order_date, 'DD/MM/YYYY')) = 2022
GROUP BY dim_date.month_name, dim_date.month_number
ORDER BY total_revenue DESC
LIMIT 1;
