%% RachelTidalDataPlotting.m
%Compare the tide at locations around polder 32
%Determine lag times between sites
%Box and Whisker Plot of Lag Time around Polder 32
%Focus on lag difference between Sutarkhali and Nalian
%==========================================================================
clear; close all;
addpath(genpath('C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Scripts\Function\')); %add path to main directory for function files
load('C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Scripts\TideLags.mat')
%% Normalize Depth
SutDep2 = SutDep - mean(SutDep);
NalDep2 = NalDep - mean(NalDep);
ShibDep2 = ShibDep - mean(ShibDep);
BrickDep2 = BrickDep - mean(BrickDep);
%% How to Import Date Data
%NalDat2 = datetime(NalDat,'InputFormat','MM/dd/yy HH:mm:ss');
%NalDat2 = NalDat2';
%NalDat3 = datenum(NalDat2);
%save('C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Scripts\TideLags.mat') 
%% Find hide time maxima and compare to determin lag
[pks, locs] = findpeaks(SutDep2, 'MinPeakDistance',50);
location = SutDep2(locs, 1);          %time of each peak
[pksN, locsN] = findpeaks(NalDep2, 'MinPeakDistance',500);
locationN = NalDep2(locsN, 1);          %time of each peak
[pksB, locsB] = findpeaks(BrickDep2, 'MinPeakDistance',500);
locationB = BrickDep2(locsB, 1);          %time of each peak
[pksS, locsS] = findpeaks(ShibDep2, 'MinPeakDistance',50);
locationS = ShibDep2(locsS, 1);          %time of each peak
%==========================================================================
Sutt=SutDat3(locs);%Sutarkhali
Sutd=SutDep2(locs);
Nalt=NalDat3(locsN);%Nalian
Nald=NalDep2(locsN);
Shibt=ShibDat3(locsS);%Shibsha Forest Station
Shibd=ShibDep2(locsS);
Brickt=BrickDat3(locsB);%Brick Factory
Brickd=BrickDep2(locsB);
% Set calendar dates
startpt = datenum('Aug 28, 2015 14:00:00');
endpt = datenum('Sept 8, 2015  14:00:00');
% Calculate lags
s = find(Sutt >= startpt & Sutt <= endpt);
n = find(Nalt >= startpt & Nalt <= endpt); %hours
b = find(Brickt >= startpt & Brickt <= endpt);
sh = find(Shibt >= startpt & Shibt <= endpt); %hours
%% Calculate Lag Times
% Sutarkhali vs Nalian
lagdatenum = (Sutt(s)-Nalt(n));
maxS = datetime(Sutt(s), 'ConvertFrom', 'datenum');
maxN = datetime(Nalt(n), 'ConvertFrom', 'datenum');
lag = maxS-maxN;
maxlag = max(lag); minlag = min(lag);
meanlag = mean(lag);
% Sutarkhali vs Brick Forest
lagdatenumB = (Sutt(s)-Brickt(b));
maxB = datetime(Brickt(b), 'ConvertFrom', 'datenum');
lagB = maxS-maxB;
maxlagB = max(lagB); minlagB = min(lagB);
meanlagB = mean(lagB);
% Sutarkahli vs Shibsha Forest
lagdatenumSh = (Sutt(s)-Shibt(sh));
maxSh = datetime(Shibt(sh), 'ConvertFrom', 'datenum');
lagSh = maxS-maxSh;
maxlagSh = max(lagSh); minlagSh = min(lagSh);
meanlagSh = mean(lagSh);
% Create Table
AllNames = {'Nalian'; 'Brick Factory'; 'Shibsha Forest'};
AllMeans = {meanlag;meanlagB;meanlagSh};
AllMax = {maxlag;maxlagB;maxlagSh};
AllMin = {minlag;minlagB;minlagSh};
T = table(AllNames,AllMeans,AllMax,AllMin);%, 'VariableNames', {'Location','Mean Lag', 'Max Lag','Min Lag'})
%% Box and Whisker Plot of Lag Time around Polder 32
lag1 = datenum(lag)*24*60;
lagB1 = datenum(lagB)*24*60;
lagSh1 = datenum(lagSh)*24*60;
bxplot = [lag1',lagB1',lagSh1'];
%==========================================================================
h=figureFullScreen('Name','Lag Box Plot');
    set(gcf, 'Color', [1,1,1]);
    subplot(111)
        hl = boxplot(bxplot,'Color','k');
            for ih=1:6
                set(hl(ih,:),'LineWidth',2);
            end
            set(gcf, 'Color', [1,1,1]);
            set(gca,'XTickLabel',{'Nalian';'Brick Factory';'Shibsha Forest'})
            set(gca,'FontSize',16)
            ylabel('Lag Time (min)');
            title('\bf \fontsize{24} Lag Time prior to Sutarkhali Tidal Gauge');
% Save figure
%F    = getframe(h);
%imwrite(F.cdata, 'C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Figures\AllTideLagsBoxPlot.png', 'png')
%% Plot Tide at Sutarkhali vs Nalian and show the lag time
h=figureFullScreen('Name','Sutarkhali vs Nalian');
    set(gcf, 'Color', [1,1,1]);
    plotb=subplot(212);
        plot(Nalt(n),lag, 'k*','MarkerSize', 9);
            datetick('x');
            set(gca,'FontSize',16)
            ylabel('Lag (hh:mm:ss)');
            %xlabel('Date');
            xlim([startpt endpt]);
            xt = xticks;
    ax1=subplot(211);
        plot(SutDat3, SutDep2,'k','LineWidth', 1);
            hold on
        plota=plot(NalDat3, NalDep2,'r','LineWidth', 1);
        %plotbb=plot(ShibDat3, ShibDep2,'g','LineWidth', 1);
            ax1.XTick = xt;
            datetick(ax1,'x','keepticks');
            set(gca,'FontSize',16)
        plot(Sutt(s),Sutd(s), 'ko','MarkerSize', 7);
        plot(Nalt(n),Nald(n), 'ro','MarkerSize', 7);
        %plot(Shibt(sh),Shibd(sh), 'go','MarkerSize', 7);
            ylabel('Depth (m)');
        title('\bf \fontsize{24} Sutarkhali vs. Nalian');
        legend('Sutarkhali','Nalian');
        xlim([startpt endpt]);
        linkaxes([plota plotb],'x')
        % Create textbox
            annotation(h,'textbox',...
                [0.134854166666667 0.384767556874382 0.0288106728008352 0.546983184965379],...
                'String','a',...
                'LineStyle','none',...
                'FontWeight','bold',...
                'FontSize',22,...
                'FitBoxToText','off');
        % Create textbox
            annotation(h,'textbox',...
                [0.134854166666667 0.384767556874382 0.0436358653093187 0.0692383778437189],...
                'String',{'b'},...
                'LineStyle','none',...
                'FontWeight','bold',...
                'FontSize',22,...
                'FitBoxToText','off');
% Save figure
%F = getframe(h);
%imwrite(F.cdata, 'C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Figures\SutvNalTide.png', 'png')
%% Plot Tide from 9/2-9/7 of 2015 at all locations around polder 32
startpt = datenum('Sept 2, 2015 00:00:00');
endpt = datenum('Sept 7, 2015  00:00:00');
% Calculate lags
s = find(Sutt >= startpt & Sutt <= endpt);
n = find(Nalt >= startpt & Nalt <= endpt); %hours
b = find(Brickt >= startpt & Brickt <= endpt);
sh = find(Shibt >= startpt & Shibt <= endpt); %hours
% Make Plot
h=figureFullScreen('Name','Sutarkhali vs Nalian');
    set(gcf, 'Color', [1,1,1]);
    plot(SutDat3, SutDep2,'k','LineWidth', 1);
        hold on
    plot(NalDat3, NalDep2, 'b','LineWidth', 1);
        xlim([startpt endpt]);
        datetick('x', 'keeplimits');
        set(gca,'FontSize',16)
    plot(ShibDat3, ShibDep2,'r','LineWidth', 1);
    plot(BrickDat3, BrickDep2,'g','LineWidth', 1);
    plot(Sutt(s),Sutd(s), 'ko','MarkerSize', 7);
    plot(Nalt(n),Nald(n), 'bo','MarkerSize', 7);
    plot(Shibt(sh),Shibd(sh), 'ro','MarkerSize', 7);
    plot(Brickt(b),Brickd(b), 'go','MarkerSize', 7);
        ylabel('Depth (m)');
        title('\bf \fontsize{24} Sutarkhali vs. Nalian');
        legend('Sutarkhali','Nalian','Shibsha Forest', 'Brick Factory');
% Save figure
%F    = getframe(h);
%imwrite(F.cdata, 'C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Figures\AllTideLags.png', 'png')
