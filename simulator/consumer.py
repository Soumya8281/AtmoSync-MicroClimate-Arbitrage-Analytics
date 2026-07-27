from kafka import KafkaConsumer
import json
import csv
import os

consumer = KafkaConsumer(
    "sensor-data",
    bootstrap_servers="localhost:9092",
    auto_offset_reset="earliest",
    enable_auto_commit=True,
    group_id="atm-sync-group-v2",
    value_deserializer=lambda x: json.loads(x.decode("utf-8"))
)

output_file = "datasets/streamed_sensor_data.csv"

file_exists = os.path.exists(output_file)

with open(output_file, "a", newline="") as csvfile:
    writer = None

    print("Waiting for sensor data...\n")

    for message in consumer:
        data = message.value

        if writer is None:
            writer = csv.DictWriter(csvfile, fieldnames=data.keys())

            if not file_exists:
                writer.writeheader()

        writer.writerow(data)
        csvfile.flush()

        print("Saved:", data["container_id"])