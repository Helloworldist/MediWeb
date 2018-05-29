from bs4 import BeautifulSoup
import requests


def getDetailinfo1(ykiho):	

	info = []
	url='http://apis.data.go.kr/B551182/medicInsttDetailInfoService/'
	detailInfo1 = 'getDetailInfo?serviceKey=S9WEvSCrAevu5g77dqb0UyGoWrFdu8D7yyldkqgRFhJOL1Z%2Fow7c5RFe8Crs5ycZIdREt%2BhclvTNlTDd%2BBAPRg%3D%3D&pageNo=1&startPage=1&numOfRows=10&pageSize=20&ykiho='

	req = requests.get(url+detailInfo1+ykiho)
	html = req.text
	soup = BeautifulSoup(html, 'html.parser')

	lunchweek=soup.find('lunchweek') # lunchtime
	plcdir=soup.find('plcdir')
	plcnm=soup.find('plcnm')

	if lunchweek is not None:
		info.append(lunchweek.text)
	else:
		pass
	if plcdir is not None:
		info.append(plcdir.text)
	else:
		pass
	if plcnm is not None:
		info.append(plcnm.text)
	else:
		pass

	return info

def getDetailinfo2(ykiho):	
	info = ''
	url='http://apis.data.go.kr/B551182/medicInsttDetailInfoService/'
	detailInfo2 = 'getMdlrtSbjectInfoList?serviceKey=S9WEvSCrAevu5g77dqb0UyGoWrFdu8D7yyldkqgRFhJOL1Z%2Fow7c5RFe8Crs5ycZIdREt%2BhclvTNlTDd%2BBAPRg%3D%3D&pageNo=1&startPage=1&numOfRows=30&pageSize=10&ykiho='

	req = requests.get(url+detailInfo2+ykiho)
	html = req.text
	soup = BeautifulSoup(html, 'html.parser')

	dgsbjtcdnm=[]

	dgsbjtcdnm_n = soup.find_all('dgsbjtcdnm')

	for i in dgsbjtcdnm_n:
		info = info + i.text

	if dgsbjtcdnm is not None:
		return info
	else:
		pass	

def getDetailinfo3(ykiho):	
	info = []
	url='http://apis.data.go.kr/B551182/medicInsttDetailInfoService/'
	detailInfo3 = 'getTransportInfoList?serviceKey=S9WEvSCrAevu5g77dqb0UyGoWrFdu8D7yyldkqgRFhJOL1Z%2Fow7c5RFe8Crs5ycZIdREt%2BhclvTNlTDd%2BBAPRg%3D%3D&pageNo=1&startPage=1&numOfRows=30&pageSize=10&ykiho='

	req = requests.get(url+detailInfo3+ykiho)
	html = req.text
	soup = BeautifulSoup(html, 'html.parser')

	arivplc=[]
	lineno=[]

	arivplc_n = soup.find_all('arivplc')
	lineno_n = soup.find_all('lineno')

	for i in arivplc_n:
		info.append(i.text)

	for i in lineno_n:
		info.append(i.text)

	return info
