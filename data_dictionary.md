# Data Dictionary

## Overview
This database contains restaurant menu items, ingredient costs, bill of materials (recipes), and transaction data used to analyze profitability.

## Data Quality Notes

**Schema Issue Identified**: Menu items are encoded with IDs (#001, #002, etc.) rather than using human-readable names as primary keys. This creates unnecessary complexity when joining tables and makes queries harder to write and debug.

**Recommendation**: Use menu item names (pasta, burger, salad) as primary keys in `menu_id` table, or create a proper integer-based auto-incrementing primary key system. The current alphanumeric encoding (#001, #007) provides no benefit and reduces data accessibility.

---

## Tables

### 1. `menu_id`
**Description**: Catalog of all menu items with their standard prices

| Column Name | Data Type | Description | Example |
|-------------|-----------|-------------|---------|
| menu_id | TEXT | Unique identifier for each menu item ( non-standard encoding) | #001, #002, #007 |
| name | TEXT | Display name of the menu item | pasta, burger, salad |
| menu_price | INTEGER | Standard menu price in dollars | 21, 17, 12 |

**Primary Key**: `menu_id`

**Data Quality Issue**: The menu_id uses arbitrary alphanumeric codes that don't follow sequential ordering (e.g., #001, #002, #003, #004, #005, #006, #007, #008, #009). This encoding scheme makes it difficult to:
- Join tables efficiently
- Query specific items without looking up codes first
- Maintain referential integrity
- Understand data relationships at a glance

---

### 2. `bill_of_materials`
**Description**: Recipe breakdown showing ingredient quantities needed for each menu item

| Column Name | Data Type | Description | Example |
|-------------|-----------|-------------|---------|
| menu_id | TEXT | Foreign key linking to menu_id table | #001, #007 |
| ingredient | TEXT | Name of ingredient used | lettuce, parmesan, bacon |
| qty | INTEGER | Quantity of ingredient needed | 10, 2, 4 |
| unit | TEXT | Unit of measurement | oz, lb, cup |

**Composite Key**: (`menu_id`, `ingredient`)  
**Foreign Key**: `menu_id` → `menu_id.menu_id`

**Note**: Queries require joining on the encoded menu_id rather than intuitive item names, reducing code readability.

---

### 3. `ingredient_cost`
**Description**: Bulk purchasing information and unit costs for all ingredients

| Column Name | Data Type | Description | Example |
|-------------|-----------|-------------|---------|
| ingredient | TEXT | Name of ingredient | lettuce, parmesan, tomato |
| bulk_price | INTEGER | Cost of bulk purchase in dollars | 5, 12, 8 |
| bulk_qty | INTEGER | Quantity in bulk purchase | 50, 10, 25 |
| bulk_unit | TEXT | Unit of bulk purchase | oz, lb, each |
| conversion_to_oz | INTEGER | Conversion factor to ounces | 1, 16, 1 |

**Primary Key**: `ingredient`

**Cost Calculation Formula**:
```sql
cost_per_oz = (bulk_price / bulk_qty) / conversion_to_oz
recipe_cost = SUM(qty * cost_per_oz) for all ingredients
```

**Note**: 
- `conversion_to_oz` standardizes all measurements to ounces for consistent calculations

---

### 4. `menu_items`
**Description**: Transaction-level sales data showing actual customer orders

| Column Name | Data Type | Description | Example |
|-------------|-----------|-------------|---------|
| order_id | INTEGER | Unique identifier for each order | 4390, 7606 |
| customer_name | TEXT | Name of customer | Thomas Frazier, Kathleen Miranda |
| food_item | TEXT | Menu item ordered (should match menu_id.name) | pizza, burger, salad |
| category | TEXT | Menu category | Main, Dessert, Starter |
| quantity | INTEGER | Number of items ordered | 1, 3, 5 |
| price | TEXT | Price paid for this line item in dollars | 16, 30, 12 |
| payment_method | TEXT | How customer paid | Cash, Debit Card |
| order_time | TEXT | Date and time of order | 4/22/2025 2:38 |

**Primary Key**: `order_id`

**Data Quality Issues**:
1. **Price stored as TEXT**: Should be INTEGER or REAL for calculations
2. **No foreign key constraint**: `food_item` links to `menu_id.name` by convention only
3. **Date format inconsistent**: `order_time` stored as TEXT rather than proper DATE/DATETIME type

**Relationship**: This table links to `menu_id` through `food_item = menu_id.name`, NOT through the encoded menu_id field, which creates an indirect relationship that complicates joins.

---

## Table Relationships
```
menu_id (menu_id, name, menu_price)
    ↓ (via menu_id)
bill_of_materials (menu_id, ingredient, qty, unit)
    ↓ (via ingredient)
ingredient_cost (ingredient, bulk_price, bulk_qty, conversion_to_oz)

menu_id (name)
    ↓ (via name = food_item, indirect relationship)
menu_items (order_id, food_item, quantity, price)
```

**Schema Design Issue**: The database uses two different keys to reference the same menu items:
- `bill_of_materials` uses encoded `menu_id` (#001, #002)
- `menu_items` uses human-readable `food_item` names (pasta, burger)

This dual-reference system requires joining through the `menu_id` table as an intermediary, adding unnecessary complexity.

---

## Recommended Schema Improvements

1. **Standardize Primary Keys**
   - Use integer auto-increment IDs 
   - Remove the alphanumeric encoding (#001, #002)

2. **Fix Data Types**
   - Change `menu_items.price` from TEXT to INTEGER/REAL
   - Seperate data and time and change `menu_items.order_time` from TEXT to DATETIME
   - Ensure all numeric fields are properly typed

5. **Add Indexes**
   - Index foreign keys for join performance
   - Index frequently queried columns (food_item, order_time)

---

## Usage Notes

- All monetary values are in USD
- All quantities are standardized to ounces for cost calculations
- Labor costs are NOT included in this dataset
- The analysis period covers transactions from the `menu_items` table date range
