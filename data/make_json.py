import json
import glob
from io import BytesIO
import base64
from PIL import Image

def make_dict(keys, values):
    data = dict(zip(keys, values))
    return data

persons = []
before_images = glob.glob('./image/thumb/*.png')
with open('data.json', 'r') as f:
    first_data = json.load(f)

files = sorted(before_images)

for i, file in enumerate(files):
    num = i / 10 + 1
    print(file)
    with open(file, 'rb') as b:
        image = base64.b64encode(b.read()).decode('utf-8')
        keys = ["id", "name", "group", "copy", "image"]
        values = [i+1, first_data[f'no{int(num)}']['name'], first_data[f'no{int(num)}']['group'], first_data[f'no{int(num)}']['copy'], image]
        persons.append(make_dict(keys, values))

with open('person.json', 'w') as f:
    json.dump(persons, f, indent=3, ensure_ascii=True)

print('finish')