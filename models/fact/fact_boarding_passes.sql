{{
  config(
    uniqe_key = 'ticket_no',
    )
}}

select 
    tf.ticket_no
    , tf.flight_id
    , tf.fare_conditions
    , tf.amount
    , bp.boarding_no
    , bp.seat_no
    , tf.last_update
    , '{{ run_started_at }}' :: timestamp as etl_time
from {{ source('stg', 'ticket_flights') }} as tf 
left join {{ source('stg', 'boarding_passes') }} as bp on
	tf.ticket_no = bp.ticket_no AND tf.flight_id = bp.flight_id
{% if is_incremental() %}
where tf.last_update > coalesce(
                                (select max(last_update) from {{ this }}),
                                '1900-01-01'
)
{% endif %}