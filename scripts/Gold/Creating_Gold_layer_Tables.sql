
create or alter view gold.dim_customers as (
select 
	ROW_NUMBER() over(order by cst_id) as customer_Key,
	ci.cst_id as customer_Id,
	ci.cst_key as customer_Number,
	ci.cst_firstname as first_name,
	ci.cst_lastname as last_name,
	loc.CNTRY as country,
	ci.cst_marital_status as marital_status,
	CASE
        WHEN (ci.cst_gndr IS NULL OR ci.cst_gndr = 'N\A')
             AND (ca.GEN IS NULL OR ca.GEN = 'N\A')
            THEN 'N\A'

        WHEN ci.cst_gndr IS NULL OR ci.cst_gndr = 'N\A'
            THEN ca.GEN

        WHEN ca.GEN IS NULL OR ca.GEN = 'N\A'
            THEN ci.cst_gndr

        ELSE ci.cst_gndr
    END AS gender,
	ca.BDATE as birthDate,
	ci.cst_create_date as create_date
from Silver.crm_cust_info ci 
left join Silver.erp_CUST_AZ12 ca
on ci.cst_key =  ca.CID
left join Silver.erp_LOC_A101 loc
on ci.cst_key = loc.CID
)



create or alter view gold.dim_products as (
select 
	ROW_NUMBER() over (order by pr.prd_start_dt , pr.prd_key) as product_Key,
	pr.prd_id as product_Id,
	pr.prd_key as product_number,
	pr.prd_nm as product_name,
	pr.cat_id as category_id,
	pc.CAT as category,
	pc.SUBCAT as sub_category,
	pc.MAINTENANCE as maintence,
	pr.prd_cost as product_cost,
	pr.prd_line as product_line,
	pr.prd_start_dt as start_Date
from Silver.crm_prd_info pr
left join Silver.erp_PX_CAT_G1V2 pc
	on pr.cat_id = pc.ID
where prd_end_dt is null 
)

create view gold.fact_sales as (
select
	sd.sls_ord_num as order_number,
	pr.product_Key,
	cu.customer_Key,
	sd.sls_order_dt as order_date,
	sd.sls_ship_dt as shipping_date,
	sd.sls_due_dt as due_date,
	sd.sls_sales as sales_amount,
	sd.sls_quantity as quantity,
	sd.sls_price as price
from Silver.crm_Sales_details sd
left join Gold.dim_products pr
on sd.sls_prd_key = pr.product_number
left join Gold.dim_customers cu
on sd.sls_cust_id = cu.customer_Id
)



