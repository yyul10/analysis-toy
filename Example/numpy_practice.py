import numpy as np

# float type의 ndarray 생성
arr_data = [6, 7.5, 8, 0,1]
n_arr = np.array(arr_data)
print(n_arr)
n_str_arr = np.array(["a", "dfd", "33"])


# ndarray의 shape 확인
print(n_arr.shape)

# n차원 데이터 생성
arr_data2 = [
    [1,2,3,4],
    [5,6,7,8]
]
n_arr2 = np.array(arr_data2)
print(n_arr2)
print(n_arr2.shape)

# 모든 원소가 0으로 구성된 array생성
print(np.zeros((3,6)))

# 모든 원소가 1로 구성된 array생성
print(np.ones(10))

# 0~14까지의 수로 구성된 array생성
print(np.arange(15))

# 데이터 타입 확인
print(n_arr.dtype)
print(n_arr2.dtype)

##### Numpy 배열과 일반 배열의 속도 비교

# 10의 7승 데이터 생성
arr_data3 = np.arange(10e7)
arr_list = arr_data3.tolist()

# python list timecheck 함수
def list_timecheck(list, num):
    for idx,val in enumerate(list):
        list[idx] = val * num
    return list

# 시간 측정
import time
start_time = time.time()
list_timecheck(arr_list, 2)
print("--- %s seconds ---" % (time.time() - start_time))

start_time2 = time.time()
arr_data3 * 2
print("--- %s seconds ---" % (time.time() - start_time2))

###################################

# 데이터 타입 설정
arr_data4 = np.array([1,2,3,4,5], dtype = np.int64)
print("Type of arr : ",arr_data4.dtype)

float_arr = arr_data4.astype(np.float64)
print("\nAbout float_arr : ", float_arr, ", ", float_arr.dtype)

###################################

# array 연산
arr1 = np.array([
    [1,2,3],
    [4,5,6]
], dtype = np.float64)

arr2 = np.array([[7,8,9],[10,11,12]], dtype = np.float64)
arr3 = np.array([[5,6,7],[10,8]], dtype = np.float64) # error

# 사칙연산
print("arr1 + arr2 = ")
print(arr1 + arr2,"\n")
print("arr1 - arr2 = ")
print(arr1 - arr2,"\n")
print("arr1 * arr2 = ")
print(arr1 * arr2,"\n")
print("arr1 / arr2 = ")
print(arr1 / arr2,"\n")

# --> 사칙연산은 모두 같은 위치의 성분끼리 연산해줌. shape이 반드시 맞아야 가능.

# 상수배, 제곱근, 역수
print("2 x arr1 = ")
print(2 * arr1)
print("\n arr^0.5 = ")
print(arr1 ** 0.5)
print("\n 1/arr1 = ")
print(1 / arr1)

# array 인덱싱.
arr = np.arange(10)
print("arr[5] : ", arr[5])
print("arr[5:8] = ",arr[5:8])
arr[5:8] = 12
print("\n",arr)

# 2d array 접근법
arr2d = np.array([
    [1,2,3,4],
    [5,6,7,8],
    [9,10,11,12],
    [13,14,15,16]
])

arr2d[2,1:3]
arr2d[1:3,:]
arr2d[:2,1:3] = 0

# 3d array 접근법
arr3d = np.zeros((4,4,3))
arr3d[1,1,1]
arr3d[1:2,1:3,1]
arr3d[1:3,1:3,1]
arr3d[1:3,1:3,1:3]

# 마스킹 기법
names = np.array(["YKT","YSJ","HJS","YKT","HJS","YSJ","YSJ"])
data = np.random.randn(7,4)

print("names")
print(names)
print("data")
print(data)

names == "YKT" # 마스킹을 논리값으로 반환

print("YKT: ", data[names=="YKT",:])
print("YSJ: ", data[names=="YSJ",:])
print("YKT or YSJ : ", data[(names=="YKT")|(names=="YSJ"),:])

print(data[:,3])
print(data[:,3]<0)

data[data[:,3]<0,:]=0
print(data)

import numpy as np

arr_data1 = np.arange(1,10)
arr_data1

# 제곱근, 로그 : Data Scaling에 활용 가능
np.sqrt(arr_data1)
np.log10(arr_data1)

# 두 ndarray중 최대값으로 통합
x=np.random.randn(8)
y=np.random.randn(8)
np.maximum(x,y)

# series 데이터처럼 연산하기
arr_data2=np.random.randn(5,4)
arr_data2.sum()
arr_data2.mean()
arr_data2.sum(axis=0)
arr_data2.sum(axis=1)
arr_data2>0
arr_data2[arr_data2[:, 3]>0, :]
(arr_data2>0).sum()

# 정렬하기
arr_data3 = np.random.randn(8)
np.sort(arr_data3)
np.sort(arr_data3)[::-1] #descending

arr_data4 = np.random.rand(5,3)
np.sort(arr_data4,axis=0)
np.sort(arr_data4,axis=1)

# 150개의 랜덤값 중, 상위 5%에 위치하는 값을 출력하기
large_arr=np.random.rand(150)
np.sort(large_arr)[::-1]

np.sort(large_arr)[::-1][int(150*0.05)]
np.sort(large_arr)[::-1][int(len(large_arr) * 0.05)]

# unique 함수 사용
names=np.array(["Charles","Kilho","Hayoung","Charles","Hayoung","Kilho","Kilho"])
ints=np.array([3,3,3,2,2,1,1,4,4])
np.unique(names)
np.unique(ints)

#### 모델링 활용 예제

# 훈련셋과 시험셋 로딩
import keras
from keras.utils import np_utils
from keras.datasets import mnist
from keras.models import Sequential
from keras.layers import Dense, Activation

(X_train, Y_train), (X_test, Y_test) = mnist.load_data()

# 데이터셋 전처리
X_train = X_train.reshape(60000, 784).astype('float32') / 255.0
X_test = X_test.reshape(10000, 784).astype('float32') / 255.0

# one-hot encoding
Y_train = np_utils.to_categorical(Y_train)
Y_test = np_utils.to_categorical(Y_test)

# 모델링 구성
model = Sequential()
model.add(Dense(units=64, input_dim=28*28, activation='relu'))
model.add(Dense(units=10, activation='softmax'))

model.compile(loss='categorical_crossentropy', optimizer='sgd', metrics=['accuracy'])

hist = model.fit(X_train, Y_train, epochs=3, batch_size=32)

# 샘플 테스트
from numpy import argmax

xhat_idx = np.random.choice(X_test.shape[0], 5)
xhat = X_test[xhat_idx]
yhat = model.predict_classes(xhat)

for i in range(5):
    print('True : ' + str(argmax(Y_test[xhat_idx[i]])) + ', Predict : ' + str(yhat[i]))
    

## 참고용 실행 코드
argmax(Y_test[xhat_idx[0]])
Y_test[xhat_idx[0]]
