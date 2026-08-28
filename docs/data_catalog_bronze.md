# Data Catalog for Bronze Layer

## Overview
The Bronze Layer stores raw, unprocessed data exactly as it was extracted from the source systems (CRM and ERP). No cleaning, renaming, or transformation is applied here — column names and data types mirror the source as closely as possible, including fields still stored in their original raw format (e.g., dates as integers).

---

### 1. bronze.crm_cust_info
- **Purpose:** Raw customer master data extracted directly from the CRM system.
- **Columns:**

| Column Name         | Data Type     | Description                                                        |
|----------------------|---------------|---------------------------------------------------------------------|
| cst_id               | INT           | Customer identifier as recorded in the source CRM system.          |
| cst_key              | NVARCHAR(50)  | Alphanumeric customer key used by the CRM system.                  |
| cst_firstname        | NVARCHAR(50)  | Customer's first name, as entered in the CRM.                      |
| cst_lastname         | NVARCHAR(50)  | Customer's last name, as entered in the CRM.                       |
| cst_marital_status   | NVARCHAR(50)  | Raw marital status code/value from the CRM.                        |
| cst_gndr             | NVARCHAR(50)  | Raw gender code/value from the CRM.                                 |
| cst_create_date      | DATE          | Date the customer record was created in the CRM.                   |

---

### 2. bronze.crm_prd_info
- **Purpose:** Raw product master data extracted directly from the CRM system.
- **Columns:**

| Column Name    | Data Type     | Description                                                        |
|-----------------|---------------|---------------------------------------------------------------------|
| prd_id          | INT           | Product identifier as recorded in the source CRM system.           |
| prd_key         | NVARCHAR(50)  | Alphanumeric product key used by the CRM system (encodes category). |
| prd_nm          | NVARCHAR(50)  | Product name as entered in the CRM.                                 |
| prd_cost        | NVARCHAR(50)  | Raw product cost value from the CRM.                                |
| prd_line        | NVARCHAR(50)  | Raw product line code/value from the CRM.                           |
| prd_start_dt    | DATE          | Date the product became active in the CRM.                          |
| prd_end_dt      | DATE          | Date the product was retired/deactivated in the CRM.                |

---

### 3. bronze.crm_Sales_details
- **Purpose:** Raw sales transaction records extracted directly from the CRM system.
- **Columns:**

| Column Name    | Data Type     | Description                                                                                     |
|-----------------|---------------|----------------------------------------------------------------------------------------------------|
| sls_ord_num     | NVARCHAR(50)  | Raw sales order number from the CRM.                                                             |
| sls_prd_key     | NVARCHAR(50)  | Product key associated with the sales line item.                                                 |
| sls_cust_id     | INT           | Customer identifier associated with the sales order.                                             |
| sls_order_dt    | INT           | Date the order was placed, stored in raw integer format (e.g., YYYYMMDD) as received from source.|
| sls_ship_dt     | INT           | Date the order was shipped, stored in raw integer format (e.g., YYYYMMDD) as received from source.|
| sls_due_dt      | INT           | Date the order payment was due, stored in raw integer format (e.g., YYYYMMDD) as received from source.|
| sls_sales       | INT           | Total monetary value of the sale for the line item, as recorded in the source.                   |
| sls_quantity    | INT           | Number of units of the product ordered for the line item.                                        |
| sls_price       | INT           | Price per unit of the product for the line item, as recorded in the source.                      |

---

### 4. bronze.erp_CUST_AZ12
- **Purpose:** Raw customer data extracted directly from the ERP system.
- **Columns:**

| Column Name | Data Type     | Description                                                        |
|-------------|---------------|---------------------------------------------------------------------|
| CID         | NVARCHAR(50)  | Customer identifier from the ERP system.                            |
| BDATE       | DATE          | Customer's date of birth, as recorded in the ERP.                   |
| GEN         | NVARCHAR(50)  | Raw gender code/value from the ERP.                                 |

---

### 5. bronze.erp_LOC_A101
- **Purpose:** Raw customer location data extracted directly from the ERP system.
- **Columns:**

| Column Name | Data Type     | Description                                                        |
|-------------|---------------|---------------------------------------------------------------------|
| CID         | NVARCHAR(50)  | Customer identifier from the ERP system.                            |
| CNTRY       | NVARCHAR(50)  | Raw country value from the ERP (e.g., abbreviations, inconsistent casing). |

---

### 6. bronze.erp_PX_CAT_G1V2
- **Purpose:** Raw product category data extracted directly from the ERP system.
- **Columns:**

| Column Name  | Data Type     | Description                                                        |
|--------------|---------------|---------------------------------------------------------------------|
| ID           | NVARCHAR(50)  | Category identifier from the ERP system.                            |
| CAT          | NVARCHAR(50)  | Raw broad product category value from the ERP.                      |
| SUBCAT       | NVARCHAR(50)  | Raw product subcategory value from the ERP.                         |
| MAINTENANCE  | NVARCHAR(50)  | Raw maintenance-required flag/value from the ERP.                   |
