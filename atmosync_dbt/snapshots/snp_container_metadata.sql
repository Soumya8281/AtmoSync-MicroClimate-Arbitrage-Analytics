{% snapshot snp_container_metadata %}

{{
    config(
      target_database='ATMOSYNC_DB',
      target_schema='SNAPSHOTS',
      unique_key='CONTAINER_ID',
      strategy='check',
      check_cols=['AVERAGE_TEMPERATURE', 'AVERAGE_HUMIDITY', 'MAXIMUM_VIBRATION'],
      invalidate_hard_deletes=True
    )
}}

/*
    Snapshot: snp_container_metadata
    Description: Type 2 Slowly Changing Dimension (SCD Type 2) tracking historical state changes
                 in container operational status and environmental metrics over time.
    Strategy: check (evaluates changes across key aggregated metrics)
*/

SELECT
    CONTAINER_ID,
    FIRST_EVENT_TIME,
    LAST_EVENT_TIME,
    TOTAL_EVENTS,
    AVERAGE_TEMPERATURE,
    AVERAGE_HUMIDITY,
    MAXIMUM_VIBRATION
FROM {{ ref('dim_container') }}

{% endsnapshot %}
