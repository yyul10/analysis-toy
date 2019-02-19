# -*- coding: utf-8 -*-
# *** Spyder Python Console History Log ***

## ---(Sat Jun 23 10:41:17 2018)---
runfile('/Users/yul/.spyder-py3/temp.py', wdir='/Users/yul/.spyder-py3')
type(soup)
runfile('/Users/yul/.spyder-py3/temp.py', wdir='/Users/yul/.spyder-py3')
type(soup)
runfile('/Users/yul/.spyder-py3/temp.py', wdir='/Users/yul/.spyder-py3')
runfile('/Users/yul/.spyder-py3/3.py', wdir='/Users/yul/.spyder-py3')
y
type(soup)
runfile('/Users/yul/.spyder-py3/3.py', wdir='/Users/yul/.spyder-py3')

## ---(Sat Jun 23 10:59:15 2018)---
runfile('/Users/yul/.spyder-py3/3.py', wdir='/Users/yul/.spyder-py3')
runfile('/Users/yul/.spyder-py3/Crawling_example.py', wdir='/Users/yul/.spyder-py3')
clear
runfile('/Users/yul/.spyder-py3/Crawling_example.py', wdir='/Users/yul/.spyder-py3')

## ---(Sat Jun 23 11:18:23 2018)---
runfile('/Users/yul/.spyder-py3/Crawling_example.py', wdir='/Users/yul/.spyder-py3')
runfile('/Users/yul/.spyder-py3/Crawling_example2.py', wdir='/Users/yul/.spyder-py3')
python Crawling_example2.py
clear
runfile('/Users/yul/.spyder-py3/Crawling_example2.py', wdir='/Users/yul/.spyder-py3')
runfile('/Users/yul/.spyder-py3/api_example', wdir='/Users/yul/.spyder-py3')
runfile('/Users/yul/.spyder-py3/Crawling_example.py', wdir='/Users/yul/.spyder-py3')
runfile('/Users/yul/.spyder-py3/naver_news.py', wdir='/Users/yul/.spyder-py3')
import requests
from bs4 import BeautifulSoup
import re
import ast


# 뉴스기사 리스트 크롤링
base_url = 'http://news.naver.com/main/list.nhn?mode=LS2D&mid=shm&sid1=100&sid2=269'
req = requests.get(base_url)
html = req.content
soup = BeautifulSoup(html, 'lxml') # pip install lxml
newslist = soup.find(name="div", attrs={"class":"newsflash_body"})
newslist_atag = newslist.find_all('a') #a태그(링크태그)를 가진것이 텍스트밖에 없으므로
url_list = []
for a in newslist_atag:
    url_list.append(a.get('href'))


print(url_list)
import requests
from bs4 import BeautifulSoup
import re
import ast


# 뉴스기사 리스트 크롤링
base_url = 'http://news.naver.com/main/list.nhn?mode=LS2D&mid=shm&sid1=100&sid2=269'
req = requests.get(base_url)
html = req.content
soup = BeautifulSoup(html, 'lxml') # pip install lxml
newslist = soup.find(name="div", attrs={"class":"newsflash_body"})
newslist_atag = newslist.find_all('a') #a태그(링크태그)를 가진것이 텍스트밖에 없으므로
url_list = []
for a in newslist_atag:
    url_list.append(a.get('href'))


print(url_list)
# 텍스트 정제 함수, 알파벳과 특수문자 제거
def text_cleaning(text):
    result_list = []
    for item in text:
        cleaned_text = re.sub('[a-zA-Z]', '', item)
        cleaned_text = re.sub('[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]',
                          '', cleaned_text)
        result_list.append(cleaned_text)
    return result_list


# 텍스트 정제 함수, isalnum: 알파벳과 숫자 True, isdigit: 10진수 True
def removeNumberNpunct(doc):
    text = ''.join(c for c in doc if c.isalnum() or c in '+, ')
    text = ''.join([i for i in text if not i.isdigit()])
    return text


# 각 기사에서 텍스트만 정제하여 추출
req = requests.get(url_list[0])
html = req.content
soup = BeautifulSoup(html, 'lxml')
text = ''
doc = None
for item in soup.find_all('div', id='articleBodyContents'):
    text = text + str(item.find_all(text=True))
    text = ast.literal_eval(text)
    doc = text_cleaning(text[9:-6])
import requests
from bs4 import BeautifulSoup
import re
import ast


# 뉴스기사 리스트 크롤링
base_url = 'http://news.naver.com/main/list.nhn?mode=LS2D&mid=shm&sid1=100&sid2=269'
req = requests.get(base_url)
html = req.content
soup = BeautifulSoup(html, 'lxml') # pip install lxml
newslist = soup.find(name="div", attrs={"class":"newsflash_body"})
newslist_atag = newslist.find_all('a') #a태그(링크태그)를 가진것이 텍스트밖에 없으므로
url_list = []
for a in newslist_atag:
    url_list.append(a.get('href'))


print(url_list)
# 텍스트 정제 함수, 알파벳과 특수문자 제거
def text_cleaning(text):
    result_list = []
    for item in text:
        cleaned_text = re.sub('[a-zA-Z]', '', item)
        cleaned_text = re.sub('[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]',
                          '', cleaned_text)
        result_list.append(cleaned_text)
    return result_list


# 텍스트 정제 함수, isalnum: 알파벳과 숫자 True, isdigit: 10진수 True
def removeNumberNpunct(doc):
    text = ''.join(c for c in doc if c.isalnum() or c in '+, ')
    text = ''.join([i for i in text if not i.isdigit()])
    return text


# 각 기사에서 텍스트만 정제하여 추출
req = requests.get(url_list[0])
html = req.content
soup = BeautifulSoup(html, 'lxml')
text = ''
doc = None
for item in soup.find_all('div', id='articleBodyContents'):
    text = text + str(item.find_all(text=True))
    text = ast.literal_eval(text)
    doc = text_cleaning(text[9:-12])
import requests
from bs4 import BeautifulSoup
import re
import ast


# 뉴스기사 리스트 크롤링
base_url = 'http://news.naver.com/main/list.nhn?mode=LS2D&mid=shm&sid1=100&sid2=269'
req = requests.get(base_url)
html = req.content
soup = BeautifulSoup(html, 'lxml') # pip install lxml
newslist = soup.find(name="div", attrs={"class":"newsflash_body"})
newslist_atag = newslist.find_all('a') #a태그(링크태그)를 가진것이 텍스트밖에 없으므로
url_list = []
for a in newslist_atag:
    url_list.append(a.get('href'))


print(url_list)
# 텍스트 정제 함수, 알파벳과 특수문자 제거
def text_cleaning(text):
    result_list = []
    for item in text:
        cleaned_text = re.sub('[a-zA-Z]', '', item)
        cleaned_text = re.sub('[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]',
                          '', cleaned_text)
        result_list.append(cleaned_text)
    return result_list


# 텍스트 정제 함수, isalnum: 알파벳과 숫자 True, isdigit: 10진수 True
def removeNumberNpunct(doc):
    text = ''.join(c for c in doc if c.isalnum() or c in '+, ')
    text = ''.join([i for i in text if not i.isdigit()])
    return text


# 각 기사에서 텍스트만 정제하여 추출
req = requests.get(url_list[0])
html = req.content
soup = BeautifulSoup(html, 'lxml')
text = ''
doc = None
for item in soup.find_all('div', id='articleBodyContents'):
    text = text + str(item.find_all(text=True))
    text = ast.literal_eval(text)
    doc = text_cleaning(text[9:-7])
import requests
from bs4 import BeautifulSoup
import re
import ast


# 뉴스기사 리스트 크롤링
base_url = 'http://news.naver.com/main/list.nhn?mode=LS2D&mid=shm&sid1=100&sid2=269'
req = requests.get(base_url)
html = req.content
soup = BeautifulSoup(html, 'lxml') # pip install lxml
newslist = soup.find(name="div", attrs={"class":"newsflash_body"})
newslist_atag = newslist.find_all('a') #a태그(링크태그)를 가진것이 텍스트밖에 없으므로
url_list = []
for a in newslist_atag:
    url_list.append(a.get('href'))


print(url_list)
# 텍스트 정제 함수, 알파벳과 특수문자 제거
def text_cleaning(text):
    result_list = []
    for item in text:
        cleaned_text = re.sub('[a-zA-Z]', '', item)
        cleaned_text = re.sub('[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]',
                          '', cleaned_text)
        result_list.append(cleaned_text)
    return result_list


# 텍스트 정제 함수, isalnum: 알파벳과 숫자 True, isdigit: 10진수 True
def removeNumberNpunct(doc):
    text = ''.join(c for c in doc if c.isalnum() or c in '+, ')
    text = ''.join([i for i in text if not i.isdigit()])
    return text


# 각 기사에서 텍스트만 정제하여 추출
req = requests.get(url_list[0])
html = req.content
soup = BeautifulSoup(html, 'lxml')
text = ''
doc = None
for item in soup.find_all('div', id='articleBodyContents'):
    text = text + str(item.find_all(text=True))
    text = ast.literal_eval(text)
    doc = text_cleaning(text[3:-5])


word_corpus = (' '.join(doc))
word_corpus = removeNumberNpunct(word_corpus)
import requests
from bs4 import BeautifulSoup
import re
import ast


# 뉴스기사 리스트 크롤링
base_url = 'http://news.naver.com/main/list.nhn?mode=LS2D&mid=shm&sid1=100&sid2=269'
req = requests.get(base_url)
html = req.content
soup = BeautifulSoup(html, 'lxml') # pip install lxml
newslist = soup.find(name="div", attrs={"class":"newsflash_body"})
newslist_atag = newslist.find_all('a') #a태그(링크태그)를 가진것이 텍스트밖에 없으므로
url_list = []
for a in newslist_atag:
    url_list.append(a.get('href'))


print(url_list)
# 텍스트 정제 함수, 알파벳과 특수문자 제거
def text_cleaning(text):
    result_list = []
    for item in text:
        cleaned_text = re.sub('[a-zA-Z]', '', item)
        cleaned_text = re.sub('[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]',
                          '', cleaned_text)
        result_list.append(cleaned_text)
    return result_list


# 텍스트 정제 함수, isalnum: 알파벳과 숫자 True, isdigit: 10진수 True
def removeNumberNpunct(doc):
    text = ''.join(c for c in doc if c.isalnum() or c in '+, ')
    text = ''.join([i for i in text if not i.isdigit()])
    return text


# 각 기사에서 텍스트만 정제하여 추출
req = requests.get(url_list[0])
html = req.content
soup = BeautifulSoup(html, 'lxml')
text = ''
doc = None
for item in soup.find_all('div', id='articleBodyContents'):
    text = text + str(item.find_all(text=True))
    text = ast.literal_eval(text)
    doc = text_cleaning(text[1:-1])
import requests
from bs4 import BeautifulSoup
import re
import ast


# 뉴스기사 리스트 크롤링
base_url = 'http://news.naver.com/main/list.nhn?mode=LS2D&mid=shm&sid1=100&sid2=269'
req = requests.get(base_url)
html = req.content
soup = BeautifulSoup(html, 'lxml') # pip install lxml
newslist = soup.find(name="div", attrs={"class":"newsflash_body"})
newslist_atag = newslist.find_all('a') #a태그(링크태그)를 가진것이 텍스트밖에 없으므로
url_list = []
for a in newslist_atag:
    url_list.append(a.get('href'))


print(url_list)
# 텍스트 정제 함수, 알파벳과 특수문자 제거
def text_cleaning(text):
    result_list = []
    for item in text:
        cleaned_text = re.sub('[a-zA-Z]', '', item)
        cleaned_text = re.sub('[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]',
                          '', cleaned_text)
        result_list.append(cleaned_text)
    return result_list


# 텍스트 정제 함수, isalnum: 알파벳과 숫자 True, isdigit: 10진수 True
def removeNumberNpunct(doc):
    text = ''.join(c for c in doc if c.isalnum() or c in '+, ')
    text = ''.join([i for i in text if not i.isdigit()])
    return text


# 각 기사에서 텍스트만 정제하여 추출
req = requests.get(url_list[0])
html = req.content
soup = BeautifulSoup(html, 'lxml')
text = ''
doc = None
for item in soup.find_all('div', id='articleBodyContents'):
    text = text + str(item.find_all(text=True))
    text = ast.literal_eval(text)
    doc = text_cleaning(text[1:-1])


word_corpus = (' '.join(doc))
word_corpus = removeNumberNpunct(word_corpus)


# 텍스트에서 형태소 추출 -> pip install konlpy, jpype1, Jpype1-py3
from konlpy.tag import Twitter
from collections import Counter

nouns_tagger = Twitter()
nouns = nouns_tagger.nouns(word_corpus)
count = Counter(nouns)
import requests
from bs4 import BeautifulSoup
import re
import ast


# 뉴스기사 리스트 크롤링
base_url = 'http://news.naver.com/main/list.nhn?mode=LS2D&mid=shm&sid1=100&sid2=269'
req = requests.get(base_url)
html = req.content
soup = BeautifulSoup(html, 'lxml') # pip install lxml
newslist = soup.find(name="div", attrs={"class":"newsflash_body"})
newslist_atag = newslist.find_all('a') #a태그(링크태그)를 가진것이 텍스트밖에 없으므로
url_list = []
for a in newslist_atag:
    url_list.append(a.get('href'))


print(url_list)
# 텍스트 정제 함수, 알파벳과 특수문자 제거
def text_cleaning(text):
    result_list = []
    for item in text:
        cleaned_text = re.sub('[a-zA-Z]', '', item)
        cleaned_text = re.sub('[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]',
                          '', cleaned_text)
        result_list.append(cleaned_text)
    return result_list


# 텍스트 정제 함수, isalnum: 알파벳과 숫자 True, isdigit: 10진수 True
def removeNumberNpunct(doc):
    text = ''.join(c for c in doc if c.isalnum() or c in '+, ')
    text = ''.join([i for i in text if not i.isdigit()])
    return text


# 각 기사에서 텍스트만 정제하여 추출
req = requests.get(url_list[0])
html = req.content
soup = BeautifulSoup(html, 'lxml')
text = ''
doc = None
for item in soup.find_all('div', id='articleBodyContents'):
    text = text + str(item.find_all(text=True))
    text = ast.literal_eval(text)
    doc = text_cleaning(text[5:-5])


word_corpus = (' '.join(doc))
word_corpus = removeNumberNpunct(word_corpus)


# 텍스트에서 형태소 추출 -> pip install konlpy, jpype1, Jpype1-py3
from konlpy.tag import Twitter
from collections import Counter

nouns_tagger = Twitter()
nouns = nouns_tagger.nouns(word_corpus)
count = Counter(nouns)


# 형태소 워드 클라우드로 시각화 -> pip install pytagcloud, webbrowser
# Mac OS : /anaconda/envs/fastcampus/lib/python3.6/site-packages/pytagcloud/fonts
# Windosw OS : C:\Users\USER\Anaconda3\envs\pc36 (가상환경주소) \Lib\site-packages\pytagcloud\fonts
# 위 경로에 NanumBarunGothic.ttf 파일 옮기기
import random
import pytagcloud
import webbrowser

ranked_tags = count.most_common(40)
taglist = pytagcloud.make_tags(ranked_tags, maxsize=80)
pytagcloud.create_tag_image(taglist, 'wordcloud.jpg', size=(900, 600), fontname='Nobile', rectangular=False)

## ---(Sat Jun 23 12:38:12 2018)---
runfile('/Users/yul/.spyder-py3/naver_news.py', wdir='/Users/yul/.spyder-py3')
"""
Created on Sat Jun 23 12:41:59 2018

@author: yul
"""

import re
import requests
from bs4 import BeautifulSoup

req = requests.get('https://movie.naver.com/movie/bi/mi/basic.nhn?code=172420')
html = req.content
soup = BeautifulSoup(html, 'lxml') 

movielist = soup.find(name='div', attrs={'class':'score'})
movielist = movielist.find_all("p")



type(movielist
"""
Created on Sat Jun 23 12:41:59 2018

@author: yul
"""

import re
import requests
from bs4 import BeautifulSoup

req = requests.get('https://movie.naver.com/movie/bi/mi/basic.nhn?code=172420')
html = req.content
soup = BeautifulSoup(html, 'lxml') 

movielist = soup.find(name='div', attrs={'class':'score'})
movielist = movielist.find_all("p")



type(movielist)

## ---(Sat Jun 30 10:18:16 2018)---
ob','Jessica','Mary','John','Mel']
births = [968, 155, 77, 578, 973]
custom = [1, 5, 25, 13, 23232]

BabyDataSet = list(zip(names,births))
BabyDataSet
import pandas as pd
import sys

names = ['Bob','Jessica','Mary','John','Mel']
births = [968, 155, 77, 578, 973]
custom = [1, 5, 25, 13, 23232]

BabyDataSet = list(zip(names,births))
BabyDataSet
df['Births'].dtype
df=pd.DataFrame(data=BabyDataSet, columns = ['Names','Births'])
df.Births.dtype
df.info()
df.shape
df.head(3)
df['Names'].describe()
df['Names'].unique()