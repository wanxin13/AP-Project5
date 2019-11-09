function [dates,rwl_25,Size_wl,ret212] = loadStockData3(path)
% ret212 is the past 2 to 12 month return

rwl_25 = xlsread(path,3,'B4:Z1088');

date = xlsread(path,3,'A4:A1088');
date = num2str(date)
dates = datenum(date,'yyyymm');


Size_wl = xlsread(path,3,'AC4:BA1088');
ret212 = xlsread(path,3,'BD4:CB1088');