-- QUESTION: What are our best-selling items by volume and revenue?
-- USE CASE: Identify top performers to optimize menu 

SELECT
    mi.food_item,
    mi.category,
    COUNT(*) AS times_sold,
    SUM(mi.quantity) AS total_quantity_sold,
    ROUND(SUM(mi.price), 2) AS total_revenue,
    ROUND(AVG(mi.price), 2) AS avg_price_per_order
FROM
    menu_items mi
GROUP BY
    mi.food_item, mi.category
ORDER BY
    total_quantity_sold DESC;

-- This query reveals volume leaders and revenue drivers across categories
-- Use to prioritize ingredient purchasing and identify promotional opportunities
