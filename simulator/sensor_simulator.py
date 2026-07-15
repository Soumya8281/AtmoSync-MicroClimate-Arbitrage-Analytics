import random
import csv
import os
from datetime import datetime, timedelta

NUM_RECORDS = 2000

containers = [f"C{str(i).zfill(3)}" for i in range(1, 101)]

commodities = [
    "Avocado",
    "Banana",
    "Apple",
    "Mango",
    "Orange",
    "Grapes",
    "Tomato",
    "Potato",
    "Onion",
    "Carrot"
]

cities = [
    "Kochi",
    "Chennai",
    "Bangalore",
    "Hyderabad",
    "Mumbai",
    "Pune",
    "Delhi",
    "Ahmedabad",
    "Kolkata",
    "Jaipur"
]

os.makedirs("datasets", exist_ok=True)

file_path = "datasets/sensor_data.csv"

with open(file_path, "w", newline="") as file:

    writer = csv.writer(file)

    writer.writerow([
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
    ])

    current_time = datetime.now()

    for i in range(NUM_RECORDS):

        temp = round(random.uniform(2, 12), 2)
        humidity = round(random.uniform(60, 95), 2)
        vibration = round(random.uniform(0.1, 2.0), 2)

        if temp <= 7:
            status = "Normal"
        elif temp <= 9:
            status = "Warning"
        else:
            status = "Critical"

        origin = random.choice(cities)
        destination = random.choice([c for c in cities if c != origin])

        writer.writerow([
            current_time.strftime("%Y-%m-%d %H:%M:%S"),
            random.choice(containers),
            random.choice(commodities),
            origin,
            destination,
            temp,
            humidity,
            vibration,
            random.randint(500, 2500),
            status
        ])

        current_time += timedelta(seconds=2)

        if (i + 1) % 100 == 0:
            print(f"{i + 1} records generated...")

print("\n===================================")
print("Dataset Generation Complete")
print(f"Total Records : {NUM_RECORDS}")
print(f"Saved to : {file_path}")
print("===================================")