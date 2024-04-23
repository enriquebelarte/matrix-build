import json
import urllib.request


# URL of the JSON containing the releases
url = "https://docs.nvidia.com/datacenter/tesla/drivers/releases.json"

try:
    # Fetch JSON data from the URL
    with urllib.request.urlopen(url) as response:
        data = response.read().decode("utf-8")
    # Load the JSON data
    json_data = json.loads(data)

    # Filter the results
    filtered_results = {}

    for version, info in json_data.items():
        for driver_info in info["driver_info"]:
            release_version = driver_info["release_version"]
            if (info["type"] == "production branch" or info["type"] == "lts branch") and \
               release_version > "515.0.0":
                if version not in filtered_results:
                    filtered_results[version] = {"type": info["type"], "driver_info": []}
                filtered_results[version]["driver_info"].append(driver_info)

    # Convert the filtered results back to JSON format
    filtered_json = json.dumps(filtered_results, indent=2)

    print(filtered_json)
except Exception as e:
    print("Failed to fetch or process data:", e)
