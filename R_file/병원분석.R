#######################################
###   테이블 통합 및 정의
#######################################

library(plyr)

names(table_ykihotmp)<-c('item.ykiho')  # table_ykihotmp의 컬럼명 변경
table_eval<-cbind(table_eval, table_ykihotmp) # 평가테이블과 요양기호테이블 결합

table_united<-data.frame()
table_united<-merge(table_info, table_eval, by='item.ykiho') #eval과 info, 요양기호값 기준으로 JOIN
# 시도, 시군구 오름차순으로 정렬
table_united<-table_united[order(table_united$item.sidoCdNm, table_united$item.sgguCdNm),]
table_united<-unique(table_united) #혹시 모를 중복 제거

table_region<-data.frame() # 분류된 지역의 병원이 저장될 테이블

#######################################
###   지역별 분류(속도 개선)
#######################################
start<-function(sido_s, sggu_s) # analyze함수의 파라미터가 들어옴
{
  for(i in 1:nrow(table_united))  # 통합된 테이블 중 
  {
    if((sido_s==as.character(table_united$item.sidoCdNm[i]))
       &&(sggu_s==as.character(table_united$item.sgguCdNm[i]))) # 인자와 일치하는 지역의 시작 행번호 탐색
    {
      start_num=i
      print(start_num)
      return(start_num)
    }
  }
}

end<-function(sido_e, sggu_e, start_num)
{
  for(i in start_num:nrow(table_united))
  {
    if(!((sido_e==as.character(table_united$item.sidoCdNm[i]))
         &&(sggu_e==as.character(table_united$item.sgguCdNm[i])))) # 검색 지역의 끝 행번호 탐색
    {
      end_num=i-1
      print(end_num)
      return(end_num)
    }
  }
}

analyze1<-function(sido, sggu) 
{
  table_region<-data.frame() # 데이터프레임 초기화
  s<-start(sido, sggu)
  e<-end(sido, sggu, s)
  table_region<<-table_united[s:e,] # 통합 테이블로부터 선택된 지역에 대한 병원을 분류
}

#######################################
###   사용자 질의에 따른 분석
#######################################

analyze2<-function(query){
  
}


