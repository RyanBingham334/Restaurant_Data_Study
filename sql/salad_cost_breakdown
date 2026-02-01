-- QUESTION: What is the ingredient-level cost breakdown for a the salad menu item?
-- USE CASE: Detailed recipe costing for menu pricing and margin analysis

SELECT 
    bom.ingredient,
    bom.qty,
    bom.unit,
    ROUND((CAST(bom.qty AS REAL) / ic.conversion_to_oz) * ic.bulk_price / ic.bulk_qty, 4) AS ingredient_cost
FROM 
    bill_of_materials bom
JOIN 
    ingredient_cost ic ON bom.ingredient = ic.ingredient
WHERE 
    bom.menu_id = '#007'
ORDER BY
    ingredient_cost DESC;

-- Shows per-ingredient costs ranked by expense to identify cost optimization opportunities
