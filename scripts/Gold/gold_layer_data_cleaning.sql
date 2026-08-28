
select 
	ci.cst_gndr,
	ca.GEN,
	CASE
        WHEN (ci.cst_gndr IS NULL OR ci.cst_gndr = 'N/A')
             AND (ca.GEN IS NULL OR ca.GEN = 'N/A')
            THEN 'N/A'

        WHEN ci.cst_gndr IS NULL OR ci.cst_gndr = 'N/A'
            THEN ca.GEN

        WHEN ca.GEN IS NULL OR ca.GEN = 'N/A'
            THEN ci.cst_gndr

        ELSE ci.cst_gndr
    END AS new_gender
from Silver.crm_cust_info ci
left join Silver.erp_CUST_AZ12 ca
on ci.cst_key =  ca.CID
left join Silver.erp_LOC_A101 loc
on ci.cst_key = loc.CID
where ci.cst_gndr is null or ci.cst_gndr = 'N/A' or ca.GEN is null OR ca.GEN = 'N/A'



select *
from Silver.crm_cust_info
where cst_id = 11162

select *
from Silver.erp_CUST_AZ12
where CID = 'AW00011162'



SELECT
    ci.cst_id,
    ci.cst_key,
    ci.cst_gndr,
    ca.CID,
    ca.GEN
FROM Silver.crm_cust_info ci
LEFT JOIN Silver.erp_CUST_AZ12 ca
    ON ci.cst_key = ca.CID
WHERE ci.cst_id = 11162;

SELECT 
    ci.cst_id,
    ci.cst_key,
    LEN(ci.cst_key) AS len_cst_key,
    ca.CID,
    LEN(ca.CID) AS len_CID,
    ca.GEN
FROM Silver.crm_cust_info ci
LEFT JOIN Silver.erp_CUST_AZ12 ca
    ON ci.cst_key = ca.CID
WHERE ci.cst_id = 11162

SELECT ci.cst_id, ci.cst_key, DATALENGTH(ci.cst_key) AS bytes_cst_key,
       ca.CID, DATALENGTH(ca.CID) AS bytes_cid
FROM Silver.crm_cust_info ci
LEFT JOIN Silver.erp_CUST_AZ12 ca ON ci.cst_key = ca.CID
WHERE ci.cst_id = 11162;



select 
    ci.cst_id,
    ci.cst_gndr,
    ca.GEN,
    CASE
        WHEN (ci.cst_gndr IS NULL OR ci.cst_gndr = 'N/A')
             AND (ca.GEN IS NULL OR ca.GEN = 'N/A')
            THEN 'N/A'
        WHEN ci.cst_gndr IS NULL OR ci.cst_gndr = 'N/A'
            THEN ca.GEN
        WHEN ca.GEN IS NULL OR ca.GEN = 'N/A'
            THEN ci.cst_gndr
        ELSE ci.cst_gndr
    END AS new_gender
from Silver.crm_cust_info ci
left join Silver.erp_CUST_AZ12 ca
    on ci.cst_key = ca.CID
where ci.cst_id = 11162;



SELECT cst_gndr, COUNT(*) AS row_count
FROM Silver.crm_cust_info
GROUP BY cst_gndr;

SELECT GEN, COUNT(*) AS row_count
FROM Silver.erp_CUST_AZ12
GROUP BY GEN;

SELECT 
    ci.cst_id,
    ci.cst_key,
    ci.cst_gndr,
    ca.CID,
    ca.GEN,
    CASE 
        WHEN ca.CID IS NULL 
            THEN 'Join failed - no matching CID in erp_CUST_AZ12'
        WHEN (ci.cst_gndr IS NULL OR ci.cst_gndr = 'N\A')
             AND (ca.GEN IS NULL OR ca.GEN = 'N\A')
            THEN 'Matched, but both source values are N\A'
        ELSE 'Should have resolved to a real value'
    END AS null_reason
FROM Silver.crm_cust_info ci
LEFT JOIN Silver.erp_CUST_AZ12 ca
    ON ci.cst_key = ca.CID
WHERE 
    (ci.cst_gndr IS NULL OR ci.cst_gndr = 'N\A')
    AND (ca.GEN IS NULL OR ca.GEN = 'N\A' OR ca.CID IS NULL)
ORDER BY null_reason;


SELECT 
    CASE 
        WHEN ca.CID IS NULL 
            THEN 'Join failed - no matching CID'
        WHEN (ci.cst_gndr IS NULL OR ci.cst_gndr = 'N\A')
             AND (ca.GEN IS NULL OR ca.GEN = 'N\A')
            THEN 'Both sources genuinely missing gender'
        ELSE 'Resolved correctly'
    END AS category,
    COUNT(*) AS row_count
FROM Silver.crm_cust_info ci
LEFT JOIN Silver.erp_CUST_AZ12 ca
    ON ci.cst_key = ca.CID
GROUP BY 
    CASE 
        WHEN ca.CID IS NULL 
            THEN 'Join failed - no matching CID'
        WHEN (ci.cst_gndr IS NULL OR ci.cst_gndr = 'N\A')
             AND (ca.GEN IS NULL OR ca.GEN = 'N\A')
            THEN 'Both sources genuinely missing gender'
        ELSE 'Resolved correctly'
    END;


    select 
        ci.cst_gndr,
        ca.GEN,
        case when  ci.cst_gndr != 'N\A' THEN ci.cst_gndr
            ELSE coalesce(ca.GEN , 'N\A')
        end as new_gender
    from Silver.crm_cust_info ci
    left join Silver.erp_CUST_AZ12 ca
    on ci.cst_key = ca.CID
    
select *
from (
select 
	ROW_NUMBER() over(order by cst_id) as customer_Key,
	ci.cst_id as customer_Id,
	ci.cst_key as customer_Number,
	ci.cst_firstname as first_name,
	ci.cst_lastname as last_name,
	loc.CNTRY as country,
	ci.cst_marital_status as marital_status,
	 case when  ci.cst_gndr != 'N\A' THEN ci.cst_gndr
            ELSE coalesce(ca.GEN , 'N\A')
     end as new_gender,
	ca.BDATE as birthDate,
	ci.cst_create_date as create_date
from Silver.crm_cust_info ci 
left join Silver.erp_CUST_AZ12 ca
on ci.cst_key =  ca.CID
left join Silver.erp_LOC_A101 loc
on ci.cst_key = loc.CID
)t
where new_gender = 'N\A' or new_gender = 'N\A'


select distinct *
from gold.dim_customers

select *
from gold.dim_products

select *
from Gold.fact_sales

select *
from Gold.fact_sales s
left join Gold.dim_customers c
on c.customer_Key = s.customer_Key
left join Gold.dim_products p
on p.product_Key = s.product_Key
where p.product_Key is null




