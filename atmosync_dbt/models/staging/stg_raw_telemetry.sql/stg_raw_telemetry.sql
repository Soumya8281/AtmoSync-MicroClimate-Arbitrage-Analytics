/*
    Staging Model: stg_raw_telemetry
    Description: Cleanses, casts, and prepares raw container IoT telemetry data from Snowflake.
    Source: RAW.RAW_TELEMETRY
*/

WITH source_data AS (

    -- Extract raw IoT telemetry records from the source table
    SELECT
        CONTAINER_ID,
        EVENT_TIME,
        TEMPERATURE,
        HUMIDITY,
        VIBRATION
    FROM {{ source('RAW', 'RAW_TELEMETRY') }}

),

renamed_and_casted AS (

    -- Perform explicit type casting and standardize data types
    SELECT
        CAST(CONTAINER_ID AS VARCHAR)       AS CONTAINER_ID,
        CAST(EVENT_TIME AS TIMESTAMP_NTZ)   AS EVENT_TIME,
        CAST(TEMPERATURE AS FLOAT)          AS TEMPERATURE,
        CAST(HUMIDITY AS FLOAT)             AS HUMIDITY,
        CAST(VIBRATION AS FLOAT)            AS VIBRATION
    FROM source_data

)

-- Output cleansed staging dataset
SELECT
    CONTAINER_ID,
    EVENT_TIME,
    TEMPERATURE,
    HUMIDITY,
    VIBRATION
FROM renamed_and_casted