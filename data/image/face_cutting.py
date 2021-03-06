import cv2
import glob
import numpy as np

cascade_path = './haarcascade_frontalface_default.xml'
faceCascade = cv2.CascadeClassifier(cascade_path)

images = sorted(glob.glob('./before/*.png'))

print('start')
for num, i in enumerate(images):
    img = cv2.imread(i, cv2.IMREAD_COLOR)
    if img is None:
        print('No face: ', i)
    else:
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        face = faceCascade.detectMultiScale(gray, 1.1, 3)
        if len(face) > 0:
            for rect in face:
                x = rect[0]
                y = rect[1]
                w = rect[2]
                h = rect[3]
                save_dir = f'./check/{num}.png'
                cv2.imwrite(save_dir, img[y:y+h, x:x+w])
        else:
            print('No face: ', i)
print('finish')
