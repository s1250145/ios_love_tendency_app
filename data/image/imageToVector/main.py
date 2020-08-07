import glob
import numpy as np
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt
from matplotlib.offsetbox import OffsetImage, AnnotationBbox
from PIL import Image
from FaceNet import FaceEmbedding

def showImageOnScatter(x, y, image_path, ax=None, zoom=1):
    if ax is None:
        ax = plt.gca()

    artists = []
    for x0, y0, image in zip(x, y, image_path):
        image = plt.imread(image)
        im = OffsetImage(image, zoom=zoom)
        ab = AnnotationBbox(im, (x0, y0), xycoords='data', frameon=False)
        artists.append(ax.add_artist(ab))
    return artists

FACE_MODEL_PATH = './20180402-114759.pb'
face_embedding = FaceEmbedding(FACE_MODEL_PATH)

arashi_images = glob.glob('./arashi/*.jpg')
for i in arashi_images:
    img = Image.open(i)
    img = img.resize((200, 200))
    img.save(i)

feartures = np.array([face_embedding.face_embeddings(f)[0] for f in arashi_images])

print('step1: ', feartures.shape)

pca = PCA(n_components=2)
pca.fit(feartures)
reduced = pca.fit_transform(feartures)

print(reduced)

print('step2: ', reduced.shape)

kmeans = KMeans(n_clusters=4).fit(reduced)
label = kmeans.predict(reduced)

x = reduced[:, 0]
y = reduced[:, 1]
fig, ax = plt.subplots()
showImageOnScatter(x, y, arashi_images, ax=ax, zoom=.2)
ax.plot(x, y, 'ko', alpha=0)
ax.autoscale()
# plt.scatter(x, y, c=label)
plt.show()
