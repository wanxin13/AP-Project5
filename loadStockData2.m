function [dates,rbeme_25,Size,BEME] = loadStockData2(path)

rbeme_25 = xlsread(path,2,'B4:Z1088');

date = xlsread(path,2,'A4:A1088');
date = num2str(date)
dates = datenum(date,'yyyymm');


Size = xlsread(path,2,'AC4:BA1088');
BEME = xlsread(path,2,'BD4:CB1088');