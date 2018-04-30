import rpy2.robjects.packages as rpackages  # rpy2의 패키지 모듈 임포트
from rpy2.robjects.vectors import StrVector # R 스트링 베터

utils=rpackages.importr('utils')    # R 기본 utils 패키지 임포트
utils.chooseCRANmirror(ind=1)   # 리스트에서 첫번째 미러 선택

packname=('XML', 'RCurl', 'plyr')   # 다운로드 할 패키지

utils.install_packages(StrVector(packname)) # R 유틸리티 패키지로 packname의 패키지 설치