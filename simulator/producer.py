from kafka import KafkaProducer
import pandas as pd
import json
import time

producer = KafkaProducer(
    bootstrap_servers="localhost:9092",
    value_serializer=lambda v: json.dumps(v).encode("utf-8")
)

from pathlib import Path
import pandas as pd

BASE_DIR = Path(__file__).resolve().parent.parent
csv_path = BASE_DIR / "datasets" / "sensor_data.csv"

df = pd.read_csv(csv_path)

for _, row in df.iterrows():
    producer.send("sensor-data", row.to_dict())
    print("Sent:", row["container_id"])
    time.sleep(1)

producer.flush()
producer.close()