
----------------------------------------------------------------
--1:Bronze layer Data Quality Checking : Bronze.crm_cust_info 
----------------------------------------------------------------


--checking the null and duplicates in primary key
-- Write an SQL query to list all customer IDs that occur more than once along with their occurrence count.

select
	cst_id,
	count(*)
from Bronze.crm_cust_info
group by cst_id
having count(*) > 1;

/*Write a SQL query to return all outdated customer records from the Bronze.crm_cust_info table. For each cst_id, 
keep only the latest record based on cst_create_date and return all remaining records.
*/

select *
from (
select *,
	row_number() over (partition by cst_id order by cst_create_date desc) flag
from Bronze.crm_cust_info
)t where flag !=1;


-- Befor data cleaning we find may issues in bronze folders 
-- after data cleaning we filtered and sorted the issues 


select *
from Bronze.crm_cust_info

--Checking Duplicate primary key

select cst_key,count(*)
from Bronze.crm_cust_info
group by cst_key
having count(*) > 1

select *
from(
select *,
	ROW_NUMBER() over (partition by cst_key order by cst_create_date desc) as flag
from Bronze.crm_cust_info
)t where cst_id = 29466


-- unwanted spaces
select cst_firstname
from Bronze.crm_cust_info
where cst_firstname != TRIM(cst_firstname)

select cst_lastname
from Bronze.crm_cust_info
where cst_lastname != TRIM(cst_lastname)



--Data Standerdization
select DISTINCT cst_gndr
from Bronze.crm_cust_info

select distinct cst_marital_status
from Bronze.crm_cust_info

select *
from(
select *,
	ROW_number() over (partition by cst_id order by cst_create_date desc) as flag
	from Bronze.crm_cust_info
	where cst_id is not null
)t where flag != 1

SELECT *,
       COUNT(*) OVER (PARTITION BY cst_id) AS flag
FROM Bronze.crm_cust_info
WHERE cst_id IN (
    SELECT cst_id
    FROM Bronze.crm_cust_info
    GROUP BY cst_id
    HAVING COUNT(*) > 1
)
ORDER BY cst_id, cst_create_date DESC;
----------------------------------------------------------------------------------
/*
select * from Bronze.crm_Sales_details 
select * from Bronze.crm_prd_info

select * from Bronze.crm_Sales_details 
select * from Bronze.crm_cust_info

select * from Bronze.crm_prd_info
select * from Bronze.erp_PX_CAT_G1V2

select * from Bronze.crm_cust_info
--select * from Bronze.erp_CUST_AZ12
select * from Bronze.erp_LOC_A101
*/

----------------------------------------------------------------
--2:Bronze layer Data Quality Checking : Bronze.crm_prd_info 
----------------------------------------------------------------

select *
from Bronze.crm_prd_info


--Checking the duplicate primary key
select prd_id,
	count(*)
from Bronze.crm_prd_info
group by prd_id
having count(*) > 1

--Checking duplicate and null prd_key 
select prd_key,
	count(*)
from Bronze.crm_prd_info
group by prd_key
having count(*) > 1


SELECT *,
       COUNT(*) OVER (PARTITION BY prd_key) AS flag
FROM Bronze.crm_prd_info
WHERE prd_key IN (
    SELECT prd_key
    FROM Bronze.crm_prd_info
    GROUP BY prd_key
    HAVING COUNT(*) > 1
)

-- check the Unwanted spaces
select prd_nm
from Bronze.crm_prd_info
where prd_nm != TRIM(prd_nm)

-- check the null values and nagative numbers in cost column

select prd_cost
from Bronze.crm_prd_info
where prd_cost < 0 or prd_cost is null

-- Checking Standerdization and consistancy
select distinct prd_line
from Bronze.crm_prd_info

select *
from Bronze.crm_prd_info

-- Checking invalid date order
select *
from Bronze.crm_prd_info
where prd_end_dt < prd_start_dt


select 
	prd_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	dateadd ( DAY , -1 ,LEAD(prd_start_dt) over (partition by prd_key order by prd_start_dt)) as prd_end_dt
from Bronze.crm_prd_info


----------------------------------------------------------------
--3:Bronze layer Data Quality Checking : Bronze.crm_Sales_details 
----------------------------------------------------------------

select *
from Bronze.crm_Sales_details


--checking invalid dated
select 
	nullif(sls_order_dt,0) sls_order_dt 
from Bronze.crm_Sales_details
where sls_order_dt <= 0 
or LEN(sls_order_dt) != 8
or sls_order_dt > 20261231
or sls_order_dt < 20000101


-- checking the connetion dup
select sls_prd_key
from Bronze.crm_Sales_details
where sls_prd_key not in (select prd_key from Silver.crm_prd_info)

select sls_cust_id
from Bronze.crm_Sales_details
where sls_cust_id not in (select cst_id from Silver.crm_cust_info)

select sls_ord_num
from Bronze.crm_Sales_details
where sls_ord_num != TRIM(sls_ord_num)


-- checking the sales , quantity and price 
-- sales = quantity * price
-- check no null values and nagative values 

select distinct
	sls_sales as old_sales,
	sls_quantity,
	sls_price as old_price,

	case when sls_sales is null or sls_sales <= 0 or sls_sales != sls_quantity * ABS(sls_price )
				then sls_quantity * ABS(sls_price)
			else sls_sales
	end AS sls_sales,

	case when sls_price IS NULL OR sls_price <= 0 
			THEN sls_sales/NULLIF(sls_quantity,0)
		ELSE sls_price
	END AS sls_price

from Bronze.crm_Sales_details
where sls_sales != sls_quantity * sls_price 
or sls_sales is null or  sls_quantity is null or sls_price is null
or sls_sales <= 0 or sls_quantity <=0 or sls_price <= 0
order by sls_sales , sls_quantity , sls_price


----------------------------------------------------------------
--4:Bronze layer Data Quality Checking : Bronze.erp_CUST_AZ12 
----------------------------------------------------------------

select *
from Bronze.erp_CUST_AZ12



-- checking the outliers like invalid dates

select BDATE
from Bronze.erp_CUST_AZ12
where BDATE < '1900-01-01' or BDATE > GETDATE()


-- data standerdization and consistency
select distinct GEN ,
case when UPPER(TRIM(GEN)) in ('F' , 'Female') then 'Female'
	when UPPER(TRIM(GEN)) in ('M' , 'Male') then 'Male'
		ELSE 'N/A'
	END GEN
from Bronze.erp_CUST_AZ12


----------------------------------------------------------------
--5:Bronze layer Data Quality Checking : Bronze.erp_LOC_A101 
----------------------------------------------------------------

select *
from Bronze.erp_LOC_A101

-- checking the duplicate primary key

select CID,
	count(*)
from Bronze.erp_LOC_A101
group by CID
having count(*) > 1

-- CHECKING Data Standerdization and consistensy
select distinct CNTRY,
case when TRIM(CNTRY) = 'DE' THEN  'Germany'
	WHEN TRIM(CNTRY) IN ('US', 'USA') THEN 'United States'
	WHEN TRIM(CNTRY) = '' OR CNTRY IS NULL THEN 'N/A'
	ELSE CNTRY
END CNTRY
from Bronze.erp_LOC_A101


----------------------------------------------------------------
--6:Bronze layer :Data Quality Checking : Bronze.erp_PX_CAT_G1V2 
----------------------------------------------------------------

--checking Duplicate in Primary key 
select 
	ID,
	COUNT(*)
from Bronze.erp_PX_CAT_G1V2
group by ID
having COUNT(*) > 1;

-- checking unwanted spaces

select *
from Bronze.erp_PX_CAT_G1V2
where CAT != TRIM(CAT) or SUBCAT != TRIM(SUBCAT) or MAINTENANCE != TRIM(MAINTENANCE)

-- checking data standerdization and consistency
select distinct CAT
from Bronze.erp_PX_CAT_G1V2


select distinct SUBCAT
from Bronze.erp_PX_CAT_G1V2

select distinct MAINTENANCE
from Bronze.erp_PX_CAT_G1V2

select cat_id
from Silver.crm_prd_info
























