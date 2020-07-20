import glob
import json
import pickle
import pandas as pd
import numpy as np
from math import log
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt
from matplotlib.offsetbox import OffsetImage, AnnotationBbox
from PIL import Image

# images = sorted(glob.glob('./facenet-sample/after/*'))

def entropy(vec_data):
    entropys = list()
    # count = Counter(vec_data)
    key, count = np.unique(vec_data, return_counts=True)
    # countall = float(np.sum(count.values()))
    countall = len(vec_data)
    for item in count:
        counteach = item
        prob = counteach/countall
        entropyeach = -prob * np.log(prob)
        entropys.append(entropyeach)
    entropy = np.sum(entropys)
    return entropy


def splitByImpression(vec_data, impression):
    data_xi = [[], [], [], [], []]
    for i, vector in enumerate(vec_data):
        data_xi[impression[i]-1].append(vector)
    return data_xi


def informationGain(h_x, h_xi, data_x, data_xi):
    sigma = sum(h_xi)
    return h_x-sigma*data_xi/data_x


def dataFraming(data, cluster):
    # show pandas table
    cluster_category = []
    for i in cluster:
        value = [j[2] for j in data if j[0] == i]   
        cluster_category.append([i, value[0]]) 
    df = pd.DataFrame(cluster_category, columns=["id", "category"])
    return df


def generateImageList(id):
    image_list = []
    for i in id:
        image_list.append(images[i-1])
    return image_list 


def showImage(id):
    l = generateImageList(id)
    width = 35
    height = 35
    plt.figure(figsize=(width, height))
    for i in range(len(l)):
        plt.subplot(5, 5, i+1)
        plt.xticks([])
        plt.yticks([])
        plt.grid(False)
        plt.imshow(plt.imread(l[i], 0))
    plt.show()


def averageSplits(id, values, name):
    df = pd.DataFrame(values, columns=["value"])
    # print(f"{name} average ", df.mean())
    l1 = [] # l1 is value is larger than average
    l2 = [] 
    for i, value in enumerate(values):
        if value > df.mean().value:
            l1.append(id[i])
        else:
            l2.append(id[i])
    return l1, l2


def dataFormatting():
    with open('imagelist.pickle', 'rb') as f:
        image_list = pickle.load(f) # all person's image
    with open('impression.pickle', 'rb') as g:
        impression = pickle.load(g) # id, impression_value
    with open('person_catego.json', 'r') as b:
        category = json.load(b) # all person's category

    l = []
    for i in impression:
        vector = [j["vector"] for j in image_list if j["id"] == i["id"]]
        c = [int(k["num"]) for k in category if int(k["id"]) == i["id"]]
        l.append([i["id"], vector[0], c[0], i["impression"]]) # id, vector, category, impression_value

    return l


def showImageOnScatter(x, y, image_path, ax=None, zoom=1):
    if ax is None:
        ax = plt.gca()

    artists = []
    for x0, y0, image in zip(x, y, image_path):
        image = plt.imread(image, 0)
        im = OffsetImage(image, zoom=zoom)
        ab = AnnotationBbox(im, (x0, y0), xycoords='data', frameon=False)
        artists.append(ax.add_artist(ab))
    return artists


def elbow(x):
    l = []
    for i in range(1,11):
        km = KMeans(n_clusters=i, init="k-means++", n_init=10, max_iter=300, random_state=0)
        km.fit(x)
        l.append(km.inertia_)
    plt.plot(range(1,11), l, marker="o")
    plt.xlabel("Number of clusters")
    plt.ylabel("Distortion")
    plt.show()


def imageClustering(cluster, data, k):
    l = []
    for i in cluster:
        v = [j[1] for j in data if j[0] == i]
        l.append(v[0])
    vector = np.asarray(l)
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
        category_tf_icf = every_t_check(c[:,1], s, N, 1) + 1 # category
        impression_tf_icf = every_t_check(c[:,2], s, N, 2) + 1 # impression
        # image, category, impression
        keys = ["list", "symbol"]
        values = [c[:,0].tolist(), [category_tf_icf, impression_tf_icf]]
        result.append(dict(zip(keys, values)))
    return result


def set_category(data, list):
    l = []
    for i in list:
        value = [j[2] for j in data if j[0] == i]
        l.append(value[0])
    return l


def final_answer(user_tendency):
    with open('tendency_label.pickle', 'rb') as f:
        label = pickle.load(f)
    answer = []
    for i in user_tendency:
        tendency = [j["label"] for j in label if j["symbol"] == i["symbol"]]
        if len(tendency) > 0:
            l = []
            for id in i["list"]:
                keys = ["tendency", "id"]
                values = [tendency[0], id]
                l.append(dict(zip(keys, values)))
            answer.append(l)
    return answer


def main():
    # l = dataFormatting(impression)
    l = dataFormatting()

    df = pd.DataFrame(l, columns=["id", "vector", "category", "impression"])
    # print(df)

    data_x = np.asarray(l)
    impression_avg_a, impression_avg_b = averageSplits(data_x[:, 0].tolist(), data_x[:, 3].tolist(), "impression")

    category_a = set_category(l, impression_avg_a)
    category_b = set_category(l, impression_avg_b)

    # Get the high level cluster
    cluster_a, cluster_b = averageSplits(impression_avg_a, category_a, "clusterA")
    cluster_c, cluster_d = averageSplits(impression_avg_b, category_b, "clusterB")

    # Get the middle level cluster
    cluster_a_m = imageClustering(cluster_a, l, 4)
    cluster_b_m = imageClustering(cluster_b, l, 4)
    cluster_c_m = imageClustering(cluster_c, l, 4)
    cluster_d_m = imageClustering(cluster_d, l, 4)

    ans = []
    ans.extend(final_answer(calculate_tf_icf(cluster_a_m, l)))
    ans.extend(final_answer(calculate_tf_icf(cluster_b_m, l)))
    ans.extend(final_answer(calculate_tf_icf(cluster_c_m, l)))
    ans.extend(final_answer(calculate_tf_icf(cluster_d_m, l)))
    
    return ans


# print(main())