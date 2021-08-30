import pandas as pd
from pandas import read_excel
import xlsxwriter
from pytrends.request import TrendReq
pytrend = TrendReq()
import time
import datetime
from datetime import datetime, date, time

#Reading excel file
#file_name='D:\Python for DA\Chap 1\keytrends.xlsx'
#Data_Frame = pd.read_excel(file_name, sheet_name= 'key_word', engine= 'openpyxl')

#Extracting columns headers of DF into a list
#list_colheaders = list(Data_Frame.columns.values)
#for x in list_colheaders:
#    BT1(x)

#
def BT1(colname): 
    list_keywords = Data_Frame[colname].values.tolist()    
    #print(list_keywords)
    #df2.remove("news")
    
    dataset = []

    for keyword in list_keywords:
        key_words = [keyword]
        pytrend.build_payload(kw_list=key_words, cat=0,
                              timeframe='2020-01-01 2020-12-31',
                              geo='VN')
        data = pytrend.interest_over_time()
        if not data.empty:
             data = data.drop(labels=['isPartial'],axis='columns')
             dataset.append(data)

    result = pd.concat(dataset, axis=1)       
    result.to_excel('trend.xlsx', engine='xlsxwriter', sheet_name = colname)

file_name='D:\Python for DA\Chap 1\keytrends.xlsx'
Data_Frame = pd.read_excel(file_name, sheet_name= 'key_word', engine= 'openpyxl')

#Extracting columns headers of DF into a list
list_colheaders = list(Data_Frame.columns.values)
for x in list_colheaders:
    BT1(x)







