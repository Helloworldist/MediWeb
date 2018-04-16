############ 테이블 통합 ###########3

library(plyr)

table_united<-merge(table_info, table_eval, by='item.addr') #eval과 info테이블 INNER JOIN
table_united<-unique(table_united) #혹시 모를 중복 제거

#####################################

table_region<-data.frame()

analyze<-function(sido, sggu) 
{
  for(i in 1:nrow(table_united))
  {
    if((sido==as.character(table_united$item.sidoCdNm[i]))
       &&(sggu==as.character(table_united$item.sgguCdNm[i]))) 
    {
      if(length(table_region)==0)
      {
        table_region<-table_united[i,]
        print(paste("if문",i,sep=""))
      }
      else
      {  
        table_region<-rbind.fill(test, table_united[i,])      
        print(paste("else문",i,sep=""))
      }
    }
  }
}


#######################################3
