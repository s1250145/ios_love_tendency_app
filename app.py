import json, requests, pickle
from flask import jsonify, request, Flask
from flask_cors import CORS

import cluster

app = Flask(__name__)
CORS(app)

data = json.load(open("person.json", "r"))

@app.route("/", methods=['GET'])
def first_download():
    return jsonify(data)


@app.route("/cluster", methods=['POST'])
def start_clustering():
    impression_data = request.json["data"]
    data = cluster.main(impression_data)
    return jsonify(data)


@app.route("/clustering", methods=['POST'])
def clustering():
    impression_data = request.json["data"]
    data = cluster.main(impression_data)
    return jsonify(data)


if __name__ == "__main__":
    app.run(host='127.0.0.1', port=8018, debug=True)