#!/usr/bin/python3
import requests
import os
import re

bing_url = 'https://www.bing.com'
bing_img_url = bing_url + '/HPImageArchive.aspx'
bing_img_params = {
    'format': 'js',
    'idx': 0,
    'n': 8,
    'mbl': 1,
    'mkt': 'zh-HK'
}

bing_img_headers = {
    'Accept': 'application/json'
}
resolution = 'UHD'
home = os.path.expanduser('~')
bing_wallpaper_dir = home + '/Pictures/BingWallpaper/'

response = requests.get(bing_img_url, params=bing_img_params, headers=bing_img_headers)

if response.status_code == 200:
    data = response.json()
    images = data['images']
    latest = images[0]
    startdate = latest['startdate']
    urlbase = latest['urlbase']
    img_url = bing_url + urlbase + '_' + resolution + '.jpg'
    file_prefix = re.sub(r'^.*[\\\/]', '', img_url).replace('th?id=OHR.', '')
    file_name = bing_wallpaper_dir + startdate + '-' + file_prefix

    if os.path.exists(file_name):
        exit(0)
    print(file_name)
    print(img_url)
    os.system('wget -O "{0}" "{1}" -q –read-timeout=0.1'.format(file_name, img_url))
else:
    print('Request failed with status code:', response.status_code)

