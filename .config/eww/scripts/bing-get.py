#!/usr/bin/python3
import requests
import os
import re
from datetime import date
import glob

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
file_type = '.jpg'
home = os.path.expanduser('~')
bing_wallpaper_dir = home + '/Pictures/BingWallpaper/'

todaystr = date.strftime(date.today(), '%Y%m%d')
exist_file_re = bing_wallpaper_dir + todaystr + '*' + resolution + file_type
exist_file = glob.glob(exist_file_re)
if exist_file:
    print('Bing wallpaper exist, exiting')
    exit(0)

response = requests.get(bing_img_url, params=bing_img_params, headers=bing_img_headers)

if response.status_code == 200:
    data = response.json()
    images = data['images']
    latest = images[0]
    startdate = latest['startdate']
    urlbase = latest['urlbase']
    img_url = bing_url + urlbase + '_' + resolution + file_type
    file_prefix = re.sub(r'^.*[\\\/]', '', img_url).replace('th?id=OHR.', '')
    file_name = bing_wallpaper_dir + startdate + '-' + file_prefix

    if os.path.exists(file_name):
        exit(0)
    print('Bing wallpaper prepare download form ' + img_url + ' to ' + file_name)
    os.makedirs(bing_wallpaper_dir, exist_ok=True)
    os.system('wget -O "{0}" "{1}" -q –read-timeout=0.1'.format(file_name, img_url))
    print('Download success')
else:
    print('Request failed with status code:', response.status_code)

