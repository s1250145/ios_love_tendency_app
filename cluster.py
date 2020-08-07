import glob
import json
import pickle
import pandas as pd
import numpy as np
from math import log
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt
from PIL import Image


def tf(t, c):
    return np.count_nonzero(c == t)/len(c)


def icf(t, s, N, flag):
    cf = 0
    for cluster in s:
        c = np.asarray(cluster)
        if np.count_nonzero(c[:,flag] == t) > 0:
            cf += 1
    if cf is 0:
        return 0
    return log(N/cf)+1


def tf_icf(t, c, s, N, flag):
    a = tf(t, c)
    if a is 0:
        return 0
    b = icf(t, s, N, flag)
    return a*b


def every_t_check(c, s, N, flag):
    l = []
    for t in range(1,6):
        l.append(tf_icf(t, c, s, N, flag))
    return l.index(max(l))


def calculate_tf_icf(id, data):
    N = len(id)
    clusters = []
    for i in id:
        l = []
        for j in i:
            c = [k[2] for k in data if k[0] == j]
            imp = [k[3] for k in data if k[0] == j]
            l.append([j, c[0], imp[0]])
        clusters.append(l)
    s = np.array(clusters) # クラスタの集合s
    result = []
    for i in s:
        c = np.asarray(i)
        category_tf_icf = every_t_check(c[:,1], s, N, 1) + 1 # attribute
        impression_tf_icf = every_t_check(c[:,2], s, N, 2) + 1 # impression
        # image, attribute, impression
        keys = ["list", "symbol"]
        values = [c[:,0].tolist(), [category_tf_icf, impression_tf_icf]]
        result.append(dict(zip(keys, values)))
    return result


def final_answer(user_tendency):
    with open('tendency_label.pickle', 'rb') as f:
        label = pickle.load(f)
    answer = []
    for i in user_tendency:
        tendency = [j["label"] for j in label if j["symbol"] == i["symbol"]]
        if len(tendency) > 0:
            keys = [tendency[0]]
            value = [i["list"]]
            answer.append(dict(zip(keys, value)))
    return answer


def dataFormatting(impression):
    with open('imagelist.pickle', 'rb') as f:
        image_list = pickle.load(f) # all person's image
    l = []
    for i in impression:
        vector = [j["vector"] for j in image_list if j["id"] == i["id"]]
        l.append([i["id"], vector[0], i["attribute"], i["impression"]]) # id, vector, attribute, impression_value
    return l


def averageSplits(id, values, name):
    df = pd.DataFrame(values, columns=["value"])
    l1 = [] # l1 is value is larger than average
    l2 = [] 
    for i, value in enumerate(values):
        if value > df.mean().value:
            l1.append(id[i])
        else:
            l2.append(id[i])
    return l1, l2


def set_attribute(data, list):
    l = []
    for i in list:
        value = [j[2] for j in data if j[0] == i]
        l.append(value[0])
    return l


def imageClustering(cluster, data):
    l = []
    for i in cluster:
        v = [j[1] for j in data if j[0] == i]
        l.append(v[0])
    vector = np.asarray(l)
    k = elbow(vector)
    kmeans = KMeans(n_clusters=k).fit(vector)
    label = kmeans.predict(vector)
    result = []
    for i in range(k):
        l = []
        for v in vector[label==i]:
            id = [j[0] for j in data if np.all(j[1] == v)]
            l.append(id[0])
        result.append(l)
    return result


def elbow(x):
    l = []
    for i in range(1,len(x)):
        km = KMeans(n_clusters=i, init="k-means++", n_init=10, max_iter=300, random_state=0)
        km.fit(x)
        l.append(km.inertia_)
        
    elbow_k = 0
    for s in range(1, len(l)):
        if l[s-1]-l[s] < 0.1:
            elbow_k = s-1
            break
        
    return elbow_k


def main(impression):
    l = dataFormatting(impression)
    # df = pd.DataFrame(l, columns=["id", "vector", "attribute", "impression"])
    # print(df)

    data_x = np.asarray(l)
    impression_avg_a, impression_avg_b = averageSplits(data_x[:, 0].tolist(), data_x[:, 3].tolist(), "impression")

    category_a = set_attribute(l, impression_avg_a)
    category_b = set_attribute(l, impression_avg_b)

    # Get the high level cluster
    cluster_a, cluster_b = averageSplits(impression_avg_a, category_a, "clusterA")
    cluster_c, cluster_d = averageSplits(impression_avg_b, category_b, "clusterB")
    
    # Get the middle level cluster
    cluster_a_m = imageClustering(cluster_a, l) if cluster_a != 0 else 0
    cluster_b_m = imageClustering(cluster_b, l) if cluster_b != 0 else 0
    cluster_c_m = imageClustering(cluster_c, l) if cluster_c != 0 else 0
    cluster_d_m = imageClustering(cluster_d, l) if cluster_d != 0 else 0

    ans = []
    if cluster_a_m != 0: ans.extend(final_answer(calculate_tf_icf(cluster_a_m, l)))
    if cluster_b_m != 0: ans.extend(final_answer(calculate_tf_icf(cluster_b_m, l)))
    if cluster_c_m != 0: ans.extend(final_answer(calculate_tf_icf(cluster_c_m, l)))
    if cluster_d_m != 0: ans.extend(final_answer(calculate_tf_icf(cluster_d_m, l)))
    
    return ans