select a.pbr_npi_id as ProviderID,  
cast("drug101" as string) as ProductID,
next_day(current_date(), 'SUN') as TimeBucketDate,
'WEEK' as TimeGrain, 
'NewNpi' as MetricName,
1 as MetricValue
from claims_data a
left join
(
SELECT distinct pbr_npi_id
FROM claims_data b 
where data_week >= date_sub(next_day(current_date(), 'SUN'), 357)
and data_week < next_day(current_date(),'SUN') 
)t
on a.pbr_npi_id = t.pbr_npi_id
where t.pbr_npi_id is NULL
and a.data_week  >= next_day(current_date(), 'SUN')