select mt2.npi_id as ProviderID,
cast("drug101" as string) as ProductID, 
next_day(current_date(), 'SUN') as TimeBucketDate,
'WEEK' as time_grain, 'zero_fills_prior_month' as MetricName,
1 as MetricValue 
from master_tag mt2 left join 
( 
select SUM(j.rxs_sum) as rxs_sum, j.account_id as account_id from 
( 
	select upper(mt.account_name) as account_name, mt.account_id as account_id, cd.pbr_npi_id as pbr_npi_id, cd.rxs_sum as rxs_sum 
	from claims_data cd right join master_tag mt on mt.npi_id = cd.pbr_npi_id 
	where cd.data_week >= date_sub( next_day(current_date(), 'SUN'), 28) 
)j group by j.account_id 
)t on mt2.account_id = t.account_id 
where t.rxs_sum is null