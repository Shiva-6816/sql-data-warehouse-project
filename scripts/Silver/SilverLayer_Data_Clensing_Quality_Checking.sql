
------------------------------------------------------------
--1:Silver layer Data Quality Checking : Silver.crm_cust_info 
------------------------------------------------------------

select *
from Silver.crm_cust_info;

select COUNT(*)
from Silver.crm_cust_info

--Checking Duplicate primary key
select cst_id,
	cst_key,
	count(*) as duplicate
from Silver.crm_cust_info
group by cst_id , cst_key
having count(*) > 1


-- Checking unwanted spaces
select cst_firstname
from Silver.crm_cust_info
where cst_firstname != TRIM(cst_firstname)

select cst_lastname
from Silver.crm_cust_info
where cst_lastname != TRIM(cst_lastname)


-- Checking Standerdization and consistancy
select distinct cst_gndr
from Silver.crm_cust_info

select distinct cst_marital_status
from Silver.crm_cust_info

-- Checking Invalid Dates
select *
from Silver.crm_cust_info
where cst_create_date is null


---------------------------------------------------------
--2:Silver layer Data Quality Checking : crm_prd_info 
---------------------------------------------------------


select *
from Silver.crm_prd_info


-- check the duplicate primary key

select 
	prd_id,
	count(*)
from Silver.crm_prd_info
group by prd_id
having COUNT(*) > 1

-- chacking Unwanted Sapaces

select prd_nm
from Silver.crm_prd_info
where prd_nm != TRIM(prd_nm)

-- check null and nagative values
select prd_cost
from silver.crm_prd_info
where prd_cost < 0 or prd_cost is null


-----------------------------------------------------------
-- 3:Silver layer Data Quality Checking : crm_Sales_details 
-----------------------------------------------------------

SELECT *
FROM Silver.crm_Sales_details

-- CHECKING DUPLICATED AND NULL VALUES OF PRIMARY KEY
SELECT 
	sls_prd_key,
	COUNT(*)
FROM Silver.crm_Sales_details
GROUP BY sls_prd_key
HAVING COUNT(*) < 1

SELECT 
	sls_cust_id,
	COUNT(*)
FROM Silver.crm_Sales_details
GROUP BY sls_cust_id
HAVING COUNT(*) < 1


--checking invalid dated
select *
from Silver.crm_Sales_details
where sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt

SELECT *
FROM Silver.crm_sales_details
WHERE sls_order_dt IS NULL
   OR sls_order_dt < '2000-01-01'
   OR sls_order_dt > '2026-12-31'
   OR LEN(sls_due_dt) != 10;


SELECT *
FROM Silver.crm_sales_details
WHERE sls_due_dt IS NULL
   OR sls_due_dt < '2000-01-01'
   OR sls_due_dt > '2026-12-31'
   OR LEN(sls_due_dt) != 10;

SELECT *
FROM Silver.crm_sales_details
WHERE sls_ship_dt IS NULL
   OR sls_ship_dt < '2000-01-01'
   OR sls_ship_dt > '2026-12-31'
   OR LEN(sls_ship_dt) != 10;


-- checking the connetion Forign key between schemas
select sls_prd_key
from Silver.crm_Sales_details
where sls_prd_key not in (select prd_key from Silver.crm_prd_info )

select sls_cust_id
from Silver.crm_Sales_details
where sls_cust_id not in (select cst_id from Silver.crm_cust_info)

select *
from Silver.crm_Sales_details

select *
from Silver.crm_cust_info

select *
from Silver.crm_prd_info

-- checking the sales , quantity and price 
-- sales = quantity * price
-- check no null values and nagative values 

select 
	sls_sales,
	sls_quantity,
	sls_price
from Silver.crm_Sales_details
where sls_sales != sls_quantity * sls_price 
or sls_sales is null or sls_quantity is null or sls_price is null
or sls_sales <= 0 or sls_quantity <= 0 or sls_price <= 0


----------------------------------------------------------------
--4:Silver layer Data Quality Checking : Silver.erp_CUST_AZ12 
----------------------------------------------------------------

select *
from Silver.erp_CUST_AZ12

-- Checking duplicate Primary key's

select 
	CID,
	COUNT(*)
from Silver.erp_CUST_AZ12
group by CID
having count(*) > 1

-- checking the connetion Forign key between schemas

select *
from Silver.erp_CUST_AZ12
where CID not in ( select cst_key from Silver.crm_cust_info)

-- checking the outliers like invalid dates

select BDATE
from Silver.erp_CUST_AZ12
where BDATE < '1900-01-01' or BDATE > GETDATE()


-- data standerdization and consistency
select distinct GEN
from Silver.erp_CUST_AZ12


----------------------------------------------------------------
--5:Silver layer Data Quality Checking : Silver.erp_LOC_A101 
----------------------------------------------------------------

select *
from Silver.erp_LOC_A101

-- checking the duplicate primary key

select CID,
	count(*)
from Silver.erp_LOC_A101
group by CID
having count(*) > 1

-- CHECKING Data Standerdization and consistensy
select distinct CNTRY
from Silver.erp_LOC_A101

---------------------------------------------------------
--6:Silver layer :Data Quality Checking : erp_PX_CAT_G1V2 
---------------------------------------------------------

select *
from Silver.erp_PX_CAT_G1V2

-- checking the duplicate primary key

select 
	ID,
	COUNT(*)
from Silver.erp_PX_CAT_G1V2
group by ID
having count(*) > 1

-- checking unwanted spaces
select *
from Silver.erp_PX_CAT_G1V2
where CAT != TRIM(CAT) or SUBCAT != TRIM(SUBCAT) or MAINTENANCE != TRIM(MAINTENANCE)

-- checking data standerdization and consistnesy
select distinct CAT
from Silver.erp_PX_CAT_G1V2

select distinct SUBCAT
from Silver.erp_PX_CAT_G1V2

select distinct MAINTENANCE
from Silver.erp_PX_CAT_G1V2











