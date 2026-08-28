/*
===============================================================================
                    SILVER LAYER - DATA LOAD PROCEDURE
===============================================================================

Purpose:
    This stored procedure loads data from the Bronze layer into the Silver
    layer after applying data cleaning, transformation, standardization,
    validation, and deduplication rules.

Source Layer:
    Bronze Layer

Target Layer:
    Silver Layer

Source Tables:
    - Bronze.crm_cust_info
    - Bronze.crm_prd_info
    - Bronze.crm_Sales_details
    - Bronze.erp_CUST_AZ12
    - Bronze.erp_LOC_A101
    - Bronze.erp_PX_CAT_G1V2

Target Tables:
    - silver.crm_cust_info
    - silver.crm_prd_info
    - silver.crm_Sales_details
    - silver.erp_CUST_AZ12
    - silver.erp_LOC_A101
    - silver.erp_PX_CAT_G1V2

Main Transformations:
    - Removes duplicate customer records.
    - Cleans and trims text values.
    - Standardizes gender, marital status, product lines, and country names.
    - Handles NULL and invalid values.
    - Validates sales, price, quantity, and date information.
    - Generates product end dates using the LEAD() function.
    - Standardizes customer and product keys.
    - Records execution time for individual loads and the complete procedure.
    - Handles errors using TRY...CATCH.

Loading Approach:
    Each Silver table is truncated before loading fresh transformed data
    from its corresponding Bronze table.

Execution:
    EXEC silver.load_silver;

===============================================================================
*/


Create or Alter PROCEDURE silver.load_silver as
declare @startProcedureTime datetime , @endProcedureTime datetime;
set @startProcedureTime = GETDATE();
Begin
	declare @starttime datetime , @endtime datetime;
	Begin try
		/*
		===============================================================================
		1 : Loading Data: Bronze Layer → Silver Layer : silver.crm_cust_info
		===============================================================================
		*/
		print '--> loading Silver Layer ';
		print '  ';
		print '-----------------------------------------';
		print '			 Loading CRM Tables			';
		print '-----------------------------------------';
		print '=================================================';


		set @starttime = GETDATE();
		print '>>Truncating Table : silver.crm_cust_info';
		Truncate table silver.crm_cust_info;

		print 'Bronze Layer --> Silver Layer';
		print '>>Inserting Data into : silver.crm_cust_info';
		Insert into silver.crm_cust_info(
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_marital_status,
		cst_gndr,
		cst_create_date
		)
		select 
			cst_id,
			cst_key,
			TRIM(cst_firstname) as cst_firstname,
			TRIM(cst_lastname) as cst_lastname,
			case when upper(trim(cst_marital_status)) = 'M' then 'Married'
				 when upper(trim(cst_marital_status))= 'S' then 'Single'
				 else 'N\A'
			END cst_marital_status,
			case when upper(trim(cst_gndr)) = 'M' then 'Male'
				 when upper(trim(cst_gndr))= 'F' then 'Female'
				 else 'N\A'
			END cst_gndr,
			cst_create_date
		from (

		select *,
			ROW_NUMBER() over (partition by cst_id order by cst_create_date desc) as flag
			from Bronze.crm_cust_info
			where cst_id is not null
		) t where flag = 1
		print 'silver.crm_cust_info Inserted Sucessfully ';

		set @endtime = GETDATE();
		print 'Time Duration : '+cast(datediff(second , @starttime ,@endtime )as nvarchar)+'seconds';
		print ' ';
		-------------------------------------------------------------------------------
		/*
		===============================================================================
		2 : Loading Data: Bronze Layer → Silver Layer : silver.crm_prd_info
		===============================================================================
		*/
		set @starttime = GETDATE();
		print 'Truncating Table : silver.crm_prd_info';
		Truncate table silver.crm_prd_info;

		print 'Bronze Layer --> Silver Layer';
		print 'Inserting Data into : silver.crm_prd_info';
		insert into Silver.crm_prd_info( 
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)
		select 
			prd_id,
			replace (SUBSTRING(prd_key, 1 , 5),'-','_') as cat_id,
			SUBSTRING(prd_key,7, LEN(prd_key)) as prd_key,
			prd_nm,
			isnull(prd_cost,0) as prd_cost,
			CASE UPPER(TRIM(prd_line))
				 When 'M' THEN 'Mountain'
				 When 'R' THEN 'Road'
				 When 'S' THEN 'Other sales'
				 When 'T' THEN 'Touring'
				 else 'N\A'
			END prd_line,		
			cast(prd_start_dt as date ) as prd_start_dt,
			dateadd ( DAY , -1 ,LEAD(prd_start_dt) over (partition by prd_key order by prd_start_dt)) as prd_end_dt
		from Bronze.crm_prd_info

		print 'silver.crm_prd_info Inserted Sucessfully ';

		set @endtime = GETDATE();
		print 'Time Duration : '+cast(datediff(second , @starttime , @endtime) as nvarchar)+'Seconds';
		print ' ';
		-------------------------------------------------------------------------------
		/*
		===============================================================================
		3 : Loading Data: Bronze Layer → Silver Layer : silver.crm_Sales_details
		===============================================================================
		*/
		set @starttime = GETDATE();
		print 'Truncating Table : silver.crm_Sales_details';

		Truncate table silver.crm_Sales_details;
		print 'Bronze Layer --> Silver Layer' ;
		print 'Inserting Data into : silver.crm_Sales_details';
		INSERT INTO Silver.crm_Sales_details (
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price
		)
		select 
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			case when sls_order_dt = 0 or LEN(sls_order_dt) != 8 then null
				 else cast( CAST(sls_order_dt as varchar) as date)
			end sls_order_dt,

			case when sls_ship_dt = 0  or LEN(sls_ship_dt) != 8 then null
				 else cast (cast(sls_ship_dt as varchar) as date)
			end sls_ship_dt,

			case when sls_due_dt = 0 or LEN(sls_due_dt) !=8 then null
				 else CAST(CAST(sls_due_dt as varchar) as date)
			end sls_due_dt,
	
			case when sls_sales is null or sls_sales <= 0 or sls_sales != sls_quantity * ABS(sls_price )
						then sls_quantity * ABS(sls_price)
					else sls_sales
			end AS sls_sales,
			sls_quantity,
			case when sls_price IS NULL OR sls_price <= 0 
					THEN sls_sales/NULLIF(sls_quantity,0)
				ELSE sls_price
			END AS sls_price
		from Bronze.crm_Sales_details
		print 'silver.crm_Sales_details Inserted Sucessfully ';

		set @endtime = GETDATE();
		print 'Time Duration : '+cast(datediff(second , @starttime , @endtime)as nvarchar)+'Seconds';
		print ' ';
		-------------------------------------------------------------------------------
		/*
		===============================================================================
		4 : Loading Data: Bronze Layer → Silver Layer : silver.erp_CUST_AZ12
		===============================================================================
		*/
		print '-----------------------------------------';
		print '			 Loading ERP Tables			';
		print '-----------------------------------------';

		set @starttime = GETDATE();
		print 'Truncating Table : silver.erp_CUST_AZ12';

		Truncate table silver.erp_CUST_AZ12;
		print 'Bronze Layer --> Silver Layer';
		print 'Inserting Data into : silver.erp_CUST_AZ12';
		insert into Silver.erp_CUST_AZ12(
		CID,
		BDATE,
		GEN
		)
		select 
			case when CID like 'NAS%' THEN SUBSTRING(CID , 4 , LEN(CID))
				ELSE CID
			END CID,
			case when BDATE > GETDATE() then NULL
				else BDATE
			end BDATE,
			case when UPPER(TRIM(GEN)) in ('F' , 'Female') then 'Female'
			when UPPER(TRIM(GEN)) in ('M' , 'Male') then 'Male'
				ELSE 'N\A'
			END GEN
		from Bronze.erp_CUST_AZ12
		print 'silver.erp_CUST_AZ12 Inserted Sucessfully '; 

		set @endtime = GETDATE();
		print 'Time Duration : '+cast(datediff(second , @starttime , @endtime ) as nvarchar)+'Seconds';
		print ' ';
		-------------------------------------------------------------------------------
		/*
		===============================================================================
		5 : Loading Data: Bronze Layer → Silver Layer : silver.erp_LOC_A101
		===============================================================================
		*/
		set @starttime = GETDATE();
		print 'Truncating Table : silver.erp_LOC_A101';
		Truncate table silver.erp_LOC_A101;

		print 'Bronze Layer --> Silver Layer' ;
		print 'Inserting Data into : silver.erp_LOC_A101';
		INSERT INTO Silver.erp_LOC_A101(
		CID,
		CNTRY
		)
		select 
		 replace( CID , '-' , '') cid,
		 case when TRIM(CNTRY) = 'DE' THEN  'Germany'
			WHEN TRIM(CNTRY) IN ('US', 'USA') THEN 'United States'
			WHEN TRIM(CNTRY) = '' OR CNTRY IS NULL THEN 'N\A'
			ELSE trim(CNTRY)
		END CNTRY
		from Bronze.erp_LOC_A101
		print 'silver.erp_LOC_A101 Inserted Sucessfully ';

		set @endtime = GETDATE();
		print'Time Duration : '+cast(datediff(second , @starttime , @endtime ) as nvarchar)+'Seconds';
		print '  ' ;
		-------------------------------------------------------------------------------
		/*
		===============================================================================
		6 : Loading Data: Bronze Layer → Silver Layer : silver.erp_PX_CAT_G1V2
		===============================================================================
		*/
		set @starttime = GETDATE();
		print 'Truncating Table : silver.erp_PX_CAT_G1V2';

		Truncate table silver.erp_PX_CAT_G1V2;
		print 'Bronze Layer --> Silver Layer';
		print 'Inserting Data into : silver.erp_PX_CAT_G1V2';
		insert into Silver.erp_PX_CAT_G1V2(
			ID,
			CAT,
			SUBCAT,
			MAINTENANCE
		)
		select 
			ID,
			trim(CAT),
			trim(SUBCAT),
			MAINTENANCE
		from Bronze.erp_PX_CAT_G1V2
		print 'silver.erp_PX_CAT_G1V2 Inserted Sucessfully ';

		set @endtime = GETDATE();
		print 'Time Duration : '+cast(datediff(second , @starttime , @endtime ) as nvarchar)+'Seconds';
		print '  ';
	END try

	Begin catch 
		print 'Error Occured During Inserting into silver layer '
		print 'Error Message : '+error_message();
		print 'Error Number : '+cast(error_number() as nvarchar);
		print 'Error State : '+cast(error_state() as nvarchar);
		print '========================================'
	End catch 

END
set @endProcedureTime = GETDATE();
print ' Stored Procedure Time Duration : '+cast(datediff(second , @startProcedureTime , @endProcedureTime) as Nvarchar) +'Seconds';
print 'Task Completed Sliver Tables are Inserted Sucessfully';



--exec Silver.load_silver;


