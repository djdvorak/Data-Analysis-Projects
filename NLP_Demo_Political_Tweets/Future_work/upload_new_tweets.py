import jsonpickle
import json
import pandas as pd

#thawed = jsonpickle.decode(frozen)

# The data is a newline separated list of json objects
jsonList = []

# Read the contents of the file to a string
with open('JonathanWNV_tweets.txt', 'r', encoding="latin-1") as file:
    data = file.read()

# Make a json object from that string (the data is a newline delimited list of jsons)
for line in data.splitlines():
   jsonList.append(json.loads(line))

result_df = pd.json_normalize(jsonList)