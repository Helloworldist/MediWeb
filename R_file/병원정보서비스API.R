install.packages("XML")  # XML형식의 데이터 다루기 위해 설치
install.packages("RCurl") # 페이지 형식을 읽기 위해(getForm()함수 사용 위해)

library(XML)
library(RCurl)
library(plyr)

url1<-"http://apis.data.go.kr/B551182/hospInfoService/"
category<- "getHospBasisList"
url2<-"?serviceKey="
key<-"8H4WapzXJEl6ly5SVzhKi6418TEKuE5Mdk3Wj8PrYfGSv8nW1ZsJO2Plmh5oA1jZzg42rqaQy6%2FNnDRUZrdbdQ%3D%3D"
url3<-"&numOfRows=100"
url4<-"&pageNo="

table<- data.frame()

requestURL <- paste(url1, category, url2, key, url3, url4, sep="")
page = getForm(paste(requestURL, "1", sep= ""), query="")
doc = xmlToDataFrame(page)
totalDN = as.numeric(doc[2,6])
totalPN = (totalDN%/%100)+1

for(pageNum in 1:totalPN)
{
  URL<- paste(requestURL, pageNum, sep="")
  page=getForm(URL, query="")
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
      table<-ex
    }
    else
      table<-rbind.fill(table, ex)
  }
}

#####################################################3

ykihoList<-subset(table, select=item.ykiho)

head(ykihoList)

for(i in 1:10)
{
  print(ykihoList[i,1])
}