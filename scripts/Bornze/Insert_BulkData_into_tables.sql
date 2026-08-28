
/*

1: Bulk insert :
	it is used to insert the large Number of data in to tables  at same time.
	if we run the bulk insert twice the data also will be inserted again
	to over come this problem we use the truncate command

	SYNTAX :
		Bulk insert table name
		from (location of the file and at last \file name.file type)
		with(
			fristrow = number value (firstrow means from where the actual data started without headers ,
										we should give any number from where the actual data will start)
			
			fieldterminator = ','  (the common supparator wit may be 'comma(,) or pipe(|) or dash(-) )and etc.....'
			tablock  (the shared lock is applied to the entire table instead of at the row or page level)
		)


2: Truncate table (table_name) ; to over come the problem of bule entry in twise thi truncate will be detete the old data and insert new data

NOTE : We should run both the querys like truncate and bulk insert at once  

	to get the new data every time to refresh the data we will be creating the stored procedure
*/


create or alter procedure bronze.load_bronze as
declare @starting_time datetime , @ending_time datetime;
set @starting_time = GETDATE();
begin
	Declare @start_time datetime , @end_time datetime;
	BEGIN TRY
		print'=====================================';
		print '        Loading Bronze Layer       ';
		print'=====================================';

		print'=====================================';
		print'         Loating CRM Tables          ';
		print'=====================================';

		set @start_time = getdate();
		print '>> Truncating Table : bronze.crm_cust_info';
		Truncate table bronze.crm_cust_info; 

		--Table 1
		print '>>Inserting Table : bronze.crm_cust_info';
		bulk insert bronze.crm_cust_info
		from 'D:\sql\66d6e2d390db480c9a4d86b5222aa88b\sql-ultimate-course-main\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with (
			firstrow = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_time = getdate();
		print'Time Duration : '+cast(datediff(second, @start_time , @end_time)as nvarchar)+ 'seconds';
		print'----------------------------------';

		--Table 2
		set @start_time = GETDATE();
		print '>> Truncating Table : bronze.crm_prd_info';
		truncate table bronze.crm_prd_info;
	
		print '>>Inserting Table : bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'D:\sql\66d6e2d390db480c9a4d86b5222aa88b\sql-ultimate-course-main\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		print'Time Duration : ' + cast (datediff(second , @start_time , @end_time) as nvarchar) +' seconds'


		--Table 3
		set @start_time = GETDATE();
		print '>> Truncating Table : bronze.crm_Sales_details';
		Truncate table bronze.crm_Sales_details;

		print '>>Inserting Table : bronze.crm_Sales_details';
		bulk Insert bronze.crm_Sales_details
		from 'D:\sql\66d6e2d390db480c9a4d86b5222aa88b\sql-ultimate-course-main\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		print'Time Duration : '+ cast(datediff(second ,@start_time, @end_time) as Nvarchar)+'seconds'



		print'=====================================';
		print'        Loating ERP Tables           ';
		print'=====================================';

		--Table 4
		set @start_time = GETDATE();
		print '>> Truncating Table : bronze.erp_CUST_AZ12';
		Truncate table bronze.erp_CUST_AZ12

		print '>>Inserting Table : bronze.erp_CUST_AZ12';
		bulk Insert bronze.erp_CUST_AZ12
		from 'D:\sql\66d6e2d390db480c9a4d86b5222aa88b\sql-ultimate-course-main\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		print'Time Duration : '+cast(datediff(second , @start_time, @end_time) as Nvarchar)+'seconds'


		--Table 5
		set @start_time = GETDATE();
		print '>> Truncating Table : bronze.erp_LOC_A101';
		Truncate table bronze.erp_LOC_A101

		print '>>Inserting Table : bronze.erp_LOC_A101';
		bulk Insert bronze.erp_LOC_A101
		from 'D:\sql\66d6e2d390db480c9a4d86b5222aa88b\sql-ultimate-course-main\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @start_time = GETDATE();
		print'Time Duration : '+cast(datediff(second , @start_time,@start_time) as Nvarchar) +'seconds'



		--Table 6
		set @start_time = GETDATE();
		print '>> Truncating Table : bronze.erp_PX_CAT_G1V2';
		Truncate table bronze.erp_PX_CAT_G1V2

		print '>>Inserting Table : bronze.erp_PX_CAT_G1V2';
		bulk Insert bronze.erp_PX_CAT_G1V2
		from 'D:\sql\66d6e2d390db480c9a4d86b5222aa88b\sql-ultimate-course-main\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		with(
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @start_time = GETDATE();
		print'Time Duration : '+cast(datediff(second , @start_time,@start_time) as Nvarchar) +'seconds'
	
	END TRY
	BEGIN CATCH
		print'=====================================';
		PRINT 'Error Massage :'+ error_message();
		print 'Error Number :'+cast (error_number() as nvarchar);
		print 'Error State :'+ cast(error_state() as nvarchar);
		print'=====================================';

	END CATCH

end

set @ending_time = GETDATE();
print'===========================================================';
print'Total Stored Procedure time Duration : '+ cast(datediff(second , @starting_time , @ending_time) as nvarchar)+'Seconds'
Print'---Task Completed All tables are Updated---'
print'===========================================================';


