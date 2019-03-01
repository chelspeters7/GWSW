clear; close all;
addpath(genpath('C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Scripts\Function\')); %add path to main directory for function files
load('C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Scripts\TideLags.mat')
load('C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Scripts\piezo.mat')

%%
AA = A(:,2)- nanmean(A(:,2));BB = B(:,2)- nanmean(B(:,2));tt = tidal(:,2)- nanmean(tidal(:,2));

startpt = datenum('Sept 1, 2014');
endpt = datenum('Oct 1, 2014');
startptshort = datenum('Sept 9, 2014');
endptshort = datenum('Sept 13, 2014');
startptshort2 = datenum('Sept 16, 2014');
endptshort2 = datenum('Sept 20, 2014');

%peaks
[pkst, locst] = findpeaks(tt, 'MinPeakDistance',50);
locationt = tidal(locst, 1);          %time of each peak

[pks1a, locs1a] = findpeaks(AA, 'MinPeakDistance',50);
location1a = A(locs1a, 1);          %time of each peak

[pks1b, locs1b] = findpeaks(BB, 'MinPeakDistance',50);
location1b = B(locs1b, 1); 

%calculate lags
%t = (location(location >= startpt & location <= endpt)-startpt)*24;
%a = (location1a(location1a >= startpt & location1a <= endpt)-startpt)*24; %hours
%b = (location1b(location1b >= startpt & location1b <= endpt)-startpt)*24;%lalt_s = (la_s-lt_s)*60; %minutes

%spring
lt_s = (locationt(locationt >= startptshort & locationt <= endptshort)-startptshort)*24;
la_s = (location1a(location1a >= startptshort & location1a <= endptshort)-startptshort)*24; %hours
lb_s = (location1b(location1b >= startptshort & location1b <= endptshort)-startptshort)*24;%lalt_s = (la_s-lt_s)*60; %minutes

%neap
lt_n = (locationt(locationt >= startptshort2 & locationt <= endptshort2)-startptshort2)*24;
la_n = (location1a(location1a >= startptshort2 & location1a <= endptshort2)-startptshort2)*24; %hours
lb_n = (location1b(location1b >= startptshort2 & location1b <= endptshort2)-startptshort2)*24;

%lags
lalt_s = (la_s-lt_s)*60; 
lblt_s = (lb_s-lt_s)*60; 
lalt_n = (la_n-lt_n)*60; %minutes
lblt_n = (lb_n-lt_n)*60;
Name = {'A','B','An','Bn'};
LagTable = table(lalt_s,lalt_n,lblt_s, lblt_n);

%% Normalize Depth
SutDep2 = SutDep - mean(SutDep);
NalDep2 = NalDep - mean(NalDep);
ShibDep2 = ShibDep - mean(ShibDep);
BrickDep2 = BrickDep - mean(BrickDep);
%%
[pks, locs] = findpeaks(SutDep2, 'MinPeakDistance',50);
location = SutDep2(locs, 1);          %time of each peak

[pksN, locsN] = findpeaks(NalDep2, 'MinPeakDistance',500);
locationN = NalDep2(locsN, 1);          %time of each peak

[pksB, locsB] = findpeaks(BrickDep2, 'MinPeakDistance',500);
locationB = BrickDep2(locsB, 1);          %time of each peak

[pksS, locsS] = findpeaks(ShibDep2, 'MinPeakDistance',50);
locationS = ShibDep2(locsS, 1);          %time of each peak

Sutt=SutDat3(locs); %datenum of each peak
Nalt=NalDat3(locsN);
Sutd=SutDep2(locs);
Nald=NalDep2(locsN);

Shibt=ShibDat3(locsS);
Brickt=BrickDat3(locsB);
Shibd=ShibDep2(locsS);
Brickd=BrickDep2(locsB);

%startpt = datenum('Aug 28, 2015 9:00:00');
%endpt = datenum('Sept 8, 2015  18:30:00');

startpt = datenum('Aug 28, 2015 14:00:00');
endpt = datenum('Sept 8, 2015  14:00:00');

%calculate lags
s = find(Sutt >= startpt & Sutt <= endpt);
n = find(Nalt >= startpt & Nalt <= endpt); %hours
b = find(Brickt >= startpt & Brickt <= endpt);
sh = find(Shibt >= startpt & Shibt <= endpt); %hours


%%
close all
startpt = datenum('Sept 2, 2015 00:00:00');
endpt = datenum('Sept 7, 2015  00:00:00');

h=figureFullScreen('Name','Lags');
    set(gcf, 'Color', [1,1,1]);
%plot(A(:,1), AA,'k','LineWidth', 1);
plot(B(:,1),BB, 'r', 'LineWidth', 1.5);
    hold on
            %plot(SutDat3, SutDep2*100,'g','LineWidth', 1);
            %plot(Sutt(s),Sutd(s), 'go','MarkerSize', 7);
plot(tidal(:,1), tt, 'k', 'LineWidth', 1.5);
plot(NalDat3, NalDep2*100, 'b','LineWidth', 1.5);
plot(Nalt(n),Nald(n)*100, 'bo','MarkerSize', 7);
plot(B(locs1b,1), pks1b, 'o', 'Color','red','MarkerSize', 7);
%plot(A(locs1a,1), pks1a, 'o', 'Color', 'blue','MarkerSize', 7);
plot(tidal(locst,1), pkst, 'o', 'Color', 'black','MarkerSize', 7);
    xlim([startpt endpt]);
    datetick('x', 'keeplimits');
    set(gca,'FontSize',16)
    grid on
    grid minor
    ylabel('Depth (cm)')
    
    formatOut = 'HH:MM AM';
            ttt = datestr(tidal(locst,1)', formatOut);
            %att = datestr(A(locs1a,1)', formatOut);
            btt = datestr(B(locs1b,1)', formatOut);
            ntt = datestr(Nalt(n)', formatOut);
                %stt = datestr(Sutt(s)', formatOut);
            dxt = 0.1; dyt = 0.1; dxt2= 0.05;% displacement so the text does not overlay the data points
            text(tidal(locst,1)+dxt2, pkst+dyt, ttt, 'Color', 'black','FontSize',12);
            %text(A(locs1a,1)+dxt, pks1a+dyt, att, 'Color', 'blue','FontSize',12);
            text(B(locs1b,1)+dxt, pks1b+dyt, btt, 'Color', 'red','FontSize',12);
            text(Nalt(n)+dxt, Nald(n)*100+dyt, ntt, 'Color', 'blue','FontSize',12);
                %text(Sutt(s)+dxt, Sutd(s)*100+dyt, ntt, 'Color', 'green','FontSize',12);
    legend('B','Sutarkhali Tidal Gauge','Nalian Tidal Gauge');
    
%%Save figure
%F    = getframe(h);
%imwrite(F.cdata, 'C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Figures\Site1Lag.png', 'png')

%%
startpt = datenum('Aug 28, 2015 14:00:00');
endpt = datenum('Sept 8, 2015  14:00:00');

%calculate lags
s = find(Sutt >= startpt & Sutt <= endpt); %find the datenum of each peak between
n= find(Nalt >= startpt & Nalt <= endpt);
tloc = find(locationt >= startpt & locationt <= endpt);
bloc= find(location1b >= startpt & location1b <= endpt);

%Lag between Sutarkhali tidal gauge and Nalian tidal gauge
lagdatenumS = (Nalt(n)-Sutt(s));
maxS = datetime(Sutt(s), 'ConvertFrom', 'datenum');
maxN = datetime(Nalt(n), 'ConvertFrom', 'datenum');
lagS = maxS-maxN;
maxlagS = max(lagS); minlagS = min(lagS);
meanlagS = mean(lagS);

%Lag between Nalian tidal gauge and B piezometer
lagdatenumB = (Nalt(n)-location1b(bloc)');
maxB = datetime(location1b(bloc), 'ConvertFrom', 'datenum');
maxB = maxB';
lagB = maxB-maxN;
maxlagB = max(lagB); minlagB = min(lagB);
meanlagB = mean(lagB);
medlagB = median(lagB);