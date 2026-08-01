# AtmoSync dbt Data Transformation Pipeline

Welcome to the **AtmoSync** dbt repository. AtmoSync is an enterprise data engineering project designed to transform, clean, and model IoT telemetry data captured from atmospheric storage containers monitoring environmental metrics (temperature, humidity, vibration).

---

## 🏗️ Architecture Overview

The data architecture follows standard dbt dimensional modeling and Slowly Changing Dimension (SCD Type 2) principles:

```
[ Snowflake RAW Database ]
  └── ATMOSYNC_DB.RAW.RAW_TELEMETRY (Edge IoT Sensor Ingestion)
            │
            ▼
[ dbt Staging Layer ] (models/staging)
  └── stg_raw_telemetry (CTEs, Explicit Casting, Schema Quality Checks)
            │
            ▼
[ dbt Intermediate Layer ] (models/intermediate)
  └── int_telemetry_enriched (Time-series Granularities, Anomaly Flagging)
            │
            ├───────────────────────┬───────────────────────┐
            ▼                       ▼                       ▼
[ Analytics Mart Layer ] (models/marts/core)
  ├── dim_container        ├── dim_date            └── fct_telemetry
            │
            ▼
[ dbt Snapshot Layer ] (snapshots/)
  └── snp_container_metadata (SCD Type 2 Tracking via Check Strategy)
```

1. **Raw Ingestion Layer (Snowflake)**: Sensor metrics are continuously loaded into `ATMOSYNC_DB.RAW.RAW_TELEMETRY`.
2. **Staging Layer (`models/staging`)**: Standardizes schema types, cleans fields, performs explicit casting, and enforces data quality contracts without mutating underlying source business concepts.
3. **Intermediate Layer (`models/intermediate`)**: Encapsulates business logic, derives time-series granularities (`EVENT_DATE`, `EVENT_HOUR`), standardizes metric aliases, and evaluates threshold-based environmental anomaly flags.
4. **Analytics Mart Layer (`models/marts/core`)**: Dimensional star schema tailored for reporting and BI workloads:
   - **`dim_container`**: Container-level aggregates (lifetime events, avg temp/humidity, max vibration).
   - **`dim_date`**: Calendar date dimension for time-series slicing.
   - **`fct_telemetry`**: Telemetry fact table with deterministic surrogate keys and foreign keys.
5. **Snapshot Layer (`snapshots/`)**: Captures point-in-time state historical changes (SCD Type 2) for container operational state over time.

---

## 📸 Snapshot & SCD Type 2 Strategy

- **Target Snapshot**: `snp_container_metadata`
- **Target Database / Schema**: `ATMOSYNC_DB.SNAPSHOTS`
- **Unique Key**: `CONTAINER_ID`
- **Strategy**: `check` (monitors state changes across `AVERAGE_TEMPERATURE`, `AVERAGE_HUMIDITY`, `MAXIMUM_VIBRATION`)
- **Tracked Attributes**: Automatically generates `dbt_valid_from`, `dbt_valid_to`, and `dbt_scd_id` system metadata columns.

---

## ⚡ Snowflake Integration Overview

- **Database**: `ATMOSYNC_DB`
- **Schema**: `RAW` (Source data), `STAGING` (Staging views), `INTERMEDIATE` (Enriched views), `MARTS` (Dimensional tables), `SNAPSHOTS` (SCD Type 2 tables)
- **Target Table**: `RAW_TELEMETRY`
- **Authentication**: Configured via dbt `profiles.yml` utilizing Snowflake warehouse and role-based access control.

---

## 🚀 dbt Workflow & Execution Steps

### 1. Verify Project Configuration
```bash
dbt debug
```

### 2. Install Dependencies
```bash
dbt deps
```

### 3. Compile Project
```bash
dbt compile
```

### 4. Run Transformations
```bash
dbt run
```

### 5. Execute Snapshots (SCD Type 2)
```bash
dbt snapshot
```

---

## 🧪 Testing & Data Quality Suite

```bash
dbt test
```

```bash
dbt source freshness
```

---

## 📂 Project Structure

```
atmosync_dbt/
├── dbt_project.yml          # Core dbt configuration & model settings
├── README.md                # Project documentation & execution guide
├── models/
│   ├── staging/             # Staging models & source definition YAMLs
│   │   ├── sources.yml
│   │   ├── stg_raw_telemetry.sql
│   │   └── stg_raw_telemetry.yml
│   ├── intermediate/        # Intermediate business logic & enriched models
│   │   ├── int_telemetry_enriched.sql
│   │   └── int_telemetry_enriched.yml
│   └── marts/               # Dimensional star schema for BI & analytics
│       └── core/
│           ├── dim_container.sql
│           ├── dim_date.sql
│           ├── fct_telemetry.sql
│           └── schema.yml
├── snapshots/               # Type-2 SCD snapshots
│   └── snp_container_metadata.sql
├── tests/                   # Custom singular business rule tests
│   ├── assert_telemetry_timestamps_not_in_future.sql
│   ├── assert_non_negative_vibration.sql
│   ├── assert_valid_humidity_range.sql
│   ├── assert_no_orphan_container_references.sql
│   └── assert_no_duplicate_telemetry_keys.sql
├── macros/                  # Custom Jinja macros
├── seeds/                   # Static reference data CSVs
└── analyses/                # Analytical query drafts
```
