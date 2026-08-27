# Naming Conventions

This document defines how schemas, tables, views, columns, and other database objects are named across the data warehouse, so the project stays consistent and easy to navigate.

## Table of Contents
1. [General Rules](#general-rules)
2. [Table Naming](#table-naming)
   - [Bronze Layer](#bronze-layer)
   - [Silver Layer](#silver-layer)
   - [Gold Layer](#gold-layer)
3. [Column Naming](#column-naming)
   - [Surrogate Keys](#surrogate-keys)
   - [Metadata Columns](#metadata-columns)
4. [Stored Procedures](#stored-procedures)

---

## General Rules
- **snake_case everywhere** — write all object names in lowercase words separated by underscores (`customer_profile`, not `CustomerProfile`).
- **English only** — every schema, table, and column name is written in standard English, with no mixed languages.
- **No reserved keywords** — object names never collide with SQL keywords such as `select`, `date`, `order`, or `table`.
- **Singular nouns** — tables are named after a single instance of the entity they hold (`customer_order`, not `orders`).
- **Matching key names** — a foreign key keeps the exact same name as the primary key it references (`customer_id` everywhere, not `cust_id` in one table and `customer_id` in another).
- **No spaces or brackets** — names never contain spaces, which would otherwise force `[bracketed]` syntax in queries.
- **Constraint prefixes** — constraints use consistent lowercase tags: `pk_` for primary keys, `fk_` for foreign keys, `uq_` for unique constraints.
- **Reserved system prefixes** — `@` is reserved for variables and `#` for temporary objects; these prefixes aren't reused for anything else.
- **No cryptic abbreviations** — names are spelled out in full so the code stays self-documenting, rather than relying on shorthand only the author understands.

---

## Table Naming

### Bronze Layer
Tables keep the identity of where the data came from and are not renamed from the source. Note that ERP source tables (`CUST_AZ12`, `LOC_A101`, `PX_CAT_G1V2`) keep their original casing exactly as extracted — this is an intentional exception to the snake_case rule, since Bronze must mirror the source system as-is.

**Pattern:** `<source>_<entity>`
- `<source>` — the originating system (`crm`, `erp`)
- `<entity>` — the table's name exactly as it appears in that source system

Tables in this project's Bronze schema:
| Table                     | Source | Holds                              |
|---------------------------|--------|-------------------------------------|
| `bronze.crm_cust_info`    | CRM    | Raw customer master data           |
| `bronze.crm_prd_info`     | CRM    | Raw product master data            |
| `bronze.crm_Sales_details`| CRM    | Raw sales transaction records      |
| `bronze.erp_CUST_AZ12`    | ERP    | Raw customer data from ERP         |
| `bronze.erp_LOC_A101`     | ERP    | Raw customer location data         |
| `bronze.erp_PX_CAT_G1V2`  | ERP    | Raw product category data          |

### Silver Layer
Same naming logic as Bronze — the source system prefix and original entity name are preserved, even though the data itself is now cleaned and standardized.

**Pattern:** `<source>_<entity>`
- `<source>` — the originating system (`crm`, `erp`)
- `<entity>` — the table's original name from that source

Tables in this project's Silver schema:
| Table                      | Source | Holds                                    |
|----------------------------|--------|--------------------------------------------|
| `silver.crm_cust_info`     | CRM    | Cleaned customer master data               |
| `silver.crm_prd_info`      | CRM    | Cleaned product master data                |
| `silver.crm_Sales_details` | CRM    | Cleaned sales transaction records          |
| `silver.erp_CUST_AZ12`     | ERP    | Cleaned customer data from ERP             |
| `silver.erp_LOC_A101`      | ERP    | Cleaned customer location data             |
| `silver.erp_PX_CAT_G1V2`   | ERP    | Cleaned product category data              |

### Gold Layer
Tables here are named for business meaning rather than source system, and are prefixed by their role in the model.

**Pattern:** `<role>_<entity>`
- `<role>` — what the table represents in the model, e.g. `dim` for a dimension or `fact` for a fact table
- `<entity>` — a business-friendly name for what the table holds (`customers`, `products`, `sales`)

Gold-layer objects in this project are implemented as **views**, not physical tables — they compute directly from the Silver layer each time they're queried, so there's no separate load step (and no `load_gold` procedure) for this layer.

Views in this project's Gold schema:
| View                   | Role              | Holds                                    |
|------------------------|-------------------|--------------------------------------------|
| `gold.dim_customers`   | Dimension         | Business-ready customer attributes         |
| `gold.dim_products`    | Dimension         | Business-ready product attributes          |
| `gold.fact_sales`      | Fact              | Sales transactions linked to both dimensions |

#### Role Prefixes

| Prefix    | Represents        | Example(s)                            |
|-----------|--------------------|----------------------------------------|
| `dim_`    | Dimension view/table | `dim_customers`, `dim_products`     |
| `fact_`   | Fact view/table    | `fact_sales`                          |
| `report_` | Reporting view/table | `report_customers`, `report_sales_monthly` |

---

## Column Naming

### Surrogate Keys
Every dimension table's primary key ends in `_key`.

**Pattern:** `<table_name>_key`
- `<table_name>` — the entity the key identifies

Example: `customer_key` is the surrogate key in `dim_customers`.

### Metadata Columns
Columns generated by the system itself (not sourced from upstream data) are prefixed `dwh_`.

**Pattern:** `dwh_<description>`
- `dwh` — flags the column as system-generated metadata
- `<description>` — what the column tracks

Example: `dwh_load_date` records when a row was loaded into the warehouse.

---

## Stored Procedures
Procedures that load data into a layer follow a simple, predictable pattern.

**Pattern:** `load_<layer>`
- `<layer>` — the layer being populated (`bronze`, `silver`, `gold`)

This project has two loading procedures, matching its two physical layers:
- `bronze.load_bronze` — loads raw CRM and ERP data into the Bronze layer
- `silver.load_silver` — cleans and loads Bronze data into the Silver layer

There is no `load_gold` procedure, since the Gold layer is built entirely from views (see [Gold Layer](#gold-layer) above) rather than loaded tables.
