import os
from dotenv import load_dotenv
import snowflake.connector
import pandas as pd

load_dotenv()

conn = snowflake.connector.connect(
    user=os.getenv("SNOWFLAKE_USER"),
    password=os.getenv("SNOWFLAKE_PASSWORD"),
    account=os.getenv("SNOWFLAKE_ACCOUNT"),
    warehouse=os.getenv("SNOWFLAKE_WAREHOUSE"),
    database=os.getenv("SNOWFLAKE_DATABASE"),
    schema=os.getenv("SNOWFLAKE_SCHEMA"),
    role=os.getenv("SNOWFLAKE_ROLE")
)

cursor = conn.cursor()

columns = [
    "timestamp",
    "container_id",
    "commodity",
    "origin",
    "destination",
    "temperature",
    "humidity",
    "vibration",
    "weight_kg",
    "status"
]

df = pd.read_csv(
    "datasets/streamed_sensor_data.csv",
    names=columns,
    header=None
)

insert_query = """
INSERT INTO SENSOR_DATA
(timestamp, container_id, commodity, origin, destination,
temperature, humidity, vibration, weight_kg, status)
VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
"""

for _, row in df.iterrows():
    cursor.execute(insert_query, tuple(row))

conn.commit()

print(f"Successfully inserted {len(df)} rows into Snowflake.")

cursor.close()
conn.close()