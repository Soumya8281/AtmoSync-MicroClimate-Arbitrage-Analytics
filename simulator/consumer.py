from kafka import KafkaConsumer
import json

consumer = KafkaConsumer(
    "sensor-data",
    bootstrap_servers="localhost:9092",
    auto_offset_reset="earliest",
    enable_auto_commit=True,
    group_id="atm-sync-group",
    value_deserializer=lambda x: json.loads(x.decode("utf-8"))
)

print("Waiting for sensor data...\n")

for message in consumer:
    print(message.value)