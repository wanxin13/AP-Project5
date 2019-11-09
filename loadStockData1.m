function [dates,rmrf,rsmb,rhml,rf,rumd,Ire] = loadStockData1(path)

rmrf = xlsread(path,1,'B4:B1088');
rsmb = xlsread(path,1,'C4:C1088');
rhml = xlsread(path,1,'D4:D1088');
rf = xlsread(path,1,'E4:E1088');
rumd = xlsread(path,1,'F4:F1088');
Ire = xlsread(path,1,'G4:G1088');

date = xlsread(path,1,'A4:A1088');
date = num2str(date);
dates = datenum(date,'yyyymm');

