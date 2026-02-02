-- QUESTION: Which menu items drive profitability?
-- USE CASE: Identify high-margin items to promote and low-margin items to optimize

-- Profit margin analysis: total cost, gross profit, and profit margin for each dish
SELECT
    mi.menu_id,
    mi.name,
    mi.menu_price,
    ROUND(SUM((CAST(bom.qty AS REAL) / ic.conversion_to_oz) * ic.bulk_price / ic.bulk_qty), 2) AS Recipe_Cost,
    ROUND(mi.menu_price - SUM((CAST(bom.qty AS REAL) / ic.conversion_to_oz) * ic.bulk_price / ic.bulk_qty), 2) AS Gross_Profit,
    ROUND((mi.menu_price - SUM((CAST(bom.qty AS REAL) / ic.conversion_to_oz) * ic.bulk_price / ic.bulk_qty)) / mi.menu_price * 100, 2) AS Profit_Margin_Percent
FROM
    menu_id mi
JOIN
    bill_of_materials bom ON mi.menu_id = bom.menu_id
JOIN
    ingredient_cost ic ON bom.ingredient = ic.ingredient
GROUP BY
    mi.menu_id, mi.name, mi.menu_price
ORDER BY
    Profit_Margin_Percent DESC;

-- This query identifies profit margin leaders and opportunities for cost reduction
-- or sales price optimization on underperforming items
