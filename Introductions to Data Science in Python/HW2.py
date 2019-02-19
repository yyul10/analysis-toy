#1

import random

v = random.randint(1, 10)
count = 0

while True:
    temp_input = input('Guess Number :')
    in_n = int(temp_input)
    if in_n > v:
        print('Lower')
        count += 1
    elif in_n < v:
        print('Higher')
        count += 1
    else:
        print('Correct, Number of attempts : ', str(count))
        exit()

#2

input_list = []
abs_list = []

while True:
    try:
        temp_input2 = float(input('Input Data : '))
        input_list.append(temp_input2)
        if temp_input2 == 'done':
            break
    except:
        temp_input2 = str(input('Input Data : '))
        input_list.append(temp_input2)
        if temp_input2 == 'done':
            break

print(input_list)

def AbsList():
    for i in range(len(input_list)-1):
        if type(input_list[i]) == float :
            abs_list.append(abs(input_list[i]))
        elif i == len(input_list):
            break

AbsList()
print(abs_list)

#3

import operator

temp_input3 = input('Write a sentence : ')
counts = dict()

words = temp_input3.split(" ")

for word in words :
    if not counts:
        counts[word] = 1
    else:
        if word not in counts:
            counts[word] = 1
        else :
            counts[word] += 1
#dict[key].append -> list

print(counts)
print(max(counts, key=counts.get))


#4

line = 'From pedro@isi.edu Mon Sep 5 15:24:10 2016'

user_start = line.find(" ")
at_sign = line.find("@", user_start)
last_sign = line.find(" ", at_sign)

username = line[user_start + 1 : at_sign]
hostname = line[at_sign + 1 : last_sign]

print(username)
print(hostname)


