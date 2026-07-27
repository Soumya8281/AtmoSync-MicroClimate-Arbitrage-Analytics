import pandas as pd

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

print("\n===== AtmoSync Analytics =====\n")

print("Total Records:", len(df))

print("Average Temperature:", round(df["temperature"].mean(), 2), "°C")
print("Average Humidity:", round(df["humidity"].mean(), 2), "%")

print("\nStatus Count:")
print(df["status"].value_counts())

print("\nCommodity Count:")
print(df["commodity"].value_counts())

print("\nOrigin Cities:")
print(df["origin"].value_counts())

print("\nDestination Cities:")
print(df["destination"].value_counts())