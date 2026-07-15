import random
import time
from datetime import datetime

containers = ["C001", "C002", "C003", "C004", "C005"]

while True:
    data = {
        "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "container_id": random.choice(containers),
        "temperature": round(random.uniform(2, 12), 2),
        "humidity": round(random.uniform(60, 95), 2),
        "vibration": round(random.uniform(0.1, 2.0), 2)
    }

    print(data)

    time.sleep(2)