import os
import csv
from moreinfo import getDetailinfo1, getDetailinfo2, getDetailinfo3

resultOfHos = []

file = open('./result.csv', 'r')
csvReader = csv.reader(file)

for row in csvReader:
	resultOfHos.append(row)
print("read done.")

file.close()

for i in range(1,10):
	print('========='+str(i)+'=========')
	print(resultOfHos[i-1][18])	# 병원명
	print(resultOfHos[i-1][16]) # 지도 X좌표
	print(resultOfHos[i-1][17]) # 지도 Y좌표
	print(resultOfHos[i-1][0]) # ykiho
	getDetailinfo1(resultOfHos[i-1][0])
	print('----')
	getDetailinfo2(resultOfHos[i-1][0])
	print('----')
	getDetailinfo3(resultOfHos[i-1][0])
	print('----')

