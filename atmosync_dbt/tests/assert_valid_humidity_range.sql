/*
    Custom Test: assert_valid_humidity_range
    Business Rule: Relative humidity percentage readings must fall within 0% and 100%.
    Returns: Records where HUMIDITY < 0 OR HUMIDITY > 100.
*/

SELECT
    TELEMETRY_KEY,
    CONTAINER_ID,
    HUMIDITY
FROM {{ ref('fct_telemetry') }}
WHERE HUMIDITY < 0.0 OR HUMIDITY > 100.0
