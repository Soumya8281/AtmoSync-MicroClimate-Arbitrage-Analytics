import random
import csv
import os
from datetime import datetime, timedelta

# Number of records to generate
NUM_RECORDS = 2000

# Container IDs
containers = ["C001", "C002", "C003", "C004", "C005"]

# Create datasets folder
os.makedirs("datasets", exist_ok=True)

file_path = "datasets/sensor_data.csv"

# Write CSV Header
with open(file_path, "w", newline="") as file:
    writer = csv.writer(file)

    writer.writerow([
        "timestamp",
        "container_id",
        "temperature",
        "humidity",
        "vibration"
    ])

    # Starting timestamp
    current_time = datetime.now()

    for i in range(NUM_RECORDS):

        data = [
            current_time.strftime("%Y-%m-%d %H:%M:%S"),
            random.choice(containers),
            round(random.uniform(2, 12), 2),
            round(random.uniform(60, 95), 2),
            round(random.uniform(0.1, 2.0), 2)
        ]

        writer.writerow(data)

        # Print progress
        if (i + 1) % 100 == 0:
            print(f"{i + 1} records generated...")

        # Increase timestamp by 2 seconds
        current_time += timedelta(seconds=2)

print("\n===================================")
print(f"Successfully generated {NUM_RECORDS} sensor records.")
print(f"Dataset saved to: {file_path}")
print("===================================")