## Data Source & Acknowledgments

This project began with the [Restaurant Orders dataset](https://www.kaggle.com/datasets/haseebindata/restaurant-orders) by Muhammad Haseeb on Kaggle, which provided the initial transaction data structure (menu_items table).

I significantly expanded the dataset by creating additional tables and adding over 150% more data:
- **Created** `menu_id` table with standardized pricing
- **Created** `bill_of_materials` table with complete recipe breakdowns for all items
- **Created** `ingredient_cost` table with bulk pricing and conversion factors
- **Added** ingredient-level cost data for profitability analysis

The original dataset provided the foundation for transaction records. The expanded schema and cost analysis framework are my own additions to enable the profitability analysis presented in this project.
