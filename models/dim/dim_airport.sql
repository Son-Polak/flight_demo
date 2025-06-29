{{
  config(
    unique_key = 'airport_code',
    )
}}

select 
	ad.*
	, airport_name ->> 'en' as airport_name_en
	, airport_name ->> 'ru' as airport_name_ru
	, city ->> 'en' as city_en
	, city ->> 'ru' as city_ru
  , '{{ run_started_at }}' :: timestamp as etl_time
from {{ source('stg', 'airports_data') }} as ad 
