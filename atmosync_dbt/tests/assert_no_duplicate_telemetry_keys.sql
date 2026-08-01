/*
    Custom Test: assert_no_duplicate_telemetry_keys
    Business Rule: TELEMETRY_KEY surrogate keys in fct_telemetry must be strictly unique.
    Returns: Telemetry surrogate keys that occur more than once.
*/

SELECT
    TELEMETRY_KEY,
    COUNT(*) AS KEY_COUNT
FROM {{ ref('fct_telemetry') }}
GROUP BY TELEMETRY_KEY
HAVING COUNT(*) > 1
