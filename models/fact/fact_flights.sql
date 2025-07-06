{{
  config(
    uniqe_key = 'flight_id',
    )
}}

select *
	, case 
		when flight_duration_expected > flight_duration then 'longer'
		when flight_duration_expected < flight_duration then 'shorter'
		when flight_duration_expected = flight_duration then 'as expected'		
	end	as expedted_vs_actual
    , '{{ run_started_at }}' :: timestamp as etl_time
from (
	select f.*
		, round(extract(epoch from (actual_arrival - actual_departure))/60/60,2) as flight_duration
		, round(extract(epoch from (scheduled_arrival - scheduled_departure))/60/60,2) as flight_duration_expected
	from {{ source('stg', 'flights') }} as f
)