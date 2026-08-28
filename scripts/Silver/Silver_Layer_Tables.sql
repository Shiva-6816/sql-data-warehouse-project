/*
=============================================================
Silver Layer - Data Definition Language (DDL)
=============================================================
Purpose:
Creates the Silver layer tables used to store cleaned and
transformed data from the Bronze layer.

The tables cover CRM customer/product/sales data and
ERP customer/location/category data.
=============================================================
*/
use DataWareHouse;

IF OBJECT_ID ('silver.crm_cust_info' , 'U') IS not null
 drop table silver.crm_cust_info;
Create Table silver.crm_cust_info(
cst_id int,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),	
cst_marital_status	NVARCHAR(50),
cst_gndr NVARCHAR(50),
cst_create_date DATE,
dwh_create_Date datetime2 default getdate()
);


IF OBJECT_ID ('silver.crm_prd_info' , 'U') IS not null
 drop table silver.crm_prd_info;
create table silver.crm_prd_info(
prd_id INT,
cat_id NVARCHAR(50),
prd_key	NVARCHAR(50),
prd_nm	NVARCHAR(50),
prd_cost NVARCHAR(50),
prd_line NVARCHAR(50),
prd_start_dt DATE,
prd_end_dt DATE,
dwh_create_Date datetime2 default getdate()
);

IF OBJECT_ID ('silver.crm_Sales_details' , 'U') IS not null
 drop table silver.crm_Sales_details;
create table silver.crm_Sales_details(

sls_ord_num	NVARCHAR(50),
sls_prd_key	NVARCHAR(50),
sls_cust_id	INT,
sls_order_dt date,
sls_ship_dt date,
sls_due_dt date,
sls_sales INT,
sls_quantity INT,
sls_price INT,
dwh_create_Date datetime2 default getdate()
);

select *
from Bronze.crm_Sales_details

IF OBJECT_ID ('silver.erp_CUST_AZ12' , 'U') IS not null
 drop table silver.erp_CUST_AZ12;
create table silver.erp_CUST_AZ12(
CID	NVARCHAR(50),
BDATE DATE,
GEN NVARCHAR(50),
dwh_create_Date datetime2 default getdate()
);

IF OBJECT_ID ('silver.erp_LOC_A101' , 'U') IS not null
 drop table silver.erp_LOC_A101;
create table silver.erp_LOC_A101(
CID	 Nvarchar(50),
CNTRY Nvarchar(50),
dwh_create_Date datetime2 default getdate()
);


IF OBJECT_ID ('silver.erp_PX_CAT_G1V2' , 'U') IS not null
 drop table silver.erp_PX_CAT_G1V2;
create table silver.erp_PX_CAT_G1V2(
ID Nvarchar(50),
CAT Nvarchar(50),
SUBCAT Nvarchar(50),
MAINTENANCE Nvarchar(50),
dwh_create_Date datetime2 default getdate()

);




