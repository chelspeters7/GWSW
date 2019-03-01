%% Piezo_Data_Read.m
%=========================================================================
% Read piezometer, meterological, and tidal data from .cvs files. Clean
% dataset by removing invalid data points. 
clear;clc;close all
set(0,'defaultTextFontSize', 22)
set(0,'defaultAxesFontSize', 24)
set(0,'defaultLineMarkerSize', 2)
set(0,'defaultAxesFontName', 'Arial')
set(0,'defaultTextFontName', 'Arial')
addpath(genpath('C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Scripts\Function\')); %add path to main directory for function files
%% Read Site 1 and Site 2 data
%=========================================================================
% Read all data for Site 1 piezometers A and B
folder1='C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Data\1';
filetype1='*.csv'; 
f1=fullfile(folder1, filetype1);
d1=dir(f1);
site1 = cell(1, numel(d1));
for k=1:numel(d1)
    for j=1:3
        site1{k}=csvread(fullfile(folder1, d1(k).name), 66, 1);
    end
end
%=========================================================================
% Read all data for Site 2 piezometers C,D,F,G and E(shallow piezometer)
folder2='C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Data\2';
filetype2='*.csv';  % or xlsx
f2=fullfile(folder2, filetype2);
d2=dir(f2);
site2 = cell(1, numel(d2));
for k=1:numel(d2)
    for j=1:3
        site2{k}=csvread(fullfile(folder2, d2(k).name), 66, 1);
    end
end
%% Read tidal gauge, barometric, precipitation, and temperature data
folder4='C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Data\Other';
filetype4='*.csv';  % or xlsx
f4=fullfile(folder4, filetype4);
d4=dir(f4);
other = cell(1, numel(d4));
for k=1:numel(d4)
    for j=1:3
        other{k}=csvread(fullfile(folder4, d4(k).name), 66, 1);
    end
end
load('C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Data\Other\sut_press.mat');
%=========================================================================
% Clean Barometric data
baro = [other{6};other{7};other{8}];
baro(:,1)=x2mdate(baro(:,1));
baro((baro(:,1)==0),:) = NaN;
baro(23998:23999, :) = NaN;
baro(43152:43153, :) = NaN;
meanbaro = nanmean(baro(:,2))/10;
%=========================================================================
% Clean tidal gauge data
tidal1 = [other{1};other{2}];
tidal1(:,1)=x2mdate(tidal1(:,1));
tidal = [tidal1; sut.t',sut.press*100,sut.temp,sut.sal];
tidal2 = [other{3};other{4};other{5}]; 
tidal2(:,1)=x2mdate(tidal2(:,1));
tidal = [tidal;tidal2];
tidal((tidal(:,1)==0),:) = NaN;
cut = [find(tidal(:,2)>2000); find(tidal(:,3)>33); find(tidal(:,3)<20);find(tidal(:,4)<0.1)];
cut2 = find(tidal(70000:90000,4)<5.0);
tidal(cut,:) = NaN; tidal(70000+cut2,:) = NaN;
for xc = 7:length(tidal(:,1))-5
    if abs(tidal(xc,3)-tidal(xc+1,3)) > 2
        tidal(xc-7:xc+5,:)= NaN;
    end
    if abs(tidal(xc,4)-tidal(xc+1,4)) > 2
        tidal(xc-7:xc+5,:)= NaN;
    end
end
tidal([10580:10584,3880,3954:3956,12299:12305,12226:12228,12229:12232,29967:29973,31556,31706,56121,56122,63184,82261,82631,90903,93066],:) = NaN;
abc = find(isnan(tidal)); abcd = [abc+1; abc-1];
tidal(abcd, :) = NaN;
tidal(tidal(:,1)<1, :) = NaN;
tidal(:,2) = tidal(:,2) - meanbaro; % correct for mean baro pressure
tidal(:,5) = tidal(:,2)-nanmean(tidal(:,2)); %Water about mean
%=========================================================================
% Read meterological data
met = csvread('C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Data\Meterological\P32MetData.csv',1,0);
metx = datenum(met(:,1),met(:,2),met(:,3),met(:,4),met(:,5),met(:,6));
met(met<0) = NaN;
met(8090:8189,:) = NaN;
met(met(:,12)>100,:) = NaN;
%% Set dates that will be used for plotting
%=========================================================================
% Provide example initial and final date
in = '20140501';
fi = '20160601';
%=========================================================================
% Decompose with datevec, count number of months, and skip one month if day > 1
infi    = datevec({in,fi},'yyyymmdd');
nmonths = diff(infi(:,1:2))*[12 1]' + infi(1,2);
skipone = infi(1,3) ~= 1;
%=========================================================================
% Calculate dates 
out = datenum(infi(1), (infi(1,2) + skipone):nmonths, 1);
%% Clean piezometer data without smoothing salinity
%=========================================================================
% A
A = [site1{1};site1{2};site1{3};site1{4}]; A(:,1)=x2mdate(A(:,1));
A = cleandata_salinity(A);
A(1:1442,:) = NaN;
A(1:24583,2) = A(1:24583,2)-480.;
A(75936:end,2) = A(75936:end,2) - nanmean(A(75936:end,2))-nanmean(A(1:24583,2));
A(75936:end,2) = -A(75936:end,2);
A(:,2) = A(:,2) - meanbaro; % correct for mean baro pressure
A(:,2) = A(:,2) - 1.4186e+03; % convert to depth
As=A;
%=========================================================================
% B
B = [site1{5};site1{6};site1{7};site1{8};site1{9}]; B(:,1)=x2mdate(B(:,1));
B = cleandata_salinity(B);
B(1:915,:) = NaN;
B(13670:13674, :) = NaN;
B(:,2) = B(:,2)-892.; %correct for piezometer height and instrument depth
B(:,2) = B(:,2) - meanbaro; % correct for mean baro pressure
B(:,2) = B(:,2) - 1.0152e+03; % convert to depth
Bs=B;
%=========================================================================
%C
C = [site2{1};site2{2};site2{3};site2{4};site2{5}]; C(:,1)=x2mdate(C(:,1));
C = cleandata_salinity(C);
C(:,2) = C(:,2)-642.;
C(:,2) = C(:,2) - meanbaro; % correct for mean baro pressure
C(:,2) = C(:,2) -915; % convert to depth
Cs=C;
%=========================================================================
%D
D = [site2{6};site2{7};site2{8};site2{9}]; D(:,1)=x2mdate(D(:,1));
D = cleandata_salinity(D);
D(:,2) = D(:,2)-698.5;
D(:,2) = D(:,2) - meanbaro; % correct for mean baro pressure
D(:,2) = D(:,2) -1153; % convert to depth
Ds=D;
%=========================================================================
% F
F = [site2{15};site2{16}]; F(:,1)=x2mdate(F(:,1));
F = cleandata_salinity(F);
F(:,2) = F(:,2)-446.;
F(:,2) = F(:,2) - meanbaro; % correct for mean baro pressure
F(:,2) = F(:,2) -896.6; % convert to depth
Fs=F;
%=========================================================================
% G
G = [site2{17}]; G(:,1)=x2mdate(G(:,1));
G = cleandata_salinity(G);
G(7903:7976,:) = NaN;
G(:,2) = G(:,2)-444.;
G(:,2) = G(:,2) - meanbaro; % correct for mean baro pressure
G(:,2) = G(:,2) -992; % convert to depth
Gs=G;
%% Clean piezometer data (no plot)
%=========================================================================
% A
A = [site1{1};site1{2};site1{3};site1{4}]; A(:,1)=x2mdate(A(:,1));
A = cleandata(A);
A(1:1442,:) = NaN;
A(1:24583,2) = A(1:24583,2)-480.;
A(75936:end,2) = A(75936:end,2) - nanmean(A(75936:end,2))-nanmean(A(1:24583,2));
A(75936:end,2) = -A(75936:end,2);
A(:,2) = A(:,2) - meanbaro; % correct for mean baro pressure
A(:,2) = A(:,2) - 1.4186e+03; % convert to depth
%=========================================================================
% B
B = [site1{5};site1{6};site1{7};site1{8};site1{9}]; B(:,1)=x2mdate(B(:,1));
B = cleandata(B);
B(1:915,:) = NaN;
B(13670:13674, :) = NaN;
B(:,2) = B(:,2)-892.; %correct for piezometer height and instrument depth
B(:,2) = B(:,2) - meanbaro; % correct for mean baro pressure
B(:,2) = B(:,2) - 1.0152e+03; % convert to depth
%=========================================================================
%C
C = [site2{1};site2{2};site2{3};site2{4};site2{5}]; C(:,1)=x2mdate(C(:,1));
C = cleandata(C);
C(:,2) = C(:,2)-642.;
C(:,2) = C(:,2) - meanbaro; % correct for mean baro pressure
C(:,2) = C(:,2) -915; % convert to depth
%=========================================================================
%D
D = [site2{6};site2{7};site2{8};site2{9}]; D(:,1)=x2mdate(D(:,1));
D = cleandata(D);
D(:,2) = D(:,2)-698.5;
D(:,2) = D(:,2) - meanbaro; % correct for mean baro pressure
D(:,2) = D(:,2) -1153; % convert to depth
%=========================================================================
% F
F = [site2{15};site2{16}]; F(:,1)=x2mdate(F(:,1));
F = cleandata(F);
F(:,2) = F(:,2)-446.;
F(:,2) = F(:,2) - meanbaro; % correct for mean baro pressure
F(:,2) = F(:,2) -896.6; % convert to depth
%=========================================================================
% G
G = [site2{17}]; G(:,1)=x2mdate(G(:,1));
G = cleandata(G);
G(7903:7976,:) = NaN;
G(:,2) = G(:,2)-444.;
G(:,2) = G(:,2) - meanbaro; % correct for mean baro pressure
G(:,2) = G(:,2) -992; % convert to depth
%% Plot Figure 3
% Meteorological (a) and tidal data (b) measured between April 2014 and June 2016. 
inoutlim = [datenum('5-1-2014') datenum('6-1-2016')];
%=========================================================================  
h=figureFullScreen('Name','Figure 3 meteorological and tidal data');
    set(gcf, 'Color', [1,1,1]);
plota=subplot(211);
    [hAx,hLine1,hLine2] = plotyy(metx, met(:,12), metx, met(:,8));
    set(hLine1,'Color','k');
    %xlim([datenum('08-01-2014') datenum('06-01-2016')]);
    ylim(hAx(1),[0 100]); 
    ylim(hAx(2),[0 40]);
    set(hAx,'Xtick',[],'XTickLabel',[],'Xlim',inoutlim)
    set(gca,'Xtick',out,'XGrid','on')
    datetick('x','m','keepticks')
    datetick(hAx(1),'x','m','keepticks')
    set(hAx(2),'xtick',get(hAx(1),'xtick'))
    set(hAx(2),'Box','on'); %remove y1 ticks from the right side
    set(hAx(1),'Box','on'); %remove y2 ticks from the left side
    set(hAx(2),'ytick',[0,10,20,30,40],'FontSize',16)
    set(hAx(1),'ytick',[0,25,50,75,100],'FontSize',16)
    set(hAx(1),'Xgrid','on')
    set(hAx(2),'ycolor',[0 0 0])
    set(hAx(2),'xcolor',[0 0 0])
    set(hAx(1),'ycolor',[0 0 0])
    set(hLine2,'LineWidth',1.5);
    set(hLine1,'LineWidth',1.5);
    ylabel(hAx(1),'\color{black}Precipitation Intensity (mm/h)')
    ylabel(hAx(2),'\color[rgb]{0.8500 0.3250 0.0980}Temperature (C)')
    title('\fontsize{16}Meteorological Data')
    axes('Position',[0.13 0.53 0.775 0.341162790697675],...
        'Color', 'none', 'Ycolor', 'none', ...
        'Xlim', inoutlim, ...
        'XTick', [datenum('06-01-2014') datenum('01-01-2015') ...
        datenum('06-01-2015') datenum('01-01-2016') datenum('06-01-2016')],...
        'XTickLabel', {'2014','','2015','','2016'}, 'FontSize', 16);
hold off
plotb=subplot(212);
    [hAx,hLine1,hLine2] = plotyy(tidal(:,1),tidal(:,5),[tidal(:,1), tidal(:,1)],[tidal(:,3), tidal(:,4)]);
        title('\fontsize{16}Tidal Data')
        ylim(hAx(1),[-300 300]);%[900 1700]); 
        ylim(hAx(2),[0 40]);
        set(hAx(1),'xtick',[])
        set(gca,'Xtick',out)
        set(hAx,'Xtick',[],'XTickLabel',[],'Xlim',inoutlim)
        set(gca,'Xtick',out,'XGrid','on')
        datetick('x','m','keepticks')
        datetick(hAx(1),'x','m','keepticks')
        set(hAx(2),'xtick',get(hAx(1),'xtick'))%'xticklab',get(hAx(1),'xticklab'
        set(hAx(2),'Box','on'); %remove y1 ticks from the right side
        set(hAx(1),'Box','on'); %remove y2 ticks from the left side
        set(hAx(1),'ytick',[-300,-200,-100,0,100,200,300],'FontSize',16);%[900,1100,1300,1500,1700],'FontSize',12)
        set(hAx(2),'ytick',[0,10,20,30,40],'FontSize',16)
        set(hAx(1),'Xgrid','on')
        set(hAx(1),'ycolor','k')
        set(gca,'xcolor',[0 0 0])
        set(hLine2,'LineWidth',1.5);
        set(hLine1,'LineWidth',1.5);
        ylabel(hAx(1),'Water Level (cm)')
        ylabel(hAx(2),'{\color[rgb]{0.8500 0.3250 0.0980}Tem (C)}  {\color[rgb]{0.9290 0.6940 0.1250}SpC  (mS/cm)}') % right y-axis
        axes('Position',[0.13 0.06 0.775 0.341162790697675],...
            'Color', 'none', 'Ycolor', 'none', ...
            'Xlim', inoutlim, ...
            'XTick', [datenum('06-01-2014') datenum('01-01-2015') ...
            datenum('06-01-2015') datenum('01-01-2016') datenum('06-01-2016')],...
            'XTickLabel', {'2014','','2015','','2016'}, 'FontSize', 16);
        linkaxes([plota plotb],'x')
        coverunwantedticks(2, h)
%=========================================================================
% Save figure
    %FigPrint    = getframe(h);
    %imwrite(FigPrint.cdata,...
    %'C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Figures\Fig3.png', 'png')
%% Plot Tidal
h=figureFullScreen('Name','Tidal Gauge');
    set(gcf, 'Color', [1,1,1]);
    rectangle('Position', [datenum('June 1, 2015') 900 122 800],...
        'FaceColor',[0.8,0.8,0.8],'EdgeColor',[0.8,0.8,0.8]);
        hold on;
    rectangle('Position', [datenum('Aug 1, 2014') 900 61 800],...
        'FaceColor',[0.8,0.8,0.8],'EdgeColor',[0.8,0.8,0.8]);
    [hAx,hLine1,hLine2] = plotyy(tidal(:,1),tidal(:,2),...
        [tidal(:,1), tidal(:,1)],[tidal(:,3), tidal(:,4)]);
        title('\fontsize{24}Tidal')
        ylim(hAx(1),[900 1700]); 
        ylim(hAx(2),[0 40]);
        set(hAx(1),'xtick',[])
        set(gca,'Xtick',out);
        datetick(hAx(1),'x','m')
        datetick(hAx(2),'x','m')
        set(hAx(2),'xtick',get(hAx(1),'xtick'))
        set(hAx(2),'Box','on'); %remove y1 ticks from the right side
        set(hAx(1),'Box','on'); %remove y2 ticks from the left side
        set(hAx(1),'ytick',[900,1100,1300,1500,1700],'FontSize',12)
        set(hAx(2),'ytick',[0, 10, 20, 30, 40],'FontSize',12)
        set(hAx(1),'Xgrid','on')
        set(gca,'xcolor',[0 0 0])
        set(hLine2,'LineWidth',1.5);
        set(hLine1,'LineWidth',1.5);
        ylabel(hAx(1),'\fontsize{18}Pressure (cm)')
        ylabel(hAx(2),'{\fontsize{18}\color[rgb]{0.8500 0.3250 0.0980}Tem (C)}  {\fontsize{18}\color[rgb]{0.9290 0.6940 0.1250}SpC  (mS/cm)}') % right y-axis
        secondaxis(hAx(1),2)
%=========================================================================
% Save figure
% FigPrint= getframe(h);
% imwrite(FigPrint.cdata, ...
%     'C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Figures\TidalGauge.png', 'png')
%% Plot Piezometer Temperature and Salinty
inoutlim = [datenum('5-1-2014') datenum('6-1-2016')];
colorOrder = ...
    [ 0 0 1 % 1 BLUE
       0 1 0 % 2 GREEN (pale)
       1 0 0 % 3 RED
       0 1 1 % 4 CYAN
       1 0 1 % 5 MAGENTA (pale)
       1 1 0 % 6 YELLOW (pale)
       0 0 0 % 7 BLACK
       0 0.75 0.75 % 8 TURQUOISE
       0 0.5 0 % 9 GREEN (dark)
       0.75 0.75 0 % 10 YELLOW (dark)
       1 0.50 0.25 % 11 ORANGE
       0.75 0 0.75 % 12 MAGENTA (dark)
       0.7 0.7 0.7 % 13 GREY
       0.8 0.7 0.6 % 14 BROWN (pale)
       0.6 0.5 0.4 ]; % 15 BROWN (dark)
%=========================================================================
    h=figureFullScreen('Name','Temperature');
        set(gcf, 'Color', [1,1,1]);
    hh = plot(A(:,1),A(:,3),'Color', colorOrder(1,:),'LineWidth', 2);
        hold on
    plot(B(:,1),B(:,3),'Color', colorOrder(2,:),'LineWidth', 2);
    plot(C(:,1),C(:,3),'Color', colorOrder(3,:),'LineWidth', 2);
    plot(D(:,1),D(:,3),'Color', colorOrder(4,:),'LineWidth', 2);
    plot(F(:,1),F(:,3),'Color', colorOrder(5,:),'LineWidth', 2);
    plot(G(:,1),G(:,3),'Color', colorOrder(11,:),'LineWidth', 2);
    plot(tidal(:,1),tidal(:,3), 'Color', colorOrder(7,:),'LineWidth', 2);
        xlim(inoutlim);
        set(gca,'FontSize',16)
        %title('\fontsize{16}Temperature')
        ylabel('Temperature (C)')
        datetick('x', 'm')
        legend('1.A', '1.B', '2.C', '2.D', '2.F', '2.G', 'Tidal')
        first_axis = gca;
        axes('Position',get(first_axis, 'Position') - [0 0.05 0 0] ,...
            'Color', 'none', 'Ycolor', 'none', ...
            'Xlim', inoutlim, ...
            'XTick', [datenum('06-01-2014') datenum('01-01-2015') ...
            datenum('06-01-2015') datenum('01-01-2016') datenum('06-01-2016')],...
            'XTickLabel', {'2014','','2015','','2016'}, 'FontSize', 16);
    coverunwantedticks(4,h); %Cover unwanted tick marks
%=========================================================================
% Save figure
    %FigPrint    = getframe(h);
    %imwrite(FigPrint.cdata, 'C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Figures\Temperature.png', 'png')
%=========================================================================
% Plot Piezometer Salinity
h=figureFullScreen('Name','Salinity');
        set(gcf, 'Color', [1,1,1]);
    plot(A(:,1),A(:,4),'Color', colorOrder(1,:),'LineWidth', 2);
        hold on
    plot(B(:,1),B(:,4),'Color', colorOrder(2,:),'LineWidth', 2);
    plot(C(:,1),C(:,4),'Color', colorOrder(3,:),'LineWidth', 2);
    plot(D(:,1),D(:,4),'Color', colorOrder(4,:),'LineWidth', 2);
    plot(tidal(:,1),tidal(:,4), 'Color', colorOrder(7,:),'LineWidth', 2);
        xlim(inoutlim);
        set(gca,'FontSize',16)
        %title('\fontsize{16}Specific Conductivity')
        ylabel('Specific Conductivity  (mS/cm)')
        datetick('x', 'm')
        legend('1.A', '1.B', '2.C', '2.D', 'Tidal')
        first_axis = gca;
        axes('Position',get(first_axis, 'Position') - [0 0.05 0 0] ,...
            'Color', 'none', 'Ycolor', 'none', ...
            'Xlim', inoutlim, ...
            'XTick', [datenum('06-01-2014') datenum('01-01-2015') ...
            datenum('06-01-2015') datenum('01-01-2016') datenum('06-01-2016')],...
            'XTickLabel', {'2014','','2015','','2016'}, 'FontSize', 16);
    coverunwantedticks(4,h);%Cover unwanted tick marks
%=========================================================================
% Save figure
    %FigPrint    = getframe(h);
    %imwrite(FigPrint.cdata, 'C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Figures\Salinity.png', 'png')
%=========================================================================
% Plot Piezometer Salinity
h=figureFullScreen('Name','Salinity Comparison');
        set(gcf, 'Color', [1,1,1]);
    abc= subplot(211);
    plot(A(:,1),A(:,4),'Color', colorOrder(1,:),'LineWidth', 2);
        hold on
    plot(B(:,1),B(:,4),'Color', colorOrder(2,:),'LineWidth', 2);
    plot(C(:,1),C(:,4),'Color', colorOrder(3,:),'LineWidth', 2);
    plot(D(:,1),D(:,4),'Color', colorOrder(4,:),'LineWidth', 2);
    plot(tidal(:,1),tidal(:,4), 'Color', colorOrder(7,:),'LineWidth', 2);
        xlim(inoutlim);
        set(gca,'FontSize',14)
        title('\fontsize{16}Smoothed Specific Conductivity')
        ylabel('\fontsize{16}Specific Conductivity  (mS/cm)')
        datetick('x', 'm')
        legend('1.A', '1.B', '2.C', '2.D', 'Tidal')
        first_axis = gca;
        axes('Position',get(abc, 'Position')-[0 0.048 0 0] ,...
            'Color', 'none', 'Ycolor', 'none', ...
            'Xlim', inoutlim, ...
            'XTick', [datenum('06-01-2014') datenum('01-01-2015') ...
            datenum('06-01-2015') datenum('01-01-2016') datenum('06-01-2016')],...
            'XTickLabel', {'2014','','2015','','2016'}, 'FontSize', 14);

    abc = subplot(212);
    plot(As(:,1),As(:,4),'Color', colorOrder(1,:),'LineWidth', 2);
        hold on
    plot(Bs(:,1),Bs(:,4),'Color', colorOrder(2,:),'LineWidth', 2);
    plot(Cs(:,1),Cs(:,4),'Color', colorOrder(3,:),'LineWidth', 2);
    plot(Ds(:,1),Ds(:,4),'Color', colorOrder(4,:),'LineWidth', 2);
    plot(tidal(:,1),tidal(:,4), 'Color', colorOrder(7,:),'LineWidth', 2);
        xlim(inoutlim);
        set(gca,'FontSize',14)
        title('\fontsize{16}Unsmoothed Specific Conductivity')
        ylabel('\fontsize{16}Specific Conductivity  (mS/cm)')
        datetick('x', 'm')
        ax2 = axes('Position',get(abc, 'Position')-[0 0.048 0 0] ,...
            'Color', 'none', 'Ycolor', 'none', ...
            'Xlim', inoutlim, ...
            'XTick', [datenum('06-01-2014') datenum('01-01-2015') ...
            datenum('06-01-2015') datenum('01-01-2016') datenum('06-01-2016')],...
            'XTickLabel', {'2014','','2015','','2016'}, 'FontSize', 14);
        coverunwantedticks(3,h); %Cover unwanted tick marks 
%=========================================================================
% Save figure
    %FigPrint    = getframe(h);
    %imwrite(FigPrint.cdata, 'C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Figures\SalinityComparison.png', 'png')
%% Plot Figure 4
%Piezometers at Site 1 and 2
%=========================================================================
row = 2;
col = 4;
h=figureFullScreen('Name','Figure 4 Piezometer CTD');
set(gcf, 'Color', [1,1,1]);
Pplot=subplot(row,col,1:2);
[hAx,hLine1,hLine2] = plotyy(A(:,1),A(:,2),[A(:,1),A(:,1)],[A(:,3),A(:,4)]);
    hold on; plot([datenum('03,22,14','mm,dd,yy'), ...
        datenum('07,22,16','mm,dd,yy')], [0,0], '--k');
    title('\fontsize{26}1.A')
    plotcleanup2(hAx,hLine1,hLine2,1,0,0,0)
    secondaxis2(Pplot,0)
Pplot=subplot(row,col,3:4);
[hAx,hLine1,hLine2] = plotyy(B(:,1),B(:,2),[B(:,1),B(:,1)],[B(:,3),B(:,4)]);
    hold on; plot([datenum('03,22,14','mm,dd,yy'), ...
        datenum('07,22,16','mm,dd,yy')], [0,0], '--k');
    title('\fontsize{26}1.B')
    plotcleanup2(hAx,hLine1,hLine2,0,1,0,0)
    secondaxis2(Pplot,0)
Pplot=subplot(row,col,5);
[hAx,hLine1,hLine2] = plotyy(C(:,1),C(:,2),[C(:,1),C(:,1)],[C(:,3),C(:,4)]);
    hold on; plot([datenum('03,22,14','mm,dd,yy'), ...
        datenum('07,22,16','mm,dd,yy')], [0,0], '--k');
    title('\fontsize{26}2.C')
    plotcleanup2(hAx,hLine1,hLine2,1,0,1,0)
    secondaxis2(Pplot,0)
Pplot=subplot(row,col,6);
[hAx,hLine1,hLine2] = plotyy(D(:,1),D(:,2),[D(:,1),D(:,1)],[D(:,3),D(:,4)]);
    hold on; plot([datenum('03,22,14','mm,dd,yy'), ...
        datenum('07,22,16','mm,dd,yy')], [0,0], '--k');
    title('\fontsize{26}2.D')
    plotcleanup2(hAx,hLine1,hLine2,0,0,1,0)
    secondaxis2(Pplot,0)
Pplot=subplot(row,col,7);
[hAx,hLine1,hLine2] = plotyy(F(:,1),F(:,2),[F(:,1)],[F(:,3)]);
    hold on; plot([datenum('03,22,14','mm,dd,yy'), ...
        datenum('07,22,16','mm,dd,yy')], [0,0], '--k');
    title('\fontsize{26}2.F')
    plotcleanup2(hAx,hLine1,hLine2,0,0,1,0)
    set(hAx(2),'ycolor',[0 0 0])
    set(hAx(2),'xcolor',[0 0 0])
    secondaxis2(Pplot,0)
Pplot=subplot(row,col,8);
[hAx,hLine1,hLine2] = plotyy(G(:,1),G(:,2),[G(:,1)],[G(:,3)]);
    hold on; plot([datenum('03,22,14','mm,dd,yy'),...
        datenum('07,22,16','mm,dd,yy')], [0,0], '--k');
    title('\fontsize{26}2.G')
    plotcleanup2(hAx,hLine1,hLine2,0,1,1,0)
    set(hAx(2),'ycolor',[0 0 0])
    set(hAx(2),'xcolor',[0 0 0])
    secondaxis2(Pplot,0)
coverunwantedticks(1,h);%Cover unwanted tick marks
%=========================================================================
% Save figure
%FigPrint    = getframe(h);
%imwrite(FigPrint.cdata, 'C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Figures\Fig4.png', 'png')
%% Plot Barometric Data
h=figureFullScreen('Name','Baro');
    set(gcf, 'Color', [1,1,1]);
plot(baro(:,1),baro(:,2), 'LineWidth',1.5);
    title('\fontsize{22}Atmospheric Pressure')
    ylim([1000 1050]); 
    set(gca,'Xtick',[],'XTickLabel',[],'Xlim',[735690 736482]);
    set(gca,'Xtick',out,'XGrid','on')
    datetick('x','m','keepticks')
    ylabel('Pressure (cm H_20)')
    axes1 = axes('Position',...
        [0.129479166666667 0.0440449438202248 0.775 0.341162790697676],...
        'Color', 'none', 'Ycolor', 'none', ...
        'Xlim', [datenum('04-01-2014') datenum('06-01-2016')], ...
        'XTick', [datenum('06-01-2014') datenum('01-01-2015') ...
        datenum('06-01-2015') datenum('01-01-2016') datenum('06-01-2016')],...
        'XTickLabel', {'2014','','2015','','2016'}, 'FontSize', 22);
    % Create rectangle
    annotation(h,'rectangle',...
        [0.542145833333333 0.0462873674059788 0.0115000000000001 0.0144648023143684],...
        'Color',[1 1 1],...
        'FaceColor',[1 1 1]);
    % Create rectangle
    annotation(h,'rectangle',...
        [0.898656249999999 0.0462873674059788 0.0115000000000002 0.0144648023143684],...
        'Color',[1 1 1],...
        'FaceColor',[1 1 1]);
    % Create rectangle
    annotation(h,'rectangle',...
        [0.184072916666666 0.046046287367406 0.0115 0.0144648023143684],...
        'Color',[1 1 1],...
        'FaceColor',[1 1 1]);
    % Create smaller axes in top right, and plot on it
        hold off
        axes('Position',...
            [0.663852242744063 0.642927794263105 0.213720316622692 0.252225519287834])
        box on
    plot(baro(:,1),baro(:,2), 'LineWidth',1.5);
        ylim([1020 1040]); 
        set(gca,'Xlim',[735970 736000]);
        %set(gca,'Xtick',out,'XGrid','on')
        datetick('x','mm/dd/yy','keepticks')
        ax = gca;
        ax.FontSize = 14; 
%=========================================================================
% Save figure
%FigPrint    = getframe(h);
%imwrite(FigPrint.cdata, 'C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Figures\Baro.png','png')
%% Save Data
save('C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Scripts\piezo.mat',...
    'A','B','C','D','F','G','tidal','met') 
