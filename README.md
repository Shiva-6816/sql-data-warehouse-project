# SQL Data Warehouse Project

An end-to-end **SQL Data Warehouse** project built using the **Medallion Architecture (Bronze → Silver → Gold)**.

This project demonstrates how raw CRM and ERP data can be extracted, loaded, cleaned, transformed, integrated, and modeled into an analytics-ready **star schema** using **Microsoft SQL Server**.

---

## 🏗️ Data Architecture

The project follows the **Medallion Architecture**, separating data processing into three layers:

![Data Architecture](docs/data_Architecture.png)

1. **Bronze Layer** – Raw data landed exactly as received from source CSV files (CRM & ERP). No transformations.
2. **Silver Layer** – Cleaned, standardized, and quality-checked data. Duplicates handled, data types fixed, values normalized.
3. **Gold Layer** – Business-ready data modeled as a **star schema** (dimensions + fact) for analytics and reporting.

---

## 📖 Project Overview

The main objective of this project is to build a modern SQL data warehouse that consolidates sales-related data from **CRM and ERP systems** into a single analytics-friendly model.

The project demonstrates:

| Area                  | Implementation                                              |
| --------------------- | ----------------------------------------------------------- |
| **Data Architecture** | Bronze → Silver → Gold Medallion Architecture               |
| **ETL Pipeline**      | Extract → Load → Transform                                  |
| **Data Loading**      | SQL Server `BULK INSERT`                                    |
| **Data Cleaning**     | Nulls, duplicates, invalid values, inconsistent formats     |
| **Data Integration**  | CRM + ERP source systems                                    |
| **Data Modeling**     | Star Schema                                                 |
| **Data Quality**      | Validation checks across Bronze, Silver and Gold            |
| **Documentation**     | Data catalogs, naming conventions and architecture diagrams |
| **Version Control**   | Git & GitHub                                                |

---

## 🛠️ Tools & Technologies

* **Microsoft SQL Server**
* **SQL Server Management Studio (SSMS)**
* **T-SQL**
* **Git**
* **GitHub**
* **CSV Source Files**
---

# 🚀 Project Requirements

## 🎯 Data Engineering Goal

Build a SQL-based data warehouse that consolidates sales-related information from CRM and ERP systems and transforms it into a reliable, analytics-ready data model.

The warehouse is designed to support:

* Business reporting
* Sales analysis
* Customer analysis
* Product analysis
* Data quality validation
* Analytical queries

---
## 📌 Key Specifications

- **Database:** Microsoft SQL Server
- **Architecture:** Medallion (Bronze → Silver → Gold)
- **Sources:** CRM & ERP CSV files
- **ETL:** Extract → Load → Transform
- **Data Processing:** Cleaning, Transformation & Validation
- **Data Model:** Star Schema
- **Gold Layer:** `dim_customers`, `dim_products`, `fact_sales`
- **Data Quality:** Nulls, Duplicates, Invalid Dates & Inconsistent Values
- **Scope:** Latest Data Snapshot
- **Documentation:** Data Catalogs & Naming Conventions
---

# 📂 Repository Structure

```text
sql-data-warehouse-project/
│
├── dataset/
│   ├── source_crm/
│   │   ├── cust_info.csv
│   │   ├── prd_info.csv
│   │   └── sales_details.csv
│   │
│   └── source_erp/
│       ├── CUST_AZ12.csv
│       ├── LOC_A101.csv
│       └── PX_CAT_G1V2.csv
│
├── docs/
│   ├── data_Architecture.png
│   ├── data_Flow.png
│   ├── Data Integration.png
│   ├── data_catalog_bronze.md
│   ├── data_catalog_silver.md
│   ├── data_catalog_gold.md
│   └── naming_conventions.md
│
├── scripts/
│   │
│   ├── Bronze/
│   │   ├── CreateDatabase_Schemas.sql
│   │   ├── CreateBronze_Tables.sql
│   │   ├── Insert_BulkData_into_Tables.sql
│   │   └── BronzeLayer_Data_Quality_Check.sql
│   │
│   ├── Silver/
│   │   ├── Silver_Layer_Tables.sql
│   │   ├── Bronze_to_Silver_Data_Inserting.sql
│   │   └── SilverLayer_Data_Cleansing_Quality_Checking.sql
│   │
│   └── Gold/
│       ├── Creating_Gold_Layer_Tables.sql
│       └── Gold_Layer_Data_Cleaning.sql
│
└── README.md
```

---

# 🔄 ETL Workflow

The complete data pipeline follows this process:

```text
CRM CSV Files ──────┐
                    │
                    ▼
              🥉 BRONZE LAYER
              Raw Source Data
                    │
                    ▼
              🥈 SILVER LAYER
          Cleaned & Standardized
                    │
                    ▼
               🥇 GOLD LAYER
             Star Schema Model
                    │
                    ▼
          Analytics & Reporting
                    ▲
                    │
ERP CSV Files ──────┘
```

---

# ⭐ Gold Layer – Star Schema

The Gold layer contains the following analytical objects:

| Object               | Type      | Purpose                                                           |
| -------------------- | --------- | ----------------------------------------------------------------- |
| `gold.dim_customers` | Dimension | Customer information, demographics and geography                  |
| `gold.dim_products`  | Dimension | Product information, category, cost and product line              |
| `gold.fact_sales`    | Fact      | Sales transactions including orders, quantities, prices and dates |


---

## 📋 Data Quality Highlights

- Null / missing value handling
- Duplicate detection and resolution
- Standardization of gender, marital status, and product line codes
- Date format conversion and validation
- Referential integrity between facts and dimensions
- Consistent naming using `docs/naming_conventions.md`
---

# 📚 Documentation

Detailed documentation is available in the `docs` folder.

| Document                 | Description                            |
| ------------------------ | -------------------------------------- |
| `data_catalog_bronze.md` | Bronze layer tables and source columns |
| `data_catalog_silver.md` | Silver layer cleaned tables            |
| `data_catalog_gold.md`   | Gold layer dimensions and fact tables  |
| `naming_conventions.md`  | Project-wide naming standards          |
| `data_Architecture.png`  | High-level data architecture           |
| `data_Flow.png`          | End-to-end data flow                   |
| `Data Integration.png`   | CRM and ERP integration overview       |

---

# 🔍 Example Analytical Questions

The Gold layer can be used to answer business questions such as:

* What are the total sales?
* Which products generate the highest revenue?
* Which customers generate the most sales?
* What are the best-performing product categories?
* How many orders are placed over time?
* What is the average order value?
* Which product lines perform best?
* How does sales performance vary by customer geography?

---
## 🎯 Project Outcomes

- 🟢 Built SQL Data Warehouse
- 🟢 Implemented Medallion Architecture
- 🟢 Integrated CRM & ERP data
- 🟢 Cleaned & transformed data
- 🟢 Implemented data quality checks
- 🟢 Created Star Schema
- 🟢 Built customer, product & sales models
- 🟢 Prepared data for analytics & reporting
---

# 📜 License

This project is created for **learning, educational, and portfolio purposes**.

Feel free to fork, study, modify, and adapt the project.

---

# 🙏 Acknowledgements

This project was inspired by the excellent **SQL Data Warehouse** tutorial series by **Data With Baraa**.

The implementation in this repository is an **independent learning project** created for educational and portfolio purposes.

---

## 👨‍💻 Author

**Shiva Prasad**

Built with **SQL Server + T-SQL + Data Engineering Concepts**

---

⭐ If you find this project useful, consider giving the repository a **star** on GitHub.
