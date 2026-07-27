from kafka import KafkaProducer
import json
import random
import time
from datetime import datetime

producer = KafkaProducer(
    bootstrap_servers="localhost:9092",
    value_serializer=lambda v: json.dumps(v).encode("utf-8")
)

while True:
    data = {
        "container_id": f"CONT-{random.randint(1000,9999)}",
        "timestamp": datetime.utcnow().isoformat(),
        "temperature": round(random.uniform(-5,40),2),
        "humidity": round(random.uniform(20,95),2),
        "vibration": round(random.uniform(0,5),2)
    }

    producer.send("container.telemetry", data)
    producer.flush()

    print("Sent:", data)

    time.sleep(2)