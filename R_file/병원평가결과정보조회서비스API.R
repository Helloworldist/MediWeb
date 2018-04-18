install.packages("XML")  # XML형식의 데이터 다루기 위해 설치
install.packages("RCurl") # 페이지 형식을 읽기 위해(getForm()함수 사용 위해)

library(XML)
library(RCurl)
library(plyr)

#####################################

url_eval_1<-"http://apis.data.go.kr/B551182/hospAsmRstInfoService/"
category_eval<- "getHospWhlAsmRstList"
url_eval_2<-"?serviceKey="
key_eval<-"S9WEvSCrAevu5g77dqb0UyGoWrFdu8D7yyldkqgRFhJOL1Z%2Fow7c5RFe8Crs5ycZIdREt%2BhclvTNlTDd%2BBAPRg%3D%3D"
url_eval_3<-"&pageNo=1"
url_eval_4<-"&ykiho="

table_eval<- data.frame()
table_ykihotmp<- data.frame()
ykNum<-nrow(ykihoList)

requestURL_eval <- paste(url_eval_1, category_eval, url_eval_2, key_eval, url_eval_3, url_eval_4, sep="")

############### 평가결과 긁어오기 ################

run=1
for(a in run:totalDN)
{
  page = getForm(paste(requestURL_eval, ykihoList[a,1], sep= ""), query="")
  doc1=xmlParse(page)
  doc1=xmlToList(doc1)
  
  ex <- data.frame(doc1[2]$body$items[1])
  if(length(ex)==0)
    next
  
  if(length(table_eval)==0)
  {
    table_eval<-ex
  }
  else
    table_eval<-rbind.fill(table_eval, ex)
  
  if(length(table_ykihotmp)==0)
  {
    table_ykihotmp<-as.data.frame(ykihoList[a,1])
  }
  else
  {
    table_ykihotmp<-rbind.fill(table_ykihotmp, as.data.frame(ykihoList[a,1]))
  }
  run=a+1
  print(a)
}
