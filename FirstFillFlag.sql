select 
distinct pbr_npi_id as ProviderID,
cast("drug101" as string) as ProductID,
next_day(current_date(), 'SUN') as TimeBucketDate,
'WEEK' as TimeGrain, 
'FirstFillFlag' as MetricName,
1 as MetricValue
from claims_data 
where 
AND upper(first_fill_flag) in ('Y')
and data_week =  next_day(current_date(), 'SUN')