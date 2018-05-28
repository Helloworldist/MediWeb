from rpy2.robjects import r
import os
import rpy2.robjects.packages as rpackages
import rpy2.robjects as robj


utils=rpackages.importr('utils')	# R 기본 패키지 호출

robj.r('setwd("./")')
r.library('plyr')

robj.r('load("~/MediWeb-master/R_file/main.RData")')
robj.r('table_region<-data.frame()')

##### Category by Region #####

# start
robj.r('start<-function(sido_s, sggu_s){\n'
	'for(i in 1:nrow(table_united)){\n'
	'if((sido_s==as.character(table_united$item.sidoCdNm[i])) && '
	'(sggu_s==as.character(table_united$item.sgguCdNm[i]))) {\n'
	'start_num=i\n'
	'return(start_num)}}}')

# end
robj.r('end<-function(sido_e, sggu_e, start_num){\n'
	'for(i in start_num:nrow(table_united)){\n'
	'if(!((sido_e==as.character(table_united$item.sidoCdNm[i])) && '
	'(sggu_e==as.character(table_united$item.sgguCdNm[i])))) {\n'
	'end_num=i-1\n'
	'return(end_num)}}}')

# analyze1
robj.r('analyze1<-function(sido, sggu){\n'
	'table_region<-data.frame()\n'
	's<-start(sido, sggu)\n'
	'e<-end(sido, sggu, s)\n'
	'print(paste(sido, "의 ", sggu, "병원 수 : ", e-s+1, sep=""))\n'
	'table_region<<-table_united[s:e,]}')

robj.r('showHosp<-function(){'
	'print(unique(table_region$item.yadmNm.x))}')

# show Hospital
#robj.r('showHosp()')

##### Category by User's query #####
# order
robj.r('table_united<-table_united[order(table_united$item.sidoCdNm, table_united$item.sgguCdNm),]')

# analyze2
def analyze2(lo3):
	value = {"중이염":24, "급성심근경색":1, "골수이식":10, "위암":11, "간암":12,
			"제왕절개":13, "관상동맥우회술":14, "뇌졸중":2, "요양병원":20, "당뇨병":22,
			"대장암":23, "유방암":25, "폐암":26, "천식":27, "폐질환":28, "폐렴":29,
			"고혈압":3, "중환자실":30, "혈액투석":4, "정신과":5, "고관절치환술":7,
			"췌장암":8, "식도암":9}
	num = str(value.get(lo3))
	
	if lo3 not in value:
		print("평가결과가 없음")
	elif num == 11:
		{
			robj.r('table_result<<-data.frame()\n'
				'table_region<<-table_region[order(table_region$item.asmGrd'+str(num)+'),]\n'
				'for(i in 1:nrow(table_region)) {\n'
				'if(((as.character(table_region$item.asmGrd'+str(num)+'[i])=="등급제외" || as.character(table_region$item.asmGrd'+str(num)+'[i])=="평가제외")) &&'
				'(as.character(table_region$item.asmGrd16[i])=="등급제외" || as.character(table_region$item.asmGrd16[i])=="평가제외")))'
				'next\n'
				'table_result<<-rbind.fill(table_result, table_region[i,])}\n'
				'table_result<<-table_result[order(table_result$item.asmGrd'+str(num)+'),]\n'
				'print(head(table_result$item.yadmNm.x, 10))\n'
				'write.csv(table_result, file="result.csv", row.names=FALSE)')
		}
	elif num == 12:
		{
			robj.r('table_result<<-data.frame()\n'
				'table_region<<-table_region[order(table_region$item.asmGrd'+str(num)+'),]\n'
				'for(i in 1:nrow(table_region)) {\n'
				'if(((as.character(table_region$item.asmGrd'+str(num)+'[i])=="등급제외" || as.character(table_region$item.asmGrd'+str(num)+'[i])=="평가제외")) &&'
				'(as.character(table_region$item.asmGrd15[i])=="등급제외" || as.character(table_region$item.asmGrd15[i])=="평가제외")))'
				'next\n'
				'table_result<<-rbind.fill(table_result, table_region[i,])}\n'
				'table_result<<-table_result[order(table_result$item.asmGrd'+str(num)+'),]\n'
				'print(head(table_result$item.yadmNm.x, 10))\n'
				'write.csv(table_result, file="result.csv", row.names=FALSE)')
		}
	else:
		{
			robj.r('table_result<<-data.frame()\n'
				'table_region<<-table_region[order(table_region$item.asmGrd'+str(num)+'),]\n'
				'for(i in 1:nrow(table_region)) {\n'
				'if(as.character(table_region$item.asmGrd'+str(num)+'[i])=="등급제외" || as.character(table_region$item.asmGrd'+str(num)+'[i])=="평가제외")\n'
				'next\n'
				'table_result<<-rbind.fill(table_result, table_region[i,])}\n'
				'table_result<<-table_result[order(table_result$item.asmGrd'+str(num)+'),]\n'
				'print(head(table_result$item.yadmNm.x, 10))\n'
				'write.csv(table_result, file="result.csv", row.names=FALSE)')
		}
# execute
lo1='"' + str(input("시도입력 : "))+'"'
lo2='"' + str(input("시군구입력 : "))+'"'
lo3=str(input("질병명 입력 : "))


robj.r('analyze1('+lo1+','+lo2+')')
analyze2(lo3)
