-- QUESTION: How do top performers compare to bottom performers?
-- USE CASE: Quantify the profit gap to justify menu optimization strategies

WITH ingredient_unit_cost AS (
    SELECT
        ingredient,
        (CAST(bulk_price AS REAL) / bulk_qty) / conversion_to_oz AS cost_per_oz
    FROM ingredient_cost
),
menu_item_cost AS (
    SELECT
        bom.menu_id,
        SUM(bom.qty * iuc.cost_per_oz) AS cost_per_item
    FROM bill_of_materials bom
    JOIN ingredient_unit_cost iuc ON bom.ingredient = iuc.ingredient
    GROUP BY bom.menu_id
),
item_performance AS (
    SELECT
        m.name AS menu_item,
        m.menu_price,
        ROUND(mic.cost_per_item, 2) AS cost_per_item,
        ROUND(m.menu_price - mic.cost_per_item, 2) AS profit_per_item,
        SUM(mi.quantity) AS total_sold,
        ROUND((m.menu_price - mic.cost_per_item) * SUM(mi.quantity), 2) AS total_profit_contribution
    FROM menu_id m
    JOIN menu_item_cost mic ON m.menu_id = mic.menu_id
    LEFT JOIN menu_items mi ON m.name = mi.food_item
    GROUP BY m.menu_id, m.name, m.menu_price, mic.cost_per_item
)
SELECT
    'Top 4 Items' AS category,
    ROUND(SUM(total_profit_contribution), 2) AS combined_profit,
    SUM(total_sold) AS total_items_sold,
    ROUND(AVG(profit_per_item), 2) AS avg_profit_per_item
FROM item_performance
WHERE menu_item IN ('pasta', 'burger', 'cake', 'pizza')

UNION ALL

SELECT
    'Bottom 4 Items' AS category,
    ROUND(SUM(total_profit_contribution), 2) AS combined_profit,
    SUM(total_sold) AS total_items_sold,
    ROUND(AVG(profit_per_item), 2) AS avg_profit_per_item
FROM item_performance
WHERE menu_item IN ('fries', 'salad', 'soup', 'ice cream');

-- Compares high-profit vs low-profit items to measure optimization opportunity
