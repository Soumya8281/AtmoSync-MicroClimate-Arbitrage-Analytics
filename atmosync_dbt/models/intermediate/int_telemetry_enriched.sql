/*
    Intermediate Model: int_telemetry_enriched
    Description: Enriches raw telemetry staging records with temporal dimensions, metric aliases,
                 and threshold-based environmental anomaly flags.
    Upstream: stg_raw_telemetry
*/

WITH staging AS (

    -- Import cleansed staging telemetry records
    SELECT
        CONTAINER_ID,
        EVENT_TIME,
        TEMPERATURE,
        HUMIDITY,
        VIBRATION
    FROM {{ ref('stg_raw_telemetry') }}

),

time_dimensions AS (

    -- Derive temporal granularities for time-series aggregation
    SELECT
        CONTAINER_ID,
        EVENT_TIME                             AS EVENT_TIMESTAMP,
        CAST(EVENT_TIME AS DATE)              AS EVENT_DATE,
        EXTRACT(HOUR FROM EVENT_TIME)         AS EVENT_HOUR,
        TEMPERATURE                           AS TEMPERATURE_CELSIUS,
        HUMIDITY                              AS HUMIDITY_PERCENTAGE,
        VIBRATION                             AS VIBRATION_LEVEL
    FROM staging

),

anomaly_detection AS (

    -- Evaluate threshold-based environmental anomaly flags
    SELECT
        CONTAINER_ID,
        EVENT_TIMESTAMP,
        EVENT_DATE,
        EVENT_HOUR,
        TEMPERATURE_CELSIUS,
        HUMIDITY_PERCENTAGE,
        VIBRATION_LEVEL,

        -- Individual threshold anomaly indicators
        CASE
            WHEN TEMPERATURE_CELSIUS < -20.0 OR TEMPERATURE_CELSIUS > 50.0 THEN TRUE
            ELSE FALSE
        END AS IS_TEMPERATURE_ANOMALY,

        CASE
            WHEN HUMIDITY_PERCENTAGE < 10.0 OR HUMIDITY_PERCENTAGE > 90.0 THEN TRUE
            ELSE FALSE
        END AS IS_HUMIDITY_ANOMALY,

        CASE
            WHEN VIBRATION_LEVEL > 8.0 THEN TRUE
            ELSE FALSE
        END AS IS_VIBRATION_ANOMALY,

        -- Overall anomaly classification flag
        CASE
            WHEN (TEMPERATURE_CELSIUS < -20.0 OR TEMPERATURE_CELSIUS > 50.0)
              OR (HUMIDITY_PERCENTAGE < 10.0 OR HUMIDITY_PERCENTAGE > 90.0)
              OR (VIBRATION_LEVEL > 8.0) THEN 'ANOMALY_DETECTED'
            ELSE 'NORMAL'
        END AS ANOMALY_FLAG

    FROM time_dimensions

)

-- Final transformed intermediate output
SELECT
    CONTAINER_ID,
    EVENT_TIMESTAMP,
    EVENT_DATE,
    EVENT_HOUR,
    TEMPERATURE_CELSIUS,
    HUMIDITY_PERCENTAGE,
    VIBRATION_LEVEL,
    IS_TEMPERATURE_ANOMALY,
    IS_HUMIDITY_ANOMALY,
    IS_VIBRATION_ANOMALY,
    ANOMALY_FLAG
FROM anomaly_detection
