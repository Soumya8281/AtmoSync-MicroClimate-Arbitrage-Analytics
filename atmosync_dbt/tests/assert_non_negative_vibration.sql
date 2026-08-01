/*
    Custom Test: assert_non_negative_vibration
    Business Rule: Vibration readings cannot be negative values.
    Returns: Records where VIBRATION < 0.
*/

SELECT
    TELEMETRY_KEY,
    CONTAINER_ID,
    VIBRATION
FROM {{ ref('fct_telemetry') }}
WHERE VIBRATION < 0
