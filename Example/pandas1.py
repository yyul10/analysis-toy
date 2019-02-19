#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jun 30 10:18:26 2018

@author: yul
"""
import pandas as pd
import sys

names = ['Bob','Jessica','Mary','John','Mel']
births = [968, 155, 77, 578, 973]
custom = [1, 5, 25, 13, 23232]

BabyDataSet = list(zip(names,births))
BabyDataSet

df=pd.DataFrame(data=BabyDataSet, columns = ['Names','Births'])

df.to_csv('births.csv',index=True, header=True)
df.to_csv('births.csv',index=False, header=False)
newdf = pd.read_csv('births.csv')
newdf = pd.read_csv('births.csv', names=['Names','Births'])

# 파일 삭제
import os
os.remove('births.csv')

# 데이터 타입 체크
df.dtypes
df.Births.dtype
df['Births'].dtype

# 데이터 살펴보기
df.shape
df.info()
df.head(3)
df.tail(1)
df['Names'].describe() #기본적인 통계
df['Names'].unique()
Sorted = df.sort_values(['Births'], ascending=False)
Sorted.head(1)
df['Births'].max()

# 데이터 조작(병합)
df_row = pd.DataFrame([["Donald", 111]], columns=['Names', 'Births'])
newdf = df.append(df_row)

newdf.loc[0]
newdf = newdf.reset_index(drop=True)

# 무작위 수 이용하기
import random
names = ['Bob','Jessica','Mary','John','Mel']
random.seed(500)
random_names = [random.choice(names) for i in range(10)]
random_births = [random.choice(births) for i in range(10)]
random_custom = [random.choice(custom) for i in range(10)]
BabyDataSet = list(zip(random_names, random_births, custom))
df = pd.DataFrame(data = BabyDataSet, 
                  columns=['Names', 'Births', 'Custom'])
df['Names'].unique()

# 범주형 데이터 그룹 연산
name = df.groupby('Names') #그룹바이 데이터타입으로 원래의 타입과는 다름
df2 = name.sum() #그룹안에서만의 SUM을 계산, 원래의 데이터타입으로 돌아감
df2
df2['Births'].value_counts()


##2
int_array = [0,1,2,3,4,5,6,7,8,9]

# Dataframe 생성
df = pd.DataFrame(int_array)
df


# Dataframe column 생성
df.columns = ['Rev']
df

df['NewCol'] = 5
df

# Dataframe column 삭제
del df['NewCol']


# Dataframe column 조작
df['NewCol'] = df['NewCol'] + 1
df


# Dataframe column 조작 2
df['test'] = 3
df['col'] = df['Rev']
df


# Dataframe row 조작
i = ['a','z','x','d','e','f','g','h','i','j']
df.index = i
df


# Dataframe row 접근
df.loc['f']
df.loc['a':'d']
df.iloc[0:3]


# Dataframe column 접근
df['Rev']
df['Rev', 'test'] #컬럼 접근에는 [[]]
df[['Rev', 'test', 'col']]


# 종합
df.loc[df.index[0:3], 'Rev']
df.loc[df.index[5:], 'col']
df.loc[df.index[:3], ['col', 'test']]
df.iloc[df.index[:3], 0:2]
df.iloc[:3, 0:2]

df.head()
df.tail()
df.info()
df['Rev'].value_counts()
df.shape

#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import pandas as pd
import numpy.random as np

np.seed(111)

# 연습용 데이터셋 생성 함수
def CreateDataSet(Number=1):
    
    Output = []
    
    for i in range(Number):
        rng = pd.date_range(start='1/1/2009', end='12/31/2012', freq='W-MON')
        data = np.randint(low=25,high=1000,size=len(rng))
        status = [1,2,3]
        random_status = [status[np.randint(low=0,high=len(status))] for i in range(len(rng))]
        states = ['GA','FL','fl','NY','NJ','TX']
        random_states = [states[np.randint(low=0,high=len(states))] for i in range(len(rng))]    
        Output.extend(zip(random_states, random_status, data, rng))
        
    return Output

CreateDataSet(Number=1)
# 연습용 데이터셋 생성
dataset = CreateDataSet(4)
df = pd.DataFrame(data=dataset, columns=['State','Status','CustomerCount','StatusDate'])
df.info()
df.head(5)


# datetime object를 index로 사용
df.index = df['StatusDate']
df.head()
del df['StatusDate']


# Dataframe feature 전처리
df['State'].unique()
df['State'] = df.State.apply(lambda x: x.upper())


# 조건에 맞는 데이터 선택,마스크에 해당되는 것만 리턴
mask = (df['Status'] == 1)
df = df[mask]


# 조건에 맞게 데이터 변경
mask = (df['State'] == 'NJ')
df['State'][mask] = 'NY'
df['State'].unique()


# 조건에 맞는 데이터 중, index를 기준으로 정렬
sortdf = df[df['State']=='NY'].sort_index(axis=0)
sortdf.head(10)


# 그룹 연산 적용
Daily = df.groupby(['State','StatusDate']).sum()
Daily.head()
Daily.index


# 이상치 계산하여 새로운 feature로 추가 (월 단위로 이상치 측정)
# transform 함수 : 각 원소는 그대로 유지하되, 원소간의 연산 결과를 새로운 피처로 사용 : 데일리에 모두 적용됨
StateYearMonth = Daily.groupby([Daily.index.get_level_values(0), 
                                Daily.index.get_level_values(1).year, 
                                Daily.index.get_level_values(1).month])
Daily['Lower'] = StateYearMonth['CustomerCount'].transform( lambda x: x.quantile(q=.25) - (1.5*x.quantile(q=.75)-x.quantile(q=.25)) )
Daily['Upper'] = StateYearMonth['CustomerCount'].transform( lambda x: x.quantile(q=.75) + (1.5*x.quantile(q=.75)-x.quantile(q=.25)) )
Daily['Max'] = StateYearMonth['CustomerCount'].transform( lambda x: x.max() )
Daily['Outlier'] = (Daily['CustomerCount'] < Daily['Lower']) | (Daily['CustomerCount'] > Daily['Upper']) 


# 이상치 제외
Daily = Daily[Daily['Outlier'] == False]

