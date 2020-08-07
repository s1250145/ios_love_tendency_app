from PIL import Image
import glob
import re

image_folder = './after'
files = glob.glob(image_folder + r'/*')

new_files = sorted(files)

for i in new_files:
    print(i)
    # img = Image.open(i)
    # img = img.resize((200, 200))
    # img.save(i)