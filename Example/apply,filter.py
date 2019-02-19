import pandas as pd
import numpy as np

# 깃헙 업로드 데이터 가져오기. 
# github.com 대신에 raw.githubusercontent.com 
# master/blob 에서 blob제거
url = 'https://raw.githubusercontent.com/guipsamora/pandas_exercises/master/04_Apply/Students_Alcohol_Consumption/student-mat.csv'
df = pd.read_csv(url, sep=',')
df.head()

# 데이터 부분집합 추출
stud_alcoh = df.loc[: , "school":"guardian"]
stud_alcoh.head()

# 함수 생성(일급객체로 활용)
captalizer = lambda x: x.upper()

# 범수형 변수 확인 및 대문자변환
stud_alcoh['Mjob'].value_counts()
stud_alcoh['Fjob'].value_counts()
stud_alcoh['Mjob'].apply(captalizer)
stud_alcoh['Fjob'].apply(captalizer)
stud_alcoh['Mjob'] = stud_alcoh['Mjob'].apply(captalizer)
stud_alcoh['Fjob'] = stud_alcoh['Fjob'].apply(captalizer)


stud_alcoh['legal_drinker']=None
stud_alcoh['legal_drinker']=stud_alcoh['age'].apply(lambda x : x>17)

# 조건함수 생성
def majority(x):
    if x > 17:
        return True
    else:
        return False

# 선언한 함수를 조건으로 적용하여 새로운 피처 생성
stud_alcoh['legal_drinker'] = stud_alcoh['age'].apply(majority)

# 익명함수로 동일한 쿼리
stud_alcoh['legal_drinker'] = stud_alcoh['age'].apply(lambda x: True if x > 17 else False)

# 단순 logic 연산으로 동일한 쿼리
stud_alcoh['legal_drinker'] = stud_alcoh['age'] > 17

# 데이터 부분집합 추출
stud_alcoh1 = df.loc[: , "school":"guardian"]
stud_alcoh2 = df[['school', 'guardian']]

# 여러가지 필터링 방법
more_than_16 = stud_alcoh1[stud_alcoh1.age >= 16]
middle_school = stud_alcoh1[(stud_alcoh1['age'] > 13) & (stud_alcoh1['age'] < 16)] #and & or |
not_T_status = stud_alcoh1[(stud_alcoh1['Pstatus'] != 'T')]
contains_G = stud_alcoh1[stud_alcoh1.famsize.str.contains('G')] # startswith 등 활용가능

custom_list = ['at_home', 'services']
column_list = ['Mjob','Fjob', 'reason']
mother_job = stud_alcoh1.loc[stud_alcoh1.Mjob.isin(custom_list), column_list] #isin 함수