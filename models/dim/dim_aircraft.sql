{{
  config(
    unique_key = 'aircraft_code',
    )
}}

select 
	ad.aircraft_code 
	, ad.model
	, ad.model ->> 'en' as Model_english
	, ad.model ->> 'ru' as Model_Russian
	, ad."range" 
	, case 
		when ad."range" > 5600 then 'high'
		else 'low'
	end	as range_hl
	, ad.last_update as ad_last_update
	, s.seat_no 
	, s.fare_conditions 
    , '{{ run_started_at }}' :: timestamp as etl_time
from {{ source('stg', 'aircrafts_data') }} as ad 
left join {{ source('stg', 'seats') }} as s on ad.aircraft_code = s.aircraft_code 