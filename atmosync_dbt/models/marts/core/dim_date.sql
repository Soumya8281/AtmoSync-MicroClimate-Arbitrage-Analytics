/*
    Dimensional Model: dim_date
    Description: Date dimension table derived from telemetry event dates for time-series analysis.
    Grain: One record per DATE_KEY.
    Upstream: int_telemetry_enriched
*/

WITH distinct_dates AS (

    SELECT DISTINCT
        EVENT_DATE
    FROM {{ ref('int_telemetry_enriched') }}
    WHERE EVENT_DATE IS NOT NULL

),

date_dimension AS (

    SELECT
        EVENT_DATE                             AS DATE_KEY,
        EXTRACT(YEAR FROM EVENT_DATE)          AS YEAR,
        EXTRACT(QUARTER FROM EVENT_DATE)       AS QUARTER,
        EXTRACT(MONTH FROM EVENT_DATE)         AS MONTH,
        MONTHNAME(EVENT_DATE)                  AS MONTH_NAME,
        EXTRACT(WEEK FROM EVENT_DATE)          AS WEEK,
        EXTRACT(DAY FROM EVENT_DATE)           AS DAY_OF_MONTH,
        DAYNAME(EVENT_DATE)                    AS WEEKDAY_NAME,
        CASE
            WHEN DAYNAME(EVENT_DATE) IN ('Sat', 'Sun') THEN TRUE
            ELSE FALSE
        END AS IS_WEEKEND
    FROM distinct_dates

)

SELECT
    DATE_KEY,
    YEAR,
    QUARTER,
    MONTH,
    MONTH_NAME,
    WEEK,
    DAY_OF_MONTH,
    WEEKDAY_NAME,
    IS_WEEKEND
FROM date_dimension
