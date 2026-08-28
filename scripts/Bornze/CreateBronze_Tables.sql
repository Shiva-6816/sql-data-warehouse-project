-- ============================================================
-- Bronze Layer Table Creation
-- Creates the Bronze-layer tables used to store raw/source data.
-- SQL statements below are unchanged; comments are added only for clarity.
-- ============================================================

use DataWareHouse;


IF OBJECT_ID ('bronze.crm_cust_info' , 'U') IS not null
 drop table bronze.crm_cust_info;
Create Table bronze.crm_cust_info(
	cst_id int,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),	
	cst_marital_status	NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
);


IF OBJECT_ID ('bronze.crm_prd_info' , 'U') IS not null
 drop table bronze.crm_prd_info;
create table bronze.crm_prd_info(
	prd_id INT,
	prd_key	NVARCHAR(50),
	prd_nm	NVARCHAR(50),
	prd_cost NVARCHAR(50),
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE

);


IF OBJECT_ID ('bronze.crm_Sales_details' , 'U') IS not null
 drop table bronze.crm_Sales_details;
create table bronze.crm_Sales_details(

	sls_ord_num	NVARCHAR(50),
	sls_prd_key	NVARCHAR(50),
	sls_cust_id	INT,
	sls_order_dt INT ,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,

);

IF OBJECT_ID ('bronze.erp_CUST_AZ12' , 'U') IS not null
 drop table bronze.erp_CUST_AZ12;
create table bronze.erp_CUST_AZ12(
	CID	NVARCHAR(50),
	BDATE DATE,
	GEN NVARCHAR(50)
);

IF OBJECT_ID ('bronze.erp_LOC_A101' , 'U') IS not null
 drop table bronze.erp_LOC_A101;
create table bronze.erp_LOC_A101(
	CID	 Nvarchar(50),
	CNTRY Nvarchar(50)
);


IF OBJECT_ID ('bronze.erp_PX_CAT_G1V2' , 'U') IS not null
 drop table bronze.erp_PX_CAT_G1V2;
create table bronze.erp_PX_CAT_G1V2(
	ID Nvarchar(50),
	CAT Nvarchar(50),
	SUBCAT Nvarchar(50),
	MAINTENANCE Nvarchar(50)

);



