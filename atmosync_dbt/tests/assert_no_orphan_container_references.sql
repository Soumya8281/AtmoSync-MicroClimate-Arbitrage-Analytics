/*
    Custom Test: assert_no_orphan_container_references
    Business Rule: All container references in fct_telemetry must exist in dim_container.
    Returns: Records in fct_telemetry whose CONTAINER_ID is missing from dim_container.
*/

SELECT
    f.TELEMETRY_KEY,
    f.CONTAINER_ID
FROM {{ ref('fct_telemetry') }} f
LEFT JOIN {{ ref('dim_container') }} c
    ON f.CONTAINER_ID = c.CONTAINER_ID
WHERE c.CONTAINER_ID IS NULL
