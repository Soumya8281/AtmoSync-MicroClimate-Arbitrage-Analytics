/*
    Dimensional Model: dim_container
    Description: Dimension table representing storage containers and their aggregated telemetry metrics.
    Grain: One record per CONTAINER_ID.
    Upstream: int_telemetry_enriched
*/

WITH telemetry AS (

    SELECT
        CONTAINER_ID,
        EVENT_TIMESTAMP,
        TEMPERATURE_CELSIUS,
        HUMIDITY_PERCENTAGE,
        VIBRATION_LEVEL
    FROM {{ ref('int_telemetry_enriched') }}

),

aggregated AS (

    SELECT
        CONTAINER_ID,
        MIN(EVENT_TIMESTAMP)                    AS FIRST_EVENT_TIME,
        MAX(EVENT_TIMESTAMP)                    AS LAST_EVENT_TIME,
        COUNT(*)                                AS TOTAL_EVENTS,
        ROUND(AVG(TEMPERATURE_CELSIUS), 2)     AS AVERAGE_TEMPERATURE,
        ROUND(AVG(HUMIDITY_PERCENTAGE), 2)      AS AVERAGE_HUMIDITY,
        MAX(VIBRATION_LEVEL)                    AS MAXIMUM_VIBRATION
    FROM telemetry
    GROUP BY CONTAINER_ID

)

SELECT
    CONTAINER_ID,
    FIRST_EVENT_TIME,
    LAST_EVENT_TIME,
    TOTAL_EVENTS,
    AVERAGE_TEMPERATURE,
    AVERAGE_HUMIDITY,
    MAXIMUM_VIBRATION
FROM aggregated
