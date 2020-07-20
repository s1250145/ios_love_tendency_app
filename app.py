import json, requests, pickle
from flask import jsonify, request, Flask
from flask_cors import CORS

import cluster

app = Flask(__name__)
CORS(app)

data = json.load(open("person.json", "r"))

@app.route("/")
def hello():
    return jsonify(data)

@app.route("/", methods=['GET'])
def first_download():
    # 画像と名前等の基本データセットをjson形式で送信
    return jsonify(data)

@app.route("/cluster", methods=['POST'])
def start_clustering():
    impression_data = request.json["data"]
    # data = cluster.main(impression_data)
    data = cluster.main()
    print(data)
    # with open('impression.pickle', 'wb') as f:
    #     pickle.dump(impression_data, f)
    # keys = ["tendency", "list"]
    # values = ["本命だょ", [1, 3, 5, 7]]
    # onedict = dict(zip(keys, values))
    # data = [onedict,onedict]
    # 画像のidとそれに対する印象のデータセットをjson形式で受け取る
    return jsonify(data)

if __name__ == "__main__":
    app.run(host='127.0.0.1', port=8018, debug=True)
