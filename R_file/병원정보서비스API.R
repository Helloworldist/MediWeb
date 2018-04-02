install.packages("XML")  # XML형식의 데이터 다루기 위해 설치
install.packages("RCurl") # 페이지 형식을 읽기 위해(getForm()함수 사용 위해)

library(XML)
library(RCurl)
library(plyr)

#####################################

url_info_1<-"http://apis.data.go.kr/B551182/hospInfoService/"
category_info<- "getHospBasisList"
url_info_2<-"?serviceKey="
key<-"8H4WapzXJEl6ly5SVzhKi6418TEKuE5Mdk3Wj8PrYfGSv8nW1ZsJO2Plmh5oA1jZzg42rqaQy6%2FNnDRUZrdbdQ%3D%3D"
url_info_3<-"&numOfRows=100"
url_info_4<-"&pageNo="

table_info<- data.frame()

requestURL_info <- paste(url_info_1, category_info, url_info_2, key, url_info_3, url_info_4, sep="")
page = getForm(paste(requestURL_info, "1", sep= ""), query="")
doc = xmlToDataFrame(page)
totalDN = as.numeric(doc[2,6])
totalPN = (totalDN%/%100)+1

#####################################

for(pageNum in 1:totalPN)
{
  URL_info<- paste(requestURL_info, pageNum, sep="")
  page=getForm(URL_info, query="")
  doc = xmlParse(page)
  doc = xmlToList(doc)
  index = 100
  
  if(pageNum==totalPN)
  {
    index=totalDN - ((totalPN-1)*100)
  }
  
  
  for(i in 1:index)
  {
    ex <- data.frame(doc[2]$body$items[i])
    if(length(table)==0)
    {
      table_info<-ex
    }
    else
      table_info<-rbind.fill(table_info, ex)
  }
}

#####################################

ykihoList<-subset(table_info, select=item.ykiho)


