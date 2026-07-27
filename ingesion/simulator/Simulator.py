import random
import time
import json
from datetime import datetime
from faker import Faker

fake = Faker()

while True:
    telemetry = {
        "container_id": f"CONT-{random.randint(1000,9999)}",
        "timestamp": datetime.utcnow().isoformat(),
        "temperature": round(random.uniform(-5, 40), 2),
        "humidity": round(random.uniform(20, 95), 2),
        "vibration": round(random.uniform(0.0, 5.0), 2),
        "location": fake.city()
    }

    print(json.dumps(telemetry, indent=2))

    time.sleep(2)