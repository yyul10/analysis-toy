#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jun 23 11:28:09 2018

@author: yul
"""

import requests
from bs4 import BeautifulSoup
import re
import ast

#뼈대가 되는 데이터는 get parameter로 로딩
base_url = 'http://www.gevolution.co.kr/score/best_publisher.asp?t=3&m=0&d=week'

#form에 사용되는 key와 value정의 - 욥션값
params = {'txtPeriodW':'2018-06-16'}

#request 모듈을 이용한 post 요청
req = requests.post(base_url, data=params)
html = req.content
soup = BeautifulSoup(html,'lxml')

tracklist = soup.find(name='ul', attrs={'class':'commonList chartList chartTrackList'})
tracklist = tracklist.find_all("dl")


url_list = []

title_list = []
for dl in tracklist:
    url_list.append(dl.find('a').get('title'))

total_score_list = []    
for dl in tracklist:
    total_score_list.append(dl.find_all('span')[1].text)