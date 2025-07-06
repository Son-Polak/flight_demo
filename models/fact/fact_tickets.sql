{{
  config(
    unique_key = 'book_ref',
    )
}}

select 
	t.ticket_no 
	, t.book_ref 
	, t.passenger_id 
	, t.passenger_name 
	, t.contact_data 
	, t.contact_data ->> 'email' as Emai
	, t.contact_data ->> 'phone' as Phone
	, t.last_update 
	, b.book_date 
	, b.total_amount 
    , '{{ run_started_at }}' :: timestamp as etl_time
from {{ source('stg', 'tickets') }} as t 
left join {{ source('stg', 'bookings') }} as b  on t.book_ref =b.book_ref 
{% if is_incremental() %}
where last_update > coalesce(
							(select max(last_update) from {{ this }}),
							'1900-01-01'
)
{% endif %}
