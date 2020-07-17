from pathlib import Path
import glob
from PIL import Image


def resize(img, box_size):
    box_width, box_height = box_size
    scale_x = box_width / img.width
    scale_y = box_height / img.height
    scale = max(scale_x, scale_y)

    # リサイズ後の大きさを計算する。
    if scale_x > scale_y:
        new_width = box_width
        new_height = int(img.height * scale)
    else:
        new_width = int(img.width * scale)
        new_height = box_height

    # リサイズする。
    resized = img.resize((new_width, new_height))

    # 中心で切り抜く
    left = (new_width - box_width) // 2
    top = (new_height - box_height) // 2
    right = (new_width + box_width) // 2
    bottom = (new_height + box_height) // 2
    cropped = resized.crop((left, top, right, bottom))
    return cropped


box_size = (200, 200)  # サムネイルの大きさ
input_images = glob.glob("before/*.png")
files = sorted(input_images)
output_dir = Path("thumb")

for i, file in enumerate(files):
    # 画像を読み込む。
    img = Image.open(file)

    # リサイズする。
    resized = resize(img, box_size)
    # print(f"{file}: {img.size} --> {resized.size}")

    # 保存する。
    resized.save(f"{output_dir}/{i+1}.png")