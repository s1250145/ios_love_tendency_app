from urllib.request import urlopen
import requests
import shutil
import bs4
import ssl
ssl._create_default_https_context = ssl._create_unverified_context

def main():
    word = input('search: ')
    response = requests.get('https://search.yahoo.co.jp/image/search?p=' + word + '&rkf=1&ei=UTF-8&imc=&ctype=&dim=medium')
    html = response.text
    soup = bs4.BeautifulSoup(html, 'lxml')
    images = soup.find_all('img')
    download_img(images, word)

def download_img(list, word):
    print('save start')
    for i, src in enumerate(list):
        url = src.get('src')
        file = open(f'{word}_{i}.png', 'wb')
        file.write(urlopen(url).read())
    print('finish')

main()