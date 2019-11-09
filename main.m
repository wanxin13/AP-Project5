% main.m
% This script when run should compute all values and make all plots
% required by the project.
% To do so, you must fill the functions in the functions/ folder,
% and create scripts in the scripts/ folder to make the required
% plots.

% Add folders to path
addpath('./functions/','./scripts/');

% Add plot defaults
plotDefaults;

%% Exercise 1
T = 1085;

[dates,rmrf,rsmb,rhml,rf,rumd,Ire] = loadStockData1('C:\Users\wc145\Desktop\ECON676\PS5\Problem_Set5.xls');
% data missing in umd(momentum factor)
for i = 1:T
    if rumd(i,1) == -999
        rumd(i,1) = NaN;
    end
end
% regress on regression indicator 
b_m = regress(rmrf, [ones(T,1), Ire]);
ave_m = mean(rmrf);
std_m = std(rmrf);
ave_m_r = b_m(1)+b_m(2);
t_m = (ave_m_r - ave_m)*sqrt(T)/std_m;

b_smb = regress(rsmb, [ones(T,1), Ire]);
ave_smb = mean(rsmb);
std_smb = std(rsmb);
ave_smb_r = b_smb(1)+b_smb(2);
t_smb = (ave_smb_r - ave_smb)*sqrt(T)/std_smb;

b_hml = regress(rhml, [ones(T,1), Ire]);
ave_hml = mean(rhml);
std_hml = std(rhml);
ave_hml_r = b_hml(1)+b_hml(2);
t_hml = (ave_hml_r - ave_hml)*sqrt(T)/std_hml;

b_umd = regress(rumd, [ones(T,1), Ire]);
ave_umd = nanmean(rumd);
std_umd = nanstd(rumd);
ave_umd_r = b_umd(1)+b_umd(2);
t_umd = (ave_umd_r - ave_umd)*sqrt(T)/std_umd;
% earn less risk premium during resession but not significantly less during
% recessions. However, UMD has significantly less returns!!

%% 1b
T = 1085;
n = 25;
[dates,rmrf,rsmb,rhml,rf,rumd,Ire] = loadStockData1('C:\Users\wc145\Desktop\ECON676\PS5\Problem_Set5.xls');
[dates,rbeme_25,Size,BEME] = loadStockData2('C:\Users\wc145\Desktop\ECON676\PS5\Problem_Set5.xls');
[dates,rwl_25,Size_wl,ret212] = loadStockData3('C:\Users\wc145\Desktop\ECON676\PS5\Problem_Set5.xls');
% data missing losers and winners returns
for i = 1:T   
    for j = 1:n
        if rwl_25(i,j) <= -99.9
            rwl_25(i,j) = NaN;
        end
    end
end
for i = 1:T   
    for j = 1:n
        if Size_wl(i,j) < 0 
            Size_wl(i,j) = NaN;
        end
    end
end
for i = 1:T   
    for j = 1:n
        if ret212(i,j) <= -99.9
            ret212(i,j) = NaN;
        end
    end
end
% smallest growth        
b_SG = regress(rbeme_25(:,1)-rf(:,1), [ones(T,1), Ire]);
ave_SG_r = b_SG(1) + b_SG(2);
% smallest value
b_SV = regress(rbeme_25(:,5)-rf(:,1), [ones(T,1), Ire]);
ave_SV_r = b_SV(1) + b_SV(2);
% largest growth
b_LG = regress(rbeme_25(:,21)-rf(:,1), [ones(T,1), Ire]);
ave_LG_r = b_LG(1) + b_LG(2);
% largest value 
b_LV = regress(rbeme_25(:,25)-rf(:,1), [ones(T,1), Ire]);
ave_LV_r = b_LV(1) + b_LV(2);
% small is less than large and growth is less than value, still collect the
% HML premium

% smallest loser        
b_SLoser = regress(rwl_25(:,1)-rf(:,1), [ones(T,1), Ire]);
ave_SLoser_r = b_SLoser(1) + b_SLoser(2);
% smallest winner
b_SWinner = regress(rwl_25(:,5)-rf(:,1), [ones(T,1), Ire]);
ave_SWinner_r = b_SWinner(1) + b_SWinner(2);
% largest loser
b_LLoser = regress(rwl_25(:,21)-rf(:,1), [ones(T,1), Ire]);
ave_LLoser_r = b_LLoser(1) + b_LLoser(2);
% largest winner
b_LWinner = regress(rwl_25(:,25)-rf(:,1), [ones(T,1), Ire]);
ave_LWinner_r = b_LWinner(1) + b_LWinner(2);
% large is less than small and loser is less than winner, still collect the
% SMB and UMD premium

%% Exercise 21
T = 1085;
n = 25;
[dates,rmrf,rsmb,rhml,rf,rumd,Ire] = loadStockData1('C:\Users\wc145\Desktop\ECON676\PS5\Problem_Set5.xls');
[dates,rbeme_25,Size,BEME] = loadStockData2('C:\Users\wc145\Desktop\ECON676\PS5\Problem_Set5.xls');
[dates,rwl_25,Size_wl,ret212] = loadStockData3('C:\Users\wc145\Desktop\ECON676\PS5\Problem_Set5.xls');

% regress on fama french factors RMRF, SMB, HML
beta = zeros(25,4);
for i = 1:25
    beta(i,:) = regress(rbeme_25(:,i),[ones(T,1),rmrf,rsmb,rhml]);
end

% regress on beta_m, ln(size), ln(BE/ME)
[ln_size,ln_beme] = Dataprocess1(Size,BEME,n,T);
gamma_1 = zeros(1079,4);
for i = 1:T-6
      gamma_1(i,:) = regress(rbeme_25(i+6,:)',[ones(n,1) beta(:,2) ln_size(i+5,:)' ln_beme(i+6,:)']);
end
ave_1 = mean(gamma_1);
std_1 = std(gamma_1);
tstat_1 = (ave_1./std_1)*sqrt(T-6); 
% regress on beta_m, beta_SMB, beta_HML
gamma_2 = zeros(1085,4);
for i = 1:T
      gamma_2(i,:) = regress(rbeme_25(i,:)',[ones(n,1) beta(:,2) beta(:,3) beta(:,4)]);
end
ave_2 = mean(gamma_2);
std_2 = std(gamma_2);
tstat_2 = (ave_2./std_2)*sqrt(T);
% regress on beta_m, ln(size), ln(BE/ME),beta_SMB, beta_HML
gamma_3 = zeros(1079,6);
for i = 1:T-6
      gamma_3(i,:) = regress(rbeme_25(i+6,:)',[ones(n,1) beta(:,2) ln_size(i+5,:)' ln_beme(i+6,:)' beta(:,3) beta(:,4)]);
end
ave_3 = mean(gamma_3);
std_3 = std(gamma_3);
tstat_3 = (ave_3./std_3)*sqrt(T-6);
% characteristic model seems better sig

%% Exercise 22
T = 1085;
n = 25;
[dates,rmrf,rsmb,rhml,rf,rumd,Ire] = loadStockData1('C:\Users\wc145\Desktop\ECON676\PS5\Problem_Set5.xls');
[dates,rbeme_25,Size,BEME] = loadStockData2('C:\Users\wc145\Desktop\ECON676\PS5\Problem_Set5.xls');
[dates,rwl_25,Size_wl,ret212] = loadStockData3('C:\Users\wc145\Desktop\ECON676\PS5\Problem_Set5.xls');

% after Jan 1963 regress on fama french factors RMRF, SMB, HML
beta = zeros(25,4);
for i = 1:25
    beta(i,:) = regress(rbeme_25(439:end,i),[ones(T-438,1),rmrf(439:end),rsmb(439:end),rhml(439:end)]);
end

% after Jan 1963 regress on beta_m, ln(size), ln(BE/ME)
[ln_size,ln_beme] = Dataprocess1(Size,BEME,n,T);
gamma_1 = zeros(T-6,4);
for i = 433:T-6
      gamma_1(i,:) = regress(rbeme_25(i+6,:)',[ones(n,1) beta(:,2) ln_size(i+5,:)' ln_beme(i+6,:)']);
end
gamma_1 = gamma_1(433:end,:);
ave_1 = mean(gamma_1);
std_1 = std(gamma_1);
tstat_1 = (ave_1./std_1)*sqrt(T-438); 
% after Jan 1963 regress on beta_m, beta_SMB, beta_HML
gamma_2 = zeros(1085,4);
for i = 439:T
      gamma_2(i,:) = regress(rbeme_25(i,:)',[ones(n,1) beta(:,2) beta(:,3) beta(:,4)]);
end
gamma_2 = gamma_2(439:end,:);
ave_2 = mean(gamma_2);
std_2 = std(gamma_2);
tstat_2 = (ave_2./std_2)*sqrt(T-438);
% after Jan 1963 regress on beta_m, ln(size), ln(BE/ME),beta_SMB, beta_HML
gamma_3 = zeros(1079,6);
for i = 433:T-6
      gamma_3(i,:) = regress(rbeme_25(i+6,:)',[ones(n,1) beta(:,2) ln_size(i+5,:)' ln_beme(i+6,:)' beta(:,3) beta(:,4)]);
end
gamma_3 = gamma_3(433:end,:);
ave_3 = mean(gamma_3);
std_3 = std(gamma_3);
tstat_3 = (ave_3./std_3)*sqrt(T-438);
% gamma on markets are all negative, characteristic seems better

%% Exercise 31
T = 1085;
n = 25;
[dates,rmrf,rsmb,rhml,rf,rumd,Ire] = loadStockData1('C:\Users\wc145\Desktop\ECON676\PS5\Problem_Set5.xls');
[dates,rbeme_25,Size,BEME] = loadStockData2('C:\Users\wc145\Desktop\ECON676\PS5\Problem_Set5.xls');
[dates,rwl_25,Size_wl,ret212] = loadStockData3('C:\Users\wc145\Desktop\ECON676\PS5\Problem_Set5.xls');
% data missing losers and winners returns
for i = 1:T   
    for j = 1:n
        if rwl_25(i,j) <= -99.9
            rwl_25(i,j) = NaN;
        end
    end
end
% return == -99.99
for i = 1:T   
    for j = 1:n
        if Size_wl(i,j) < 0 
            Size_wl(i,j) = NaN;
        end
    end
end
for i = 1:T   
    for j = 1:n
        if ret212(i,j) <= -99.9
            ret212(i,j) = NaN;
        end
    end
end
% regress on fama french factors RMRF, SMB, UMD
beta = zeros(25,4);
for i = 1:25
    beta(i,:) = regress(rwl_25(:,i),[ones(T,1),rmrf,rsmb,rumd]);
end

% regress on beta_m, ln(size), ret212
for i = 1:T
    for j = 1:n
       ln_size(i,j) = log(Size_wl(i,j)); 
    end
end

gamma_1 = zeros(1078,4);
for i = 1:T-7
      gamma_1(i,:) = regress(rwl_25(i+7,:)',[ones(n,1) beta(:,2) ln_size(i+6,:)' ret212(i+7,:)']);
end
ave_1 = mean(gamma_1);
std_1 = std(gamma_1);
tstat_1 = (ave_1./std_1)*sqrt(T-7);
std_11 = ave_1./tstat_1;
% regress on beta_m, beta_SMB, beta_UMD
gamma_2 = zeros(1085,4);
for i = 1:T
      gamma_2(i,:) = regress(rwl_25(i,:)',[ones(n,1) beta(:,2) beta(:,3) beta(:,4)]);
end
gamma_2 = gamma_2(7:end,:);
ave_2 = mean(gamma_2);
std_2 = std(gamma_2);
tstat_2 = (ave_2./std_2)*sqrt(T);
std_22 = ave_2./tstat_2;
% regress on beta_m, ln(size), ret212,beta_SMB, beta_UMD
gamma_3 = zeros(1078,6);
for i = 1:T-7
      gamma_3(i,:) = regress(rwl_25(i+7,:)',[ones(n,1) beta(:,2) ln_size(i+6,:)' ret212(i+7,:)' beta(:,3) beta(:,4)]);
end
ave_3 = mean(gamma_3);
std_3 = std(gamma_3);
tstat_3 = (ave_3./std_3)*sqrt(T-7);
std_33 = ave_3./tstat_3;
% characteristic model seems to perform better since it has sigificantly
% size risk premium and momentum risk premium
stockname={'Small-Low';'Small-2';'Small-3';'Small-4';'Small-5';'2-Low';'2-2';'2-3';'2-4';'2-High';'3-Low';'3-2';'3-3';'3-4';'3-High';'4-Low';'4-2';'4-3';'4-4';'4-High';'Big-Low';'5-2';'5-3';'5-4';'5-High'};
beta_M = beta(:,2);
beta_SMB = beta(:,3);
beta_UMD = beta(:,4);
table1 = table(stockname,beta_M,beta_SMB,beta_UMD);
%% Exercise 32
T = 1085;
n = 25;
[dates,rmrf,rsmb,rhml,rf,rumd,Ire] = loadStockData1('C:\Users\wc145\Desktop\ECON676\PS5\Problem_Set5.xls');
[dates,rbeme_25,Size,BEME] = loadStockData2('C:\Users\wc145\Desktop\ECON676\PS5\Problem_Set5.xls');
[dates,rwl_25,Size_wl,ret212] = loadStockData3('C:\Users\wc145\Desktop\ECON676\PS5\Problem_Set5.xls');
% data missing losers and winners returns
for i = 1:T   
    for j = 1:n
        if rwl_25(i,j) <= -99.9
            rwl_25(i,j) = NaN;
        end
    end
end
for i = 1:T   
    for j = 1:n
        if Size_wl(i,j) < 0 
            Size_wl(i,j) = NaN;
        end
    end
end
for i = 1:T   
    for j = 1:n
        if ret212(i,j) <= -99.9
            ret212(i,j) = NaN;
        end
    end
end
% from Jan 1963 regress on fama french factors RMRF, SMB, UMD
beta = zeros(25,4);
for i = 1:25
    beta(i,:) = regress(rwl_25(439:end,i),[ones(T-438,1),rmrf(439:end,1),rsmb(439:end,1),rumd(439:end,1)]);
end

% from Jan 1963 regress on beta_m, ln(size), ret212
for i = 1:T
    for j = 1:n
       ln_size(i,j) = log(Size_wl(i,j)); 
    end
end

gamma_1 = zeros(1078,4);
for i = 432:T-7
      gamma_1(i,:) = regress(rwl_25(i+7,:)',[ones(n,1) beta(:,2) ln_size(i+6,:)' ret212(i+7,:)']);
end
gamma_1 = gamma_1(432:end,:);
ave_1 = mean(gamma_1);
std_1 = std(gamma_1);
tstat_1 = (ave_1./std_1)*sqrt(T-438); 
std_11 = ave_1./tstat_1;
% from Jan 1963 regress on beta_m, beta_SMB, beta_UMD
gamma_2 = zeros(1085,4);
for i = 439:T
      gamma_2(i,:) = regress(rwl_25(i,:)',[ones(n,1) beta(:,2) beta(:,3) beta(:,4)]);
end
gamma_2 = gamma_2(439:end,:);
ave_2 = mean(gamma_2);
std_2 = std(gamma_2);
tstat_2 = (ave_2./std_2)*sqrt(T-438);
std_22 = ave_2./tstat_2;
% from Jan 1963 regress on beta_m, ln(size), ret212,beta_SMB, beta_UMD
gamma_3 = zeros(1078,6);
for i = 432:T-7
      gamma_3(i,:) = regress(rwl_25(i+7,:)',[ones(n,1) beta(:,2) ln_size(i+6,:)' ret212(i+7,:)' beta(:,3) beta(:,4)]);
end
gamma_3 = gamma_3(432:end,:);
ave_3 = mean(gamma_3);
std_3 = std(gamma_3);
tstat_3 = (ave_3./std_3)*sqrt(T-438);
std_33 = ave_3./tstat_3;
% characteristic model seems to perform better this time. ret212 in (3)
% significantly different from 0 while other factors did not.
stockname={'Small-Low';'Small-2';'Small-3';'Small-4';'Small-5';'2-Low';'2-2';'2-3';'2-4';'2-High';'3-Low';'3-2';'3-3';'3-4';'3-High';'4-Low';'4-2';'4-3';'4-4';'4-High';'Big-Low';'5-2';'5-3';'5-4';'5-High'};
beta_M_1963 = beta(:,2);
beta_SMB_1963 = beta(:,3);
beta_UMD_1963 = beta(:,4);
table1 = table(stockname,beta_M_1963,beta_SMB_1963,beta_UMD_1963)


