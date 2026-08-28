# Data Catalog for Silver Layer

## Overview
The Silver Layer holds cleaned, standardized, and normalized data derived from the Bronze layer. Column structures largely mirror Bronze, but values are cleansed (e.g., codes decoded into readable text, nulls handled) to prepare the data for modeling in the Gold layer. Every table also carries a `dwh_create_Date` metadata column, stamped automatically with `GETDATE()` at load time to record when the row was written into Silver.

---

### 1. silver.crm_cust_info
- **Purpose:** Cleaned customer master data derived from bronze.crm_cust_info.
- **Columns:**

| Column Name         | Data Type     | Description                                                                |
|----------------------|---------------|------------------------------------------------------------------------------|
| cst_id               | INT           | Customer identifier, carried over from the CRM source.                     |
| cst_key              | NVARCHAR(50)  | Alphanumeric customer key used by the CRM system.                          |
| cst_firstname        | NVARCHAR(50)  | Customer's first name, trimmed and standardized.                           |
| cst_lastname         | NVARCHAR(50)  | Customer's last name, trimmed and standardized.                            |
| cst_marital_status   | NVARCHAR(50)  | Marital status decoded into a readable value (e.g., 'Married', 'Single').  |
| cst_gndr             | NVARCHAR(50)  | Gender decoded into a readable value (e.g., 'Male', 'Female', 'n/a').      |
| cst_create_date      | DATE          | Date the customer record was created in the CRM.                           |
| dwh_create_Date      | DATETIME2     | System-generated timestamp recording when the row was loaded into Silver.  |

---

### 2. silver.crm_prd_info
- **Purpose:** Cleaned product master data derived from bronze.crm_prd_info.
- **Columns:**

| Column Name      | Data Type     | Description                                                                |
|-------------------|---------------|------------------------------------------------------------------------------|
| prd_id            | INT           | Product identifier, carried over from the CRM source.                      |
| cat_id            | NVARCHAR(50)  | Product category identifier, extracted from `prd_key` to link to category data. |
| prd_key           | NVARCHAR(50)  | Alphanumeric product key used by the CRM system.                           |
| prd_nm            | NVARCHAR(50)  | Product name, trimmed and standardized.                                    |
| prd_cost          | NVARCHAR(50)  | Product cost, cleaned and validated (e.g., nulls handled).                 |
| prd_line          | NVARCHAR(50)  | Product line decoded into a readable value (e.g., 'Road', 'Mountain').     |
| prd_start_dt      | DATE          | Date the product became active.                                            |
| prd_end_dt        | DATE          | Date the product was retired/deactivated.                                  |
| dwh_create_Date   | DATETIME2     | System-generated timestamp recording when the row was loaded into Silver.  |

---

### 3. silver.crm_Sales_details
- **Purpose:** Cleaned sales transaction records derived from bronze.crm_Sales_details.
- **Columns:**

| Column Name      | Data Type     | Description                                                                |
|-------------------|---------------|------------------------------------------------------------------------------|
| sls_ord_num       | NVARCHAR(50)  | Sales order number, carried over from the CRM source.                      |
| sls_prd_key       | NVARCHAR(50)  | Product key associated with the sales line item, linking to product data.  |
| sls_cust_id       | INT           | Customer identifier associated with the sales order.                       |
| sls_order_dt      | DATE          | Date the order was placed, cleaned/validated from the raw source value.    |
| sls_ship_dt       | DATE          | Date the order was shipped to the customer.                                |
| sls_due_dt        | DATE          | Date the order payment was due.                                            |
| sls_sales         | INT           | Total monetary value of the sale for the line item.                        |
| sls_quantity      | INT           | Number of units of the product ordered for the line item.                  |
| sls_price         | INT           | Price per unit of the product for the line item.                           |
| dwh_create_Date   | DATETIME2     | System-generated timestamp recording when the row was loaded into Silver.  |

---

### 4. silver.erp_CUST_AZ12
- **Purpose:** Cleaned customer data derived from bronze.erp_CUST_AZ12.
- **Columns:**

| Column Name      | Data Type     | Description                                                                |
|-------------------|---------------|------------------------------------------------------------------------------|
| CID               | NVARCHAR(50)  | Customer identifier from the ERP system, used to link back to CRM customers.|
| BDATE             | DATE          | Customer's date of birth, cleaned and validated.                           |
| GEN               | NVARCHAR(50)  | Customer's gender, decoded into a readable value.                          |
| dwh_create_Date   | DATETIME2     | System-generated timestamp recording when the row was loaded into Silver.  |

---

### 5. silver.erp_LOC_A101
- **Purpose:** Cleaned customer location data derived from bronze.erp_LOC_A101.
- **Columns:**

| Column Name      | Data Type     | Description                                                                |
|-------------------|---------------|------------------------------------------------------------------------------|
| CID               | NVARCHAR(50)  | Customer identifier from the ERP system, used to link back to CRM customers.|
| CNTRY             | NVARCHAR(50)  | Customer's country of residence, standardized (e.g., abbreviations expanded).|
| dwh_create_Date   | DATETIME2     | System-generated timestamp recording when the row was loaded into Silver.  |

---

### 6. silver.erp_PX_CAT_G1V2
- **Purpose:** Cleaned product category data derived from bronze.erp_PX_CAT_G1V2.
- **Columns:**

| Column Name      | Data Type     | Description                                                                |
|-------------------|---------------|------------------------------------------------------------------------------|
| ID                | NVARCHAR(50)  | Category identifier, used to link products to their category.              |
| CAT               | NVARCHAR(50)  | Broad product category (e.g., Bikes, Components).                          |
| SUBCAT            | NVARCHAR(50)  | More detailed product subcategory within the category.                     |
| MAINTENANCE       | NVARCHAR(50)  | Indicates whether products in this category require maintenance.           |
| dwh_create_Date   | DATETIME2     | System-generated timestamp recording when the row was loaded into Silver.  |
