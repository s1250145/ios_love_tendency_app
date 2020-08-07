import json
import glob
import pickle

with open('tendency_label.json', 'r') as f:
    d = json.load(f)

l = []
for i in d:
    keys = ["symbol", "label"]
    symbol = [int(i["attribute"]), int(i["impression"])]
    values = [symbol, i["label"]]
    l.append(dict(zip(keys, values)))

print(l)

with open('tendency_label.pickle', 'wb') as b:
    pickle.dump(l, b)