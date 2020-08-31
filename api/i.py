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

images = sorted(glob.glob('../data/image/thumb/*'))

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
        plt.subplot(5,5,i+1)
        plt.xticks([])
        plt.yticks([])
        plt.grid(False)
        plt.imshow(plt.imread(l[i], 0))
    plt.show()
    
    
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
    keys = []
    values = []
    for i in user_tendency:
        tendency = [j["label"] for j in label if j["symbol"] == i["symbol"]]
        if len(tendency) > 0:
            if keys.count(tendency[0]) is 0:
                keys.append(tendency[0])
                values.append(i["list"])
            else:
                values[keys.index(tendency[0])].extend(i["list"])
            
    for (k, v) in zip(keys, values):
        answer.append(dict(zip([k], [v])))
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
    print(df.mean().value)
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
    
    fig, ax = plt.subplots()
    showImageOnScatter(vector[:,0], vector[:,1], generateImageList(cluster), ax=ax, zoom=0.2)
    ax.plot(vector[:,0], vector[:,1], "s", alpha=0.4)
    ax.autoscale()
    plt.show()
    
    # plt.scatter(vector[label==0,0], vector[label==0,1], s=50, c="lightgreen", marker="s", label="cluster1")
    # plt.scatter(vector[label==1,0], vector[label==1,1], s=50, c="orange", marker="o", label="cluster2")
    # plt.scatter(vector[label==2,0], vector[label==2,1], s=50, c="lightblue", marker="v", label="cluster3")
    # plt.scatter(vector[label==3,0], vector[label==3,1], s=50, c="lightblue", marker="s", label="cluster4")
    # plt.scatter(vector[label==4,0], vector[label==4,1], s=50, c="orange", marker="o", label="cluster5")
    # plt.scatter(kmeans.cluster_centers_[:,0], kmeans.cluster_centers_[:,1], s=250, marker="*", c="red", label="centroids")

    plt.legend()
    plt.grid()
    plt.show()
    
    result = []
    for i in range(k):
        l = []
        for v in vector[label==i]:
            id = [j[0] for j in data if np.all(j[1] == v)]
            l.append(id[0])
        result.append(l)
    return result


def elbow(x):
    if len(x) is 0: return 1
    
    l = []
    for i in range(1,len(x)):
        km = KMeans(n_clusters=i, init="k-means++", n_init=10, max_iter=300, random_state=0)
        km.fit(x)
        l.append(km.inertia_)

    if len(l) < 3: return 2
        
    elbow_k = 1
    for s in range(1, len(l)):
        if abs(l[s-1]-l[s]) < 0.1 and abs(l[s-1]-l[s]) > 0.01:
            elbow_k = s
            break
        
    return elbow_k


def main():
    with open("answerdata.pickle", "rb") as f:
        impression = pickle.load(f)
    l = dataFormatting(impression)
    df = pd.DataFrame(l, columns=["id", "vector", "attribute", "impression"])
    print(df)

    data_x = np.asarray(l)
    impression_avg_a, impression_avg_b = averageSplits(data_x[:, 0].tolist(), data_x[:, 3].tolist(), "impression")

    category_a = set_attribute(l, impression_avg_a)
    category_b = set_attribute(l, impression_avg_b)

    # Get the high level cluster
    cluster_a, cluster_b = averageSplits(impression_avg_a, category_a, "clusterA")
    cluster_c, cluster_d = averageSplits(impression_avg_b, category_b, "clusterB")
    
    
    # Get the middle level cluster
    cluster_a_m = imageClustering(cluster_a, l) if len(cluster_a) != 0 else 0
    cluster_b_m = imageClustering(cluster_b, l) if len(cluster_b) != 0 else 0
    cluster_c_m = imageClustering(cluster_c, l) if len(cluster_c) != 0 else 0
    cluster_d_m = imageClustering(cluster_d, l) if len(cluster_d) != 0 else 0

    ans = []
    if len(cluster_a_m) != 0: ans.extend(final_answer(calculate_tf_icf(cluster_a_m, l)))
    if len(cluster_b_m) != 0: ans.extend(final_answer(calculate_tf_icf(cluster_b_m, l)))
    if len(cluster_c_m) != 0: ans.extend(final_answer(calculate_tf_icf(cluster_c_m, l)))
    if len(cluster_d_m) != 0: ans.extend(final_answer(calculate_tf_icf(cluster_d_m, l)))
    return ans

main()