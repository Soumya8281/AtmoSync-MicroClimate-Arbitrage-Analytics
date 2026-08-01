/*
    Fact Model: fct_telemetry
    Description: Fact table containing individual IoT container telemetry events and metrics.
    Grain: One record per telemetry event.
    Upstream: int_telemetry_enriched
*/

WITH telemetry AS (

    SELECT
        CONTAINER_ID,
        EVENT_TIMESTAMP,
        EVENT_DATE,
        TEMPERATURE_CELSIUS,
        HUMIDITY_PERCENTAGE,
        VIBRATION_LEVEL,
        IS_TEMPERATURE_ANOMALY,
        IS_HUMIDITY_ANOMALY,
        IS_VIBRATION_ANOMALY,
        ANOMALY_FLAG
    FROM {{ ref('int_telemetry_enriched') }}

),

fact_table AS (

    SELECT
        -- Deterministic surrogate key using MD5 hash of natural key attributes
        MD5(CONCAT(COALESCE(CAST(CONTAINER_ID AS VARCHAR), ''), '_', COALESCE(CAST(EVENT_TIMESTAMP AS VARCHAR), ''))) AS TELEMETRY_KEY,
        CONTAINER_ID,
        EVENT_TIMESTAMP,
        EVENT_DATE                              AS DATE_KEY,
        TEMPERATURE_CELSIUS                    AS TEMPERATURE,
        HUMIDITY_PERCENTAGE                    AS HUMIDITY,
        VIBRATION_LEVEL                        AS VIBRATION,
        IS_TEMPERATURE_ANOMALY,
        IS_HUMIDITY_ANOMALY,
        IS_VIBRATION_ANOMALY,
        ANOMALY_FLAG
    FROM telemetry

)

SELECT
    TELEMETRY_KEY,
    CONTAINER_ID,
    EVENT_TIMESTAMP,
    DATE_KEY,
    TEMPERATURE,
    HUMIDITY,
    VIBRATION,
    IS_TEMPERATURE_ANOMALY,
    IS_HUMIDITY_ANOMALY,
    IS_VIBRATION_ANOMALY,
    ANOMALY_FLAG
FROM fact_table
