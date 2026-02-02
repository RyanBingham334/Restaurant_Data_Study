-- QUESTION: Which bundle discount strategy maximizes profit?
-- USE CASE: Compare 10% vs 20% discount structures before implementation

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
item_data AS (
    SELECT
        m.name,
        m.menu_price,
        ROUND(mic.cost_per_item, 2) AS cost,
        ROUND(m.menu_price - mic.cost_per_item, 2) AS profit
    FROM menu_id m
    JOIN menu_item_cost mic ON m.menu_id = mic.menu_id
)
SELECT
    'Burger + Fries' AS bundle,
    ROUND((b.menu_price + f.menu_price) * 0.9, 2) AS price_10pct_off,
    ROUND((b.menu_price + f.menu_price) * 0.9 - (b.cost + f.cost), 2) AS profit_10pct_off,
    ROUND(b.menu_price + (f.menu_price * 0.8), 2) AS price_20pct_side,
    ROUND(b.menu_price + (f.menu_price * 0.8) - (b.cost + f.cost), 2) AS profit_20pct_side,
    b.profit AS profit_main_only
FROM 
    (SELECT * FROM item_data WHERE name = 'burger') b,
    (SELECT * FROM item_data WHERE name = 'fries') f

UNION ALL

SELECT
    'Pasta + Salad' AS bundle,
    ROUND((p.menu_price + s.menu_price) * 0.9, 2),
    ROUND((p.menu_price + s.menu_price) * 0.9 - (p.cost + s.cost), 2),
    ROUND(p.menu_price + (s.menu_price * 0.8), 2),
    ROUND(p.menu_price + (s.menu_price * 0.8) - (p.cost + s.cost), 2),
    p.profit
FROM 
    (SELECT * FROM item_data WHERE name = 'pasta') p,
    (SELECT * FROM item_data WHERE name = 'salad') s

UNION ALL

SELECT
    'Pizza + Ice Cream' AS bundle,
    ROUND((pz.menu_price + i.menu_price) * 0.9, 2),
    ROUND((pz.menu_price + i.menu_price) * 0.9 - (pz.cost + i.cost), 2),
    ROUND(pz.menu_price + (i.menu_price * 0.8), 2),
    ROUND(pz.menu_price + (i.menu_price * 0.8) - (pz.cost + i.cost), 2),
    pz.profit
FROM 
    (SELECT * FROM item_data WHERE name = 'pizza') pz,
    (SELECT * FROM item_data WHERE name = 'ice cream') i;

-- Combines 3 sepertaed queries using 2 seperate union joins
