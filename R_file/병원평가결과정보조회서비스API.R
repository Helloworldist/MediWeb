install.packages("XML")  # XML형식의 데이터 다루기 위해 설치
install.packages("RCurl") # 페이지 형식을 읽기 위해(getForm()함수 사용 위해)

library(XML)
library(RCurl)
library(plyr)

#####################################

url_eval_1<-"http://apis.data.go.kr/B551182/hospAsmRstInfoService/"
category_eval<- "getHospWhlAsmRstList"
url_eval_2<-"?serviceKey="
key<-"8H4WapzXJEl6ly5SVzhKi6418TEKuE5Mdk3Wj8PrYfGSv8nW1ZsJO2Plmh5oA1jZzg42rqaQy6%2FNnDRUZrdbdQ%3D%3D"
url_eval_3<-"&pageNo=1"
url_eval_4<-"&ykiho="

table_eval<- data.frame()
ykNum<-nrow(ykihoList)

requestURL_eval <- paste(url_eval_1, category_eval, url_eval_2, key, url_eval_3, url_eval_4, sep="")

#####################################

for(a in 1:ykNum)
{
  page = getForm(paste(requestURL_eval, ykihoList[a,1], sep= ""), query="")
  doc1=xmlParse(page)
  doc1=xmlToList(doc1)

  ex <- data.frame(doc1[2]$body$items[1])
  if(length(table)==0)
  {
    table_eval<-ex
  }
  else
    table_eval<-rbind.fill(table_eval, ex)
}

######################################3

table_united1<-cbind(table_info, table_eval)
