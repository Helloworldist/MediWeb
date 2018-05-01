#######################################
###   테이블 통합 및 정의
#######################################
install.packages('ggmap')
install.packages('ggplot2')

library(ggmap)
library(ggplot2)
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
      return(end_num)
    }
  }
}

analyze1<-function(sido, sggu) 
{
  table_region<-data.frame() # 데이터프레임 초기화
  s<-start(sido, sggu)
  e<-end(sido, sggu, s)
  print(paste("그 중 평가된 ", sido, "의 ", sggu, "병원 수는 ", e-s+1, "곳 이며", sep=""))
  table_region<<-table_united[s:e,] # 통합 테이블로부터 선택된 지역에 대한 병원을 분류
}

analyze1_sub<-function(sido, sggu)
{
  table_info<-table_info[order(table_info$item.sidoCdNm, table_info$item.sgguCdNm),]
  
  for(i in 1:nrow(table_info))
  {
    if((sido==as.character(table_info$item.sidoCdNm[i]))
       &&(sggu==as.character(table_info$item.sgguCdNm[i]))) {
      start_num=i
      break
    }
  }
  
  for(i in start_num:nrow(table_info))
  {
    if(!((sido==as.character(table_info$item.sidoCdNm[i]))
         &&(sggu==as.character(table_info$item.sgguCdNm[i])))) {
      end_num=i-1
      break
    }
  }
  
  print(paste0(sido, "에서 ",  sggu, "의 전체 병원 수는 ", end_num-start_num+1, "곳입니다"))
}

showHosp<-function()
{
   print(unique(table_region$item.yadmNm.x))
}
#######################################
###   사용자 질의에 따른 분석
#######################################
table_united<-table_united[order(table_united$item.sidoCdNm, table_united$item.sgguCdNm),]

analyze2<-function(query){
  switch(query,
         '중이염'={
           table_result<<-data.frame()
           table_region<<-table_region[order(table_region$item.asmGrd24),]
           for(i in 1:nrow(table_region))
           {
             if(as.character(table_region$item.asmGrd24[i])=='등급제외' 
                || as.character(table_region$item.asmGrd24[i])=='평가제외')
               next
             table_result<<-rbind.fill(table_result, table_region[i,])
           }
           table_result<<-table_result[order(table_result$item.asmGrd24),]
           print(paste0(query,"에 대한 우수 평가 병원은 다음과 같습니다"))
           print(head(table_result$item.yadmNm.x, 10))
         },
         '급성심근경색'={
           table_result<<-data.frame()
           table_region<<-table_region[order(table_region$item.asmGrd),]
           for(i in 1:nrow(table_region ))
           {
             if(as.character(table_region$item.asmGrd1[i])=='등급제외' 
                || as.character(table_region$item.asmGrd1[i])=='평가제외')
               next
             table_result<<-rbind.fill(table_result, table_region[i,])
           }
           table_result<<-table_result[order(table_result$item.asmGrd1),]
           print(paste0(query,"에 대한 우수 평가 병원은 다음과 같습니다"))
           print(head(table_result$item.yadmNm.x, 10))
         },
         '골수이식'={
           table_result<<-data.frame()
           table_region<<-table_region[order(table_region$item.asmGrd10),]
           for(i in 1:nrow(table_region ))
           {
             if(as.character(table_region$item.asmGrd10[i])=='등급제외' 
                || as.character(table_region$item.asmGrd10[i])=='평가제외')
               next
             table_result<<-rbind.fill(table_result, table_region[i,])
           }
           table_result<<-table_result[order(table_result$item.asmGrd10),]
           print(paste0(query,"에 대한 우수 평가 병원은 다음과 같습니다"))
           print(head(table_result$item.yadmNm.x, 10))
         },
         '위암'={
           table_result<<-data.frame()
           table_region<<-table_region[order(table_region$item.asmGrd11, table_region$item.asmGrd16),]
           for(i in 1:nrow(table_region ))
           {
             if(((as.character(table_region$item.asmGrd11[i])=='등급제외' 
                || as.character(table_region$item.asmGrd11[i])=='평가제외'))&&
               ((as.character(table_region$item.asmGrd16[i])=='등급제외' 
                   || as.character(table_region$item.asmGrd16[i])=='평가제외')))
               next
             table_result<<-rbind.fill(table_result, table_region[i,])
           }
           table_result<<-table_result[order(table_result$item.asmGrd11, table_result$item.asmGrd16),]
           print(paste0(query,"에 대한 우수 평가 병원은 다음과 같습니다"))
           print(head(table_result$item.yadmNm.x, 10))
         },
         '간암'={
           table_result<<-data.frame()
           table_region<<-table_region[order(table_region$item.asmGrd12, table_region$item.asmGrd15),]
           for(i in 1:nrow(table_region ))
           {
             if(((as.character(table_region$item.asmGrd12[i])=='등급제외' 
                  || as.character(table_region$item.asmGrd12[i])=='평가제외'))&&
                ((as.character(table_region$item.asmGrd15[i])=='등급제외' 
                  || as.character(table_region$item.asmGrd15[i])=='평가제외')))
               next
             table_result<<-rbind.fill(table_result, table_region[i,])
           }
           table_result<<-table_result[order(table_result$item.asmGrd12, table_result$item.asmGrd15),]
           print(paste0(query,"에 대한 우수 평가 병원은 다음과 같습니다"))
           print(head(table_result$item.yadmNm.x, 10))
         },
         '제왕절개'={
           table_result<<-data.frame()
           table_region<<-table_region[order(table_region$item.asmGrd13),]
           for(i in 1:nrow(table_region ))
           {
             if(as.character(table_region$item.asmGrd13[i])=='등급제외' 
                || as.character(table_region$item.asmGrd13[i])=='평가제외')
               next
             table_result<<-rbind.fill(table_result, table_region[i,])
           }
           table_result<<-table_result[order(table_result$item.asmGrd13),]
           print(paste0(query,"에 대한 우수 평가 병원은 다음과 같습니다"))
           print(head(table_result$item.yadmNm.x, 10))
         },
         '관상동맥우회술'={
           table_result<<-data.frame()
           table_region<<-table_region[order(table_region$item.asmGrd14),]
           for(i in 1:nrow(table_region ))
           {
             if(as.character(table_region$item.asmGrd14[i])=='등급제외' 
                || as.character(table_region$item.asmGrd14[i])=='평가제외')
               next
             table_result<<-rbind.fill(table_result, table_region[i,])
           }
           table_result<<-table_result[order(table_result$item.asmGrd14),]
           print(paste0(query,"에 대한 우수 평가 병원은 다음과 같습니다"))
           print(head(table_result$item.yadmNm.x, 10))
         },
         '뇌졸중'={
           table_result<<-data.frame()
           table_region<<-table_region[order(table_region$item.asmGrd2),]
           for(i in 1:nrow(table_region ))
           {
             if(as.character(table_region$item.asmGrd2[i])=='등급제외' 
                || as.character(table_region$item.asmGrd2[i])=='평가제외')
               next
             table_result<<-rbind.fill(table_result, table_region[i,])
           }
           table_result<<-table_result[order(table_result$item.asmGrd2),]
           print(head(table_result$item.yadmNm.x, 10))
         },
         '요양병원'={
           table_result<<-data.frame()
           table_region<<-table_region[order(table_region$item.asmGrd20),]
           for(i in 1:nrow(table_region ))
           {
             if(as.character(table_region$item.asmGrd20[i])=='등급제외' 
                || as.character(table_region$item.asmGrd20[i])=='평가제외')
               next
             table_result<<-rbind.fill(table_result, table_region[i,])
           }
           table_result<<-table_result[order(table_result$item.asmGrd20),]
           print(paste0(query,"에 대한 우수 평가 병원은 다음과 같습니다"))
           print(head(table_result$item.yadmNm.x, 10))
         },
         '당뇨병'={
           table_result<<-data.frame()
           table_region<<-table_region[order(table_region$item.asmGrd22),]
           for(i in 1:nrow(table_region ))
           {
             if(as.character(table_region$item.asmGrd22[i])=='등급제외' 
                || as.character(table_region$item.asmGrd22[i])=='평가제외')
               next
             table_result<<-rbind.fill(table_result, table_region[i,])
           }
           table_result<<-table_result[order(table_result$item.asmGrd22),]
           print(paste0(query,"에 대한 우수 평가 병원은 다음과 같습니다"))
           print(head(table_result$item.yadmNm.x, 10))
         },
         '대장암'={
           table_result<<-data.frame()
           table_region<<-table_region[order(table_region$item.asmGrd23),]
           for(i in 1:nrow(table_region ))
           {
             if(as.character(table_region$item.asmGrd23[i])=='등급제외' 
                || as.character(table_region$item.asmGrd23[i])=='평가제외')
               next
             table_result<<-rbind.fill(table_result, table_region[i,])
           }
           table_result<<-table_result[order(table_result$item.asmGrd23),]
           print(paste0(query,"에 대한 우수 평가 병원은 다음과 같습니다"))
           print(head(table_result$item.yadmNm.x, 10))
         },
         '유방암'={
           table_result<<-data.frame()
           table_region<<-table_region[order(table_region$item.asmGrd25),]
           for(i in 1:nrow(table_region ))
           {
             if(as.character(table_region$item.asmGrd25[i])=='등급제외' 
                || as.character(table_region$item.asmGrd25[i])=='평가제외')
               next
             table_result<<-rbind.fill(table_result, table_region[i,])
           }
           table_result<<-table_result[order(table_result$item.asmGrd25),]
           print(paste0(query,"에 대한 우수 평가 병원은 다음과 같습니다"))
           print(head(table_result$item.yadmNm.x, 10))
         },
         '폐암'={
           table_result<<-data.frame()
           table_region<<-table_region[order(table_region$item.asmGrd26),]
           for(i in 1:nrow(table_region ))
           {
             if(as.character(table_region$item.asmGrd26[i])=='등급제외' 
                || as.character(table_region$item.asmGrd26[i])=='평가제외')
               next
             table_result<<-rbind.fill(table_result, table_region[i,])
           }
           table_result<<-table_result[order(table_result$item.asmGrd26),]
           print(paste0(query,"에 대한 우수 평가 병원은 다음과 같습니다"))
           print(head(table_result$item.yadmNm.x, 10))
         },
         '천식'={
           table_result<<-data.frame()
           table_region<<-table_region[order(table_region$item.asmGrd27),]
           for(i in 1:nrow(table_region ))
           {
             if(as.character(table_region$item.asmGrd27[i])=='등급제외' 
                || as.character(table_region$item.asmGrd27[i])=='평가제외')
               next
             table_result<<-rbind.fill(table_result, table_region[i,])
           }
           table_result<<-table_result[order(table_result$item.asmGrd27),]
           print(paste0(query,"에 대한 우수 평가 병원은 다음과 같습니다"))
           print(head(table_result$item.yadmNm.x, 10))
         },
         '폐질환'={
           table_result<<-data.frame()
           table_region<<-table_region[order(table_region$item.asmGrd28),]
           for(i in 1:nrow(table_region ))
           {
             if(as.character(table_region$item.asmGrd28[i])=='등급제외' 
                || as.character(table_region$item.asmGrd28[i])=='평가제외')
               next
             table_result<<-rbind.fill(table_result, table_region[i,])
           }
           table_result<<-table_result[order(table_result$item.asmGrd28),]
           print(paste0(query,"에 대한 우수 평가 병원은 다음과 같습니다"))
           print(head(table_result$item.yadmNm.x, 10))
         },
         '폐렴'={
           table_result<<-data.frame()
           table_region<<-table_region[order(table_region$item.asmGrd29),]
           for(i in 1:nrow(table_region ))
           {
             if(as.character(table_region$item.asmGrd29[i])=='등급제외' 
                || as.character(table_region$item.asmGrd29[i])=='평가제외')
               next
             table_result<<-rbind.fill(table_result, table_region[i,])
           }
           table_result<<-table_result[order(table_result$item.asmGrd29),]
           print(paste0(query,"에 대한 우수 평가 병원은 다음과 같습니다"))
           print(head(table_result$item.yadmNm.x, 10))
         },
         '고혈압'={
           table_result<<-data.frame()
           table_region<<-table_region[order(table_region$item.asmGrd3),]
           for(i in 1:nrow(table_region ))
           {
             if(as.character(table_region$item.asmGrd3[i])=='등급제외' 
                || as.character(table_region$item.asmGrd3[i])=='평가제외')
               next
             table_result<<-rbind.fill(table_result, table_region[i,])
           }
           table_result<<-table_result[order(table_result$item.asmGrd3),]
           print(paste0(query,"에 대한 우수 평가 병원은 다음과 같습니다"))
           print(head(table_result$item.yadmNm.x, 10))
         },
         '중환자실'={
           table_result<<-data.frame()
           table_region<<-table_region[order(table_region$item.asmGrd30),]
           for(i in 1:nrow(table_region ))
           {
             if(as.character(table_region$item.asmGrd30[i])=='등급제외' 
                || as.character(table_region$item.asmGrd30[i])=='평가제외')
               next
             table_result<<-rbind.fill(table_result, table_region[i,])
           }
           table_result<<-table_result[order(table_result$item.asmGrd30),]
           print(paste0(query,"에 대한 우수 평가 병원은 다음과 같습니다"))
           print(head(table_result$item.yadmNm.x, 10))
         },
         '혈액투석'={
           table_result<<-data.frame()
           table_region<<-table_region[order(table_region$item.asmGrd4),]
           for(i in 1:nrow(table_region ))
           {
             if(as.character(table_region$item.asmGrd4[i])=='등급제외' 
                || as.character(table_region$item.asmGrd4[i])=='평가제외')
               next
             table_result<<-rbind.fill(table_result, table_region[i,])
           }
           table_result<<-table_result[order(table_result$item.asmGrd4),]
           print(paste0(query,"에 대한 우수 평가 병원은 다음과 같습니다"))
           print(head(table_result$item.yadmNm.x, 10))
         },
         '정신과'={
           table_result<<-data.frame()
           table_region<<-table_region[order(table_region$item.asmGrd5),]
           for(i in 1:nrow(table_region ))
           {
             if(as.character(table_region$item.asmGrd5[i])=='등급제외' 
                || as.character(table_region$item.asmGrd5[i])=='평가제외')
               next
             table_result<<-rbind.fill(table_result, table_region[i,])
           }
           table_result<<-table_result[order(table_result$item.asmGrd5),]
           print(paste0(query,"에 대한 우수 평가 병원은 다음과 같습니다"))
           print(head(table_result$item.yadmNm.x, 10))
         },
         '고관절치환술'={
           table_result<<-data.frame()
           table_region<<-table_region[order(table_region$item.asmGrd7),]
           for(i in 1:nrow(table_region ))
           {
             if(as.character(table_region$item.asmGrd7[i])=='등급제외' 
                || as.character(table_region$item.asmGrd7[i])=='평가제외')
               next
             table_result<<-rbind.fill(table_result, table_region[i,])
           }
           table_result<<-table_result[order(table_result$item.asmGrd7),]
           print(paste0(query,"에 대한 우수 평가 병원은 다음과 같습니다"))
           print(head(table_result$item.yadmNm.x, 10))
         },
         '췌장암'={
           table_result<<-data.frame()
           table_region<<-table_region[order(table_region$item.asmGrd18),]
           for(i in 1:nrow(table_region ))
           {
             if(as.character(table_region$item.asmGrd8[i])=='등급제외' 
                || as.character(table_region$item.asmGrd8[i])=='평가제외')
               next
             table_result<<-rbind.fill(table_result, table_region[i,])
           }
           table_result<<-table_result[order(table_result$item.asmGrd8),]
           print(paste0(query,"에 대한 우수 평가 병원은 다음과 같습니다"))
           print(head(table_result$item.yadmNm.x, 10))
         },
         '식도암'={
           table_result<<-data.frame()
           table_region<<-table_region[order(table_region$item.asmGrd9),]
           for(i in 1:nrow(table_region ))
           {
             if(as.character(table_region$item.asmGrd9[i])=='등급제외' 
                || as.character(table_region$item.asmGrd9[i])=='평가제외')
               next
             table_result<<-rbind.fill(table_result, table_region[i,])
           }
           table_result<<-table_result[order(table_result$item.asmGrd9),]
           print(paste0(query,"에 대한 우수 평가 병원은 다음과 같습니다"))
           print(head(table_result$item.yadmNm.x, 10))
         },
         # 그 외
         {
           table_result<<-data.frame()
           table_result<<-table_region[order(table_region$item.asmGrd17,table_region$item.asmGrd18,
                                             table_region$item.asmGrd19,table_region$item.asmGrd21,
                                             table_region$item.asmGrd6),]
           print(paste(query,"에 대한 평가가 없으므로 비질병평가항목으로 제공합니다", sep=""))
           print(head(table_result$item.yadmNm.x, 10))
         })
}


#######################################
###   분석
#######################################
options(digits = 13)

search<-function(sido, sggu, disease){
  print('======================================')
  analyze1_sub(sido, sggu)
  analyze1(sido, sggu)
  analyze2(disease)
  print('======================================')
  print("병원에 대한 정보를 보시려면 h(병원 순서)를 입력해주세요. 예)h(1), h(9)")
}

h<-function(x) {
  print(paste0("병원명 : ", as.character(table_result$item.yadmNm.x[x])))
  print(paste0("주소 : ", as.character(table_result$item.addr.x[x])))
  print(paste0("전화번호 : ", as.character(table_result$item.telno[x])))
  HosLocation<-c(lon=as.numeric(as.character(table_result$item.XPos[x])),
                 lat=as.numeric(as.character(table_result$item.YPos[x])))
  ggmap(get_map(location = HosLocation, zoom = 17, source = 'google', maptype = 'roadmap'))
}