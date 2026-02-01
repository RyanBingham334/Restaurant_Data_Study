# Restaurant Profitability Analysis

## Objective
Analyze menu item profitability to identify why the restaurant is losing money, using ingredient-level cost data and menu pricing.

## Dataset
SQLite database containing:
- Menu items and prices
- Bill of materials per dish
- Ingredient bulk costs and unit conversions

## Methodology
1. Cleaned and validated ingredient cost and conversion data
2. Joined menu items with bill of materials and ingredient costs
3. Calculated:
   - Recipe cost per dish
   - Gross profit per menu item
   - Profit margin percentage (excluding labor)

## Key Findings
- Several low-priced items generate minimal absolute profit despite high margins
- High-cost items (e.g., Pizza) have significantly lower profit margins
- Menu pricing does not align with ingredient cost complexity

## Tools Used
- SQLite
- DB Browser for SQLite
- SQL (JOINs, aggregation, cost modeling)
