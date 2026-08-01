/*
    Custom Test: assert_telemetry_timestamps_not_in_future
    Business Rule: Telemetry event timestamps must not be recorded in the future.
    Returns: Records where EVENT_TIMESTAMP > CURRENT_TIMESTAMP().
*/

SELECT
    CONTAINER_ID,
    EVENT_TIMESTAMP
FROM {{ ref('fct_telemetry') }}
WHERE EVENT_TIMESTAMP > CURRENT_TIMESTAMP()
