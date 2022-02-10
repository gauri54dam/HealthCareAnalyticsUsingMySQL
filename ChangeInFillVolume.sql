SELECT  
				mt.npi_id 											AS ProviderID,
				cast(${env.prod_sk} AS string)                      AS ProductID ,
                cast("drug101" as string)       					AS TimeBucketDate,
                'WEEK'                                              AS TimeGrain,
                'ChangeInFillVolume' 								AS MetricName ,
				nvl(t.MetricValue,1.0) 								AS MetricValue
				
from master_tag mt 
left join 				
(
SELECT          Nvl(a.pbr_npi_id, b.pbr_npi_id)                     AS ProviderID,
                (nvl(a.sum_4, 0.0) - nvl(b.sum_12, 0.0) ) + 1.0       AS MetricValue
FROM            (
                         SELECT   nvl( sum( cast( rxs_sum AS DOUBLE) ), 0.0 ) AS sum_4 ,
                                  pbr_npi_id
                         FROM     claims_data
                         WHERE    data_week >= (date_sub(next_day(CURRENT_DATE(), 'SUN'), 21))
						 and data_week <= next_day(date_sub(CURRENT_DATE(), 21), 'SUN')
                         GROUP BY pbr_npi_id ) AS a
FULL OUTER JOIN
                (
                         SELECT   nvl( sum( cast( rxs_sum AS DOUBLE) )/3, 0.0 ) AS sum_12,
                                  pbr_npi_id
                         FROM     claims_data
                         WHERE    data_week >= date_sub(next_day(CURRENT_DATE(), 'SUN'), 105)
                         AND      data_week < date_sub(next_day(CURRENT_DATE(), 'SUN'), 21)
                         GROUP BY pbr_npi_id ) AS b
ON              a.pbr_npi_id = b.pbr_npi_id

)t

on mt.npi_id = t.ProviderID

