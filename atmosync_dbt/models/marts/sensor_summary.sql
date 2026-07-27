SELECT
    commodity,
    origin,
    destination,
    COUNT(*) AS total_shipments,
    ROUND(AVG(temperature), 2) AS avg_temperature,
    ROUND(AVG(humidity), 2) AS avg_humidity,
    ROUND(AVG(vibration), 2) AS avg_vibration,
    ROUND(AVG(weight_kg), 2) AS avg_weight
FROM {{ ref('stg_sensor_data') }}
GROUP BY
    commodity,
    origin,
    destination