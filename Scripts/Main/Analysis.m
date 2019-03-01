clear;clc;close all
addpath(genpath('C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Scripts\Function\')); %add path to main directory for function files
addpath(genpath('C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Scripts\')); %add path to main directory for function files
load('piezo.mat')

%% Site 1

AA = A(:,2)- nanmean(A(:,2));BB = B(:,2)- nanmean(B(:,2));tt = tidal(:,2)- nanmean(tidal(:,2));

fAA=lpfilt(AA(~isnan(AA)),5/60,1/38); fAA(24570:24571)=NaN;
ftt=lpfilt(tt(~isnan(tt)),5/60,1/38);
fBB=lpfilt(BB(~isnan(BB)),5/60,1/38);

Ax = A(:,1);Ax = Ax(~isnan(Ax));
Bx = B(:,1);Bx = Bx(~isnan(Bx));
Tx = tidal(:,1);Tx = Tx(~isnan(Tx));

startpt = datenum('Sept 1, 2014');
endpt = datenum('Oct 1, 2014');
startptshort = datenum('Sept 9, 2014');
endptshort = datenum('Sept 13, 2014');
startptshort2 = datenum('Sept 16, 2014');
endptshort2 = datenum('Sept 20, 2014');
 

%peaks
[~, locs] = findpeaks(tt, 'MinPeakDistance',50);
location = tidal(locs, 1);
[~, locs2] = findpeaks(-tt, 'MinPeakDistance',50);
location2 = tidal(locs2, 1);

[~, locs1a] = findpeaks(AA, 'MinPeakDistance',50);
location1a = A(locs1a, 1);
[~, locs1a2] = findpeaks(-AA, 'MinPeakDistance',50);
location1a2 = A(locs1a2, 1);

[~, locs1b] = findpeaks(BB, 'MinPeakDistance',50);
location1b = B(locs1b, 1);
[pks1b2, locs1b2] = findpeaks(-BB, 'MinPeakDistance',50);
location1b2 = B(locs1b2, 1);

%calculate lags
%t = (location(location >= startpt & location <= endpt)-startpt)*24;
%a = (location1a(location1a >= startpt & location1a <= endpt)-startpt)*24; %hours
%b = (location1b(location1b >= startpt & location1b <= endpt)-startpt)*24;%lalt_s = (la_s-lt_s)*60; %minutes

%spring
lt_s = (location(location >= startptshort & location <= endptshort)-startptshort)*24;
la_s = (location1a(location1a >= startptshort & location1a <= endptshort)-startptshort)*24; %hours
lb_s = (location1b(location1b >= startptshort & location1b <= endptshort)-startptshort)*24;%lalt_s = (la_s-lt_s)*60; %minutes
lblt_s = (lb_s-lt_s)*60; 
lalt_s = (la_s-lt_s)*60; 

%neap
lt_n = (location(location >= startptshort2 & location <= endptshort2)-startptshort2)*24;
la_n = (location1a(location1a >= startptshort2 & location1a <= endptshort2)-startptshort2)*24; %hours
lb_n = (location1b(location1b >= startptshort2 & location1b <= endptshort2)-startptshort2)*24;
lalt_n = (la_n-lt_n)*60; %minutes
lblt_n = (lb_n-lt_n)*60;

% Site 1 Filtered
H1 = figure('units','normalized','outerposition',[0 0 1 1]);
row = 2; col = 1;
    subplot(row,col,1)
        plot(Tx, ftt, 'k', 'LineWidth', 1.5)
        hold on
        plot(Ax,fAA, 'b', 'LineWidth', 1.5)
        plot(Bx,fBB, 'r', 'LineWidth', 1.5)
        datetick('x', 'mmmyy', 'KeepLimits')
        plot([startpt startpt], [-40 40], 'k-', 'LineWidth', 3)
        plot([endpt endpt], [-40 40], 'k-', 'LineWidth', 3)
        plot([startpt endpt], [-40 -40], 'k-', 'LineWidth', 3)
        plot([startpt endpt], [40 40], 'k-', 'LineWidth', 3)
        ylabel('Pressure (cm)')
        title('\bf \fontsize{24} Site 1, Filtered')
        legend('Tidal', '1.A', '1.B')
    subplot(row,col,2)
        h = plot(Tx, ftt, 'k', 'LineWidth', 1.5);
        box on;
        hold on
        plot(Ax,fAA, 'b', 'LineWidth', 1.5)
        plot(Bx,fBB, 'r', 'LineWidth', 1.5)
        xlim([startpt endpt]); 
        ylabel('Pressure (cm)');
        datetick('x', 'mm/dd/yy', 'keeplimits')
        title('\bf \fontsize{24} Site 1, Zoomed Filtered')
        set(gcf,'color','w');

% Site 1 Unfiltered
H2 = figure('units','normalized','outerposition',[0 0 1 1]);
row = 2; col = 2;
    subplot(row,col,1:2)
        plot(tidal(:,1), tt, 'k', 'LineWidth', 1.5);
        hold on;
        plot(A(:,1),AA, 'b', 'LineWidth', 1.5);
        plot(B(:,1),BB, 'r', 'LineWidth', 1.5);
        plot([startptshort startptshort], [-280 280], 'k-', 'LineWidth', 3)
        plot([endptshort endptshort], [-280 280], 'k-', 'LineWidth', 3)
        plot([startptshort endptshort], [-280 -280], 'k-', 'LineWidth', 3)
        plot([startptshort endptshort], [280 280], 'k-', 'LineWidth', 3)
        plot([startptshort2 startptshort2], [-280 280], 'k-', 'LineWidth', 3)
        plot([endptshort2 endptshort2], [-280 280], 'k-', 'LineWidth', 3)
        plot([startptshort2 endptshort2], [-280 -280], 'k-', 'LineWidth', 3)
        plot([startptshort2 endptshort2], [280 280], 'k-', 'LineWidth', 3)
        xlim([startpt endpt]); 
        datetick('x', 'mm/dd/yy','keeplimits')
        set(gca,'FontSize',16)
        title('\bf \fontsize{24} Site 1, Unfiltered')
        ylabel('Pressure (cm)')
        set(gca,'FontSize',16)
        hold off
        set(gcf,'color','w');
        legend('Tidal', '1.A', '1.B')

    subplot(row,col,3)
        plot(tidal(:,1), tt, 'k', 'LineWidth', 1.5);
        hold on;
        plot(A(:,1),AA, 'b', 'LineWidth', 1.5);
        plot(B(:,1),BB, 'r', 'LineWidth', 1.5);
        plot(location, pks, 'k.', 'LineWidth', 2); plot(location2, -pks2, 'k.', 'LineWidth', 2)
        plot(location1a, pks1a, 'b.', 'LineWidth', 2); plot(location1a2, -pks1a2, 'b.', 'LineWidth', 2)
        plot(location1b, pks1b, 'r.', 'LineWidth', 2); plot(location1b2, -pks1b2, 'r.', 'LineWidth', 2)
            grid on
            grid minor
            xlim([startptshort endptshort])
            ylim([-280 280])
            set(gca, 'XMinorTick', 'on')
            set(gca,'Xtick',startptshort:1/3:endptshort)
            set(gca,'XtickLabel',((startptshort:1/8:endptshort)-startptshort)*24)
            set(gca,'FontSize',16)
            datetick('x', 'hhPM', 'Keepticks')
            title('\bf \fontsize{24} Spring Tide')
            ylabel('Pressure (cm)') 
            %plot(B(locs1b,1), pks1b, 'o')
            %plot(A(locs1a,1), pks1a, 'o')

    subplot(row,col,4)
        plot(tidal(:,1), tt, 'k', 'LineWidth', 1.5);
        hold on;
        plot(A(:,1),AA, 'b', 'LineWidth', 1.5);
        plot(B(:,1),BB, 'r', 'LineWidth', 1.5);
        plot(location, pks, 'k.', 'LineWidth', 2); plot(location2, -pks2, 'k.', 'LineWidth', 2)
        plot(location1a, pks1a, 'b.', 'LineWidth', 2); plot(location1a2, -pks1a2, 'b.', 'LineWidth', 2)
        plot(location1b, pks1b, 'r.', 'LineWidth', 2); plot(location1b2, -pks1b2, 'r.', 'LineWidth', 2)
            grid on
            grid minor
            xlim([startptshort2 endptshort2])
            ylim([-280 280])
            set(gca, 'XMinorTick', 'on')
            set(gca,'Xtick',startptshort2:1/3:endptshort2)
            set(gca,'XtickLabel',((startptshort2:1/8:endptshort2)-startptshort2)*24)
            set(gca,'FontSize',16)
            datetick('x', 'hhPM', 'Keepticks')
            title('\bf \fontsize{24} Neap Tide')
            ylabel('Pressure (cm)')     
            %plot(B(locs1b,1), pks1b, 'o')
            %plot(A(locs1a,1), pks1a, 'o')
%}

%% Site 1 Edited

AA = A(:,2)- nanmean(A(:,2));BB = B(:,2)- nanmean(B(:,2));tt = tidal(:,2)- nanmean(tidal(:,2));
f = filter_piezo(A(:,1),AA);
f = filter_piezo(B(:,1),BB);
f = filter_piezo(tidal(:,1),tt);

fAA=lpfilt(AA(~isnan(AA)),5/60,1/38); fAA(24570:24571)=NaN;
ftt=lpfilt(tt(~isnan(tt)),5/60,1/38);
fBB=lpfilt(BB(~isnan(BB)),5/60,1/38);

Ax = A(:,1);Ax = Ax(~isnan(Ax));
Bx = B(:,1);Bx = Bx(~isnan(Bx));
Tx = tidal(:,1);Tx = Tx(~isnan(Tx));

startpt = datenum('Sept 1, 2014');
endpt = datenum('Oct 1, 2014');
startptshort = datenum('Sept 9, 2014');
endptshort = datenum('Sept 13, 2014');
startptshort2 = datenum('Sept 16, 2014');
endptshort2 = datenum('Sept 20, 2014');
 

%peaks
[pks, locs] = findpeaks(tt, 'MinPeakDistance',50);
location = tidal(locs, 1);          %time of each peak

[pks1a, locs1a] = findpeaks(AA, 'MinPeakDistance',50);
location1a = A(locs1a, 1);          %time of each peak

[pks1b, locs1b] = findpeaks(BB, 'MinPeakDistance',50);
location1b = B(locs1b, 1);          %time of each peak

%calculate lags
t = (location(location >= startpt & location <= endpt)-startpt)*24;
a = (location1a(location1a >= startpt & location1a <= endpt)-startpt)*24; %hours
b = (location1b(location1b >= startpt & location1b <= endpt)-startpt)*24;%lalt_s = (la_s-lt_s)*60; %minutes

%spring
lt_s = (location(location >= startptshort & location <= endptshort)-startptshort)*24;
la_s = (location1a(location1a >= startptshort & location1a <= endptshort)-startptshort)*24; %hours
lb_s = (location1b(location1b >= startptshort & location1b <= endptshort)-startptshort)*24;%lalt_s = (la_s-lt_s)*60; %minutes
lblt_s = (lb_s-lt_s)*60; 
lalt_s = (la_s-lt_s)*60; 

%neap
lt_n = (location(location >= startptshort2 & location <= endptshort2)-startptshort2)*24;
la_n = (location1a(location1a >= startptshort2 & location1a <= endptshort2)-startptshort2)*24; %hours
lb_n = (location1b(location1b >= startptshort2 & location1b <= endptshort2)-startptshort2)*24;
lalt_n = (la_n-lt_n)*60; %minutes
lblt_n = (lb_n-lt_n)*60;

%lags
lalt_s = (la_s-lt_s)*60; 
lblt_s = (lb_s-lt_s)*60; 
lalt_n = (la_n-lt_n)*60; %minutes
lblt_n = (lb_n-lt_n)*60;
Name = {'A','B','An','Bn'};
LagTable = table(lalt_s,lalt_n,lblt_s, lblt_n);
%% Plot Spring and Neap Tide w/ Lags for Site 1

H1=figureFullScreen('Name','Fig');
row = 2; col = 1;
    subplot(row,col,1)
        plot(Tx, ftt, 'k', 'LineWidth', 1.5)
        hold on
        plot(Ax,fAA, 'b', 'LineWidth', 1.5)
        plot(Bx,fBB, 'r', 'LineWidth', 1.5)
        datetick('x', 'mmmyy', 'KeepLimits')
        plot([startpt startpt], [-40 40], 'k-', 'LineWidth', 3)
        plot([endpt endpt], [-40 40], 'k-', 'LineWidth', 3)
        plot([startpt endpt], [-40 -40], 'k-', 'LineWidth', 3)
        plot([startpt endpt], [40 40], 'k-', 'LineWidth', 3)
        ylabel('Pressure (cm)')
        title('\bf \fontsize{24} Site 1, Filtered')
        legend('Tidal', '1.A', '1.B')
    subplot(row,col,2)
        h = plot(Tx, ftt, 'k', 'LineWidth', 1.5);
        box on;
        hold on
        plot(Ax,fAA, 'b', 'LineWidth', 1.5)
        plot(Bx,fBB, 'r', 'LineWidth', 1.5)
        xlim([startpt endpt]); 
        ylabel('Pressure (cm)');
        datetick('x', 'mm/dd/yy', 'keeplimits')
        title('\bf \fontsize{24} Site 1, Zoomed Filtered')
        set(gcf,'color','w');
 
H2=figureFullScreen('Name','Spring and Neap Tide w/ Lags for Site 1');
set(gcf, 'Color', [1,1,1]);
row = 2; col = 1;
    subplot(row,col,1)
        plot(tidal(:,1), tt, 'k', 'LineWidth', 1.5);
            ax1=gca;
            hold on;
        plot(A(:,1),AA, 'b', 'LineWidth', 1.5);
        plot(B(:,1),BB, 'r', 'LineWidth', 1.5);
            grid on
            grid minor
            xlim([startptshort endptshort])
            ylim([-280 280])
            set(gca, 'XMinorTick', 'on')
            set(gca,'Xtick',startptshort:1/3:endptshort)
            set(gca,'XtickLabel',((startptshort:1/8:endptshort)-startptshort)*24)
            set(gca,'FontSize',16)
            datetick('x', 'hhPM', 'Keepticks')
            title('\bf \fontsize{24} Spring Tide')
            ylabel('Water Level (cm)') 
        plot(B(locs1b,1), pks1b, 'o', 'Color','red','MarkerFaceColor', 'red');
        plot(A(locs1a,1), pks1a, 'o', 'Color', 'blue','MarkerFaceColor', 'blue');
        plot(tidal(locs,1), pks, 'o', 'Color', 'black','MarkerFaceColor', 'black');
            tt2 = tidal(locs,1)';  formatOut = 'HH:MM AM'; ttt = datestr(tt2, formatOut);
            at = A(locs1a,1)';   att = datestr(at, formatOut);
            bt = B(locs1b,1)';   btt = datestr(bt, formatOut);
            dxt = 0.1; dyt = 0.1; dxt2= 0.05;% displacement so the text does not overlay the data points
            text(tidal(locs,1)+dxt2, pks+dyt, ttt);
            text(A(locs1a,1)+dxt, pks1a+dyt, att, 'Color', 'blue');
            text(B(locs1b,1)+dxt, pks1b+dyt, btt, 'Color', 'red');
            
            axes1 = axes('Position',[0.1300    0.528    0.7750    0.3358],...
           'XAxisLocation','bottom',...
           'Color', 'none', 'Ycolor', 'none', ...
                'Xlim', [startptshort endptshort], ...
                'XTick', [startptshort datenum('Sept 10, 2014') ...
                datenum('Sept 11, 2014') datenum('Sept 12, 2014') endptshort],...
                'FontSize', 16,...
                'XTickLabel', {'9/9/14','9/10/14','9/11/14','9/12/14','9/13/14'});

    subplot(row,col,2)
       h1 =plot(tidal(:,1), tt, 'k', 'LineWidth', 1.5);
            ax1=gca;
            hold on;
        h2 = plot(A(:,1),AA, 'b', 'LineWidth', 1.5);
        h3 = plot(B(:,1),BB, 'r', 'LineWidth', 1.5);
        plot(location1b, pks1b, 'r.', 'LineWidth', 2); plot(location1b2, -pks1b2, 'r.', 'LineWidth', 2)
            grid on
            grid minor
            xlim([startptshort2 endptshort2])
            ylim([-280 280])
            set(gca, 'XMinorTick', 'on')
            set(gca,'Xtick',startptshort2:1/3:endptshort2)
            set(gca,'XtickLabel',((startptshort2:1/8:endptshort2)-startptshort2)*24)
            set(gca,'FontSize',16)
            datetick('x', 'hhPM', 'Keepticks')
            title('\bf \fontsize{24} Neap Tide')
            ylabel('Water Level (cm)')
         h = plot(B(locs1b,1), pks1b, 'o', 'Color','red','MarkerFaceColor', 'red'); 
         plot(A(locs1a,1), pks1a, 'o', 'Color', 'blue','MarkerFaceColor', 'blue');
         plot(tidal(locs,1), pks, 'o', 'Color', 'black','MarkerFaceColor', 'black');
            tt2 = tidal(locs,1)';  formatOut = 'HH:MM AM'; ttt = datestr(tt2, formatOut);
            at = A(locs1a,1)';   att = datestr(at, formatOut);
            bt = B(locs1b,1)';   btt = datestr(bt, formatOut);
            dxt = 0.1; dyt = 0.1; dxt2= 0.05;% displacement so the text does not overlay the data points
            text(tidal(locs,1)+dxt2, pks+dyt, ttt);
            text(A(locs1a,1)+dxt, pks1a+dyt, att, 'Color', 'blue');
            text(B(locs1b,1)+dxt, pks1b+dyt, btt, 'Color', 'red');
            legend('Tidal','A','B');
            
            axes2 = axes('Position',[0.1300    0.05    0.7750    0.3358],...
                'XAxisLocation','bottom',...
                'Color', 'none', 'Ycolor', 'none', ...
                'Xlim', [startptshort2 endptshort2], ...
                'XTick', [startptshort2 datenum('Sept 17, 2014') ...
                datenum('Sept 18, 2014') datenum('Sept 19, 2014') endptshort2],...
                'FontSize', 16,...
                'XTickLabel', {'9/16/14','9/17/14','9/18/14','9/19/14','9/20/14'});
%%
%Save Figure
F    = getframe(H2);
imwrite(F.cdata, 'C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Figures\Fig5.png', 'png')      
%% Tidal amplitude
TT = tidal(:,2)- nanmean(tidal(:,2));
tidal=[tidal TT];
%index = find(tidal(:,1) >= startpt & tidal(:,1) <= endpt);
Tnew= tidal;
[pks, locs] = findpeaks(Tnew(:,5), 'MinPeakDistance',50);
location = Tnew(locs, 1);          %time of each peak
[pks2, locs2] = findpeaks(-Tnew(:,5), 'MinPeakDistance',50);
location2 = Tnew(locs2, 1);

plot(Tnew(:,1),Tnew(:,5))
 hold on 
% plot(A(:,1),AA)
% plot(B(locs1b,1), pks1b, 'o')
plot(Tnew(locs,1), pks, 'o')
plot(Tnew(locs2,1), -pks2, 'o')

avepks = mean(pks);
avepks2 = mean(-pks2);
meanamptide = avepks-avepks2;
maxamplitude = 228--259;
minamplitude = 69--115;

 %% Site 1 Edited again
 
AA = A(:,2)- nanmean(A(:,2));
BB = B(:,2)- nanmean(B(:,2));
TT = tidal(:,2)- nanmean(tidal(:,2));
startpt = datenum('Sept 1, 2014');
endpt = datenum('Sept 26, 2014');
%==================================
%Narrow to one spring-neap cycle
tidal=[tidal TT];
index = tidal(:,1) >= startpt & tidal(:,1) <= endpt;
Tnew= tidal(index,:);

A=[A AA];
index = A(:,1) >= startpt & A(:,1) <= endpt;
Anew= A(index,:);

B=[B BB];
index = B(:,1) >= startpt & B(:,1) <= endpt;
Bnew= B(index,:);
%===================================
%Find peak location
[pks, locs] = findpeaks(Tnew(:,5), 'MinPeakDistance',50);
location = Tnew(locs, 1);          %time of each peak
[pks1a, locs1a] = findpeaks(Anew(:,5), 'MinPeakDistance',50);
location1a = Anew(locs1a, 1);          %time of each peak
[pks1b, locs1b] = findpeaks(Bnew(:,5), 'MinPeakDistance',50);
location1b = Bnew(locs1b, 1); 
%===================================
%calculate lags
t = (location-startpt)*24;
a = (location1a-startpt)*24; %hours
b = (location1b-startpt)*24;
lag_a = (a-t)*60; 
lag_b = (b-t)*60; 
%===================================
%Plot Cycles
H2 = figure('units','normalized','outerposition',[0 0 1 1]);
row = 1; col = 1;
    subplot(row,col,1)
        plot(Tnew(:,1),Tnew(:,5), 'k', 'LineWidth', 1);
        ax1=gca;
        hold on;
        plot(Anew(:,1),Anew(:,5), 'b', 'LineWidth', 1);
        plot(Bnew(:,1),Bnew(:,5), 'r', 'LineWidth', 1);
        grid on
        grid minor
        xlim([startpt endpt])
        ylim([-280 280])
        set(gca,'Xtick',startpt:2:endpt)
        set(gca,'FontSize',16)
        set(gca, 'XMinorTick', 'on')
        datetick('x', 'mmmdd', 'Keepticks');
        ylabel('Pressure (cm)');
        plot(Bnew(locs1b,1), pks1b, 'o','MarkerSize',3, 'Color','red','MarkerFaceColor', 'red');
        %%
           
            ylim([-280 280])
            set(gca, 'XMinorTick', 'on')
            set(gca,'Xtick',startptshort:endptshort3)
            %set(gca,'XtickLabel',([startptshort:1/8:endptshort3]-startptshort)*24)
            set(gca,'FontSize',16)
            datetick('x', ' mmm dd', 'Keepticks');%datetick('x', 'hhPM', 'Keepticks')
            title('\bf \fontsize{24} Spring Tide')
            ylabel('Pressure (cm)') 
            plot(new_BB(locs1b,1), pks1b, 'o', 'Color','red','MarkerFaceColor', 'red');
            plot(new_AA(locs1a,1), pks1a, 'o', 'Color', 'blue','MarkerFaceColor', 'blue');
            plot(new_tidal(locs,1), pks, 'o', 'Color', 'black','MarkerFaceColor', 'black');
            
            tt2 = new_tidal(locs,1)';  formatOut = 'HH:MM'; ttt = datestr(tt2, formatOut);
            at = new_AA(locs1a,1)';   att = datestr(at, formatOut);
            bt = new_BB(locs1b,1)';   btt = datestr(bt, formatOut);
            dxt = 0.1; dyt = 0.1; dxt2= 0.05;% displacement so the text does not overlay the data points
            %text(tidal(locs,1)+dxt2, pks+dyt, ttt);
            %text(new_AA(locs1a,1)+dxt, pks1a+dyt, num2str(lag_a,3), 'Color', 'blue');
            %text(B(locs1b,1)+dxt, pks1b+dyt, btt, 'Color', 'red');
            text(new_tidal(locs,1)+dxt2, pks+4, num2str(lag_a,2), 'Color', 'blue', 'HorizontalAlignment', 'left', 'FontSize', 14);
            text(new_tidal(locs,1)+dxt2, pks+20, num2str(lag_b,2), 'Color', 'red', 'HorizontalAlignment', 'left', 'FontSize', 14);
%             axes1 = axes('Position',[0.1300    0.528    0.7750    0.3358],...
%            'XAxisLocation','bottom',...
%            'Color', 'none', 'Ycolor', 'none', ...
%                 'Xlim', [startptshort endptshort], ...
%                 'XTick', [startptshort datenum('Sept 10, 2014') ...
%                 datenum('Sept 11, 2014') datenum('Sept 12, 2014') endptshort],...
%                 'FontSize', 16,...
%                 'XTickLabel', {'9/9/14','9/10/14','9/11/14','9/12/14','9/13/14'});


%     subplot(row,col,2)
%        h1 =plot(tidal(:,1), tt, 'k', 'LineWidth', 1.5);
%         ax1=gca;
%         hold on;
%         h2 = plot(A(:,1),AA, 'b', 'LineWidth', 1.5);
%         h3 = plot(B(:,1),BB, 'r', 'LineWidth', 1.5);
%         %legend([h1 h2 h3],'Tidal', 'A', 'B');
% %         plot(location, pks, 'k.', 'LineWidth', 2); plot(location2, -pks2, 'k.', 'LineWidth', 2)
% %         plot(location1a, pks1a, 'b.', 'LineWidth', 2); plot(location1a2, -pks1a2, 'b.', 'LineWidth', 2)
% %         plot(location1b, pks1b, 'r.', 'LineWidth', 2); plot(location1b2, -pks1b2, 'r.', 'LineWidth', 2)
%             grid on
%             grid minor
%             xlim([startptshort2 endptshort2])
%             ylim([-280 280])
%             set(gca, 'XMinorTick', 'on')
%             set(gca,'Xtick',startptshort2:1/3:endptshort2)
%             set(gca,'XtickLabel',([startptshort2:1/8:endptshort2]-startptshort2)*24)
%             set(gca,'FontSize',16)
%             datetick('x', 'hhPM', 'Keepticks')
%             title('\bf \fontsize{24} Neap Tide')
%             ylabel('Pressure (cm)')
%             h = plot(B(locs1b,1), pks1b, 'o', 'Color','red','MarkerFaceColor', 'red'); 
%             plot(A(locs1a,1), pks1a, 'o', 'Color', 'blue','MarkerFaceColor', 'blue');
%             plot(tidal(locs,1), pks, 'o', 'Color', 'black','MarkerFaceColor', 'black');
%             
%             tt2 = tidal(locs,1)';  formatOut = 'HH:MM AM'; ttt = datestr(tt2, formatOut);
%             at = A(locs1a,1)';   att = datestr(at, formatOut);
%             bt = B(locs1b,1)';   btt = datestr(bt, formatOut);
%             dxt = 0.1; dyt = 0.1; dxt2= 0.05;% displacement so the text does not overlay the data points
%             text(tidal(locs,1)+dxt2, pks+dyt, ttt);
%             text(A(locs1a,1)+dxt, pks1a+dyt, att, 'Color', 'blue');
%             text(B(locs1b,1)+dxt, pks1b+dyt, btt, 'Color', 'red');
%             
%             axes2 = axes('Position',[0.1300    0.05    0.7750    0.3358],...
%            'XAxisLocation','bottom',...
%            'Color', 'none', 'Ycolor', 'none', ...
%                 'Xlim', [startptshort2 endptshort2], ...
%                 'XTick', [startptshort2 datenum('Sept 17, 2014') ...
%                 datenum('Sept 18, 2014') datenum('Sept 19, 2014') endptshort2],...
%                 'FontSize', 16,...
%                 'XTickLabel', {'9/16/14','9/17/14','9/18/14','9/19/14','9/20/14'});
 %%           
 figure()    

 subplot(211)
 plot(lalt_s+1,'LineWidth', 2, 'Color','k')
 plot(lalt_s,'LineWidth', 2)
 grid on
 grid minor
 hold on
 plot(lblt_s,'LineWidth', 2)
 title('\bf \fontsize{24} Spring Lags')
 ylabel('Lag Time (mins)')
 legend('\bf \fontsize{24}A','\bf \fontsize{24}B')
 
 subplot(212)
 plot(lalt_n)
 grid on
 grid minor
 hold on
 plot(lblt_n)  
 title('\bf \fontsize{24} Neap Lags')
 ylabel('Lag Time (mins)')
 xlabel('Sinusoid Cycle')            
            
%% Site 2 Edited w/ Lag
clear;clc;close all
load('piezo.mat')
CC = C(:,2)- nanmean(C(:,2));
DD = D(:,2)- nanmean(D(:,2));
TT = tidal(:,2)- nanmean(tidal(:,2));
startpt = 7.361463500000000e+05;%datenum('July 1, 2015');
endpt = datenum('Aug 1, 2015');
%==================================
%Narrow to one spring-neap cycle
tidal=[tidal TT];
index = tidal(:,1) >= startpt & tidal(:,1) <= endpt;
Tnew= tidal(index,:);

C=[C CC];
index = C(:,1) >= startpt & C(:,1) <= endpt;
Cnew= C(index,:);

D=[D DD];
index = find(D(:,1) >= startpt & D(:,1) <= endpt);
Dnew= D(index,:);
%===================================
%Plot Cycles
H2 = figure('units','normalized','outerposition',[0 0 1 1]);
row = 1; col = 1;
    subplot(row,col,1)
        plot(Tnew(:,1),Tnew(:,5), 'k', 'LineWidth', 1);
        ax1=gca;
        hold on;
        plot(Cnew(:,1),Cnew(:,5), 'b', 'LineWidth', 1);
        plot(Dnew(:,1),Dnew(:,5), 'r', 'LineWidth', 1);
        grid on
        grid minor
        xlim([startpt endpt])
        ylim([-280 280])
        set(gca,'Xtick',startpt:2:endpt)
        set(gca,'FontSize',16)
        set(gca, 'XMinorTick', 'on')
        datetick('x', 'mmmdd', 'Keepticks');
        ylabel('Pressure (cm)');
        plot(Bnew(locs1b,1), pks1b, 'o','MarkerSize',3, 'Color','red','MarkerFaceColor', 'red');
%% Find peak location
[~, locs] = findpeaks(Tnew(:,5), 'MinPeakDistance',50);
location = Tnew(locs, 1);          %time of each peak
[~, locs1c] = findpeaks(Cnew(:,5), 'MinPeakDistance',50);
location1c = Cnew(locs1c, 1);          %time of each peak
[~, locs1d] = findpeaks(Dnew(:,5), 'MinPeakDistance',50);
location1d = Dnew(locs1d, 1); 
%===================================
%calculate lags
t = (location-startpt)*24;
c = (location1c-startpt)*24; %hours
d = (location1d-startpt)*24;
lag_c = (c-t)*60; 
lag_d = (d-t)*60; 

%% Site 2 Edited
    CC = C(:,2)- nanmean(C(:,2));DD = D(:,2)- nanmean(D(:,2));
    FF = F(:,2)- nanmean(F(:,2));GG = G(:,2)- nanmean(G(:,2));
    tt = tidal(:,2)- nanmean(tidal(:,2));

    fCC=lpfilt(CC(~isnan(CC)),5/60,1/38);
    fDD=lpfilt(DD(~isnan(DD)),5/60,1/38);
    fFF=lpfilt(FF(~isnan(FF)),5/60,1/38);
    fGG=lpfilt(GG(~isnan(GG)),5/3/60,1/38);
    ftt=lpfilt(tt(~isnan(tt)),5/3/60,1/38);

    Cx = C(:,1);Cx = Cx(~isnan(Cx));
    Dx = D(:,1);Dx = Dx(~isnan(Dx));
    Fx = F(:,1);Fx = Fx(~isnan(Fx));
    Gx = G(:,1);Gx = Gx(~isnan(Gx));
    Tx = tidal(:,1);Tx = Tx(~isnan(Tx));

    startpt = datenum('July 1, 2015');
    endpt = datenum('Aug 1, 2015');
    startptshort = datenum('July 16, 2015');
    endptshort = datenum('July 20, 2015');
    startptshort2 = datenum('July 25, 2015');
    endptshort2 = datenum('July 29, 2015');

    %peaks
    [pks, locs] = findpeaks(tt, 'MinPeakDistance',50);
    location = tidal(locs, 1);

    [pks1c, locs1c] = findpeaks(CC, 'MinPeakDistance',50);
    location1c = C(locs1c, 1);

    [pks1d, locs1d] = findpeaks(DD, 'MinPeakDistance',50);
    location1d = D(locs1d, 1);

    [pks1f, locs1f] = findpeaks(FF, 'MinPeakDistance',50);
    location1f = F(locs1f, 1);

    [pks1g, locs1g] = findpeaks(GG, 'MinPeakDistance',50);
    location1g = G(locs1g, 1);

    %calculate lags
    t = (location(location >= startpt & location <= endpt)-startpt)*24;
    c = (location1c(location1c >= startpt & location1c <= endpt)-startpt)*24; %hours
    d = (location1d(location1d >= startpt & location1d <= endpt)-startpt)*24;%lalt_s = (la_s-lt_s)*60; %minutes
    f = (location1f(location1f >= startpt & location1f <= endpt)-startpt)*24; %hours
    g = (location1g(location1g >= startpt & location1g <= endpt)-startpt)*24;%lalt_s = (la_s-lt_s)*60; %minute

    %spring
    lt_s = (location(location >= startptshort & location <= endptshort)-startptshort)*24;
    lc_s = (location1c(location1c >= startptshort & location1c <= endptshort)-startptshort)*24; %hours
    ld_s = (location1d(location1d >= startptshort & location1d <= endptshort)-startptshort)*24;
    lf_s = (location1f(location1f >= startptshort & location1f <= endptshort)-startptshort)*24;
    lg_s = (location1g(location1g >= startptshort & location1g <= endptshort)-startptshort)*24;
    % lclt_s = (lc_s-lt_s)*60; %minutes
    % ldlt_s = (ld_s-lt_s)*60; %minutes
    % lflt_s = (lf_s-lt_s)*60; %minutes
    % lglt_s = (lg_s-lt_s)*60; %minutes

    %neap
    lt_n = (location(location >= startptshort2 & location <= endptshort2)-startptshort2)*24;
    lc_n = (location1c(location1c >= startptshort2 & location1c <= endptshort2)-startptshort2)*24; %hours
    ld_n = (location1d(location1d >= startptshort2 & location1d <= endptshort2)-startptshort2)*24;
    lf_n = (location1f(location1f >= startptshort2 & location1f <= endptshort2)-startptshort2)*24; %hours
    lg_n = (location1g(location1g >= startptshort2 & location1g <= endptshort2)-startptshort2)*24;
    % lclt_n = (lc_n-lt_n)*60; %minutes
    % ldlt_n = (ld_n-lt_n)*60; %minutes
    % lflt_n = (lf_n-lt_n)*60; %minutes
    % lglt_n = (lg_n-lt_n)*60; %minutes


    H2 = figure('units','normalized','outerposition',[0 0 1 1]);
    row = 2; col = 1;
        subplot(row,col,1)
            plot(tidal(:,1), tt, 'k', 'LineWidth', 1.5);
            hold on;
            plot(C(:,1),CC, 'b', 'LineWidth', 1.5);
            plot(D(:,1),DD, 'r', 'LineWidth', 1.5);
            plot(F(:,1),FF, 'g', 'LineWidth', 1.5);
            plot(G(:,1),GG, 'm', 'LineWidth', 1.5);
            plot(location, pks, 'ko', 'LineWidth', 2,'MarkerFaceColor', 'k');
            plot(location1c, pks1c, 'bo', 'LineWidth', 2,'MarkerFaceColor', 'b');
            plot(location1d, pks1d, 'ro', 'LineWidth', 2,'MarkerFaceColor', 'r');
            plot(location1f, pks1f, 'go', 'LineWidth', 2,'MarkerFaceColor', 'g');
            plot(location1g, pks1g, 'mo', 'LineWidth', 2,'MarkerFaceColor', 'm');
                grid on
                grid minor
                xlim([startptshort endptshort])
                ylim([-280 280])
                set(gca, 'XMinorTick', 'on')
                set(gca,'Xtick',startptshort:1/3:endptshort)
                set(gca,'XtickLabel',((startptshort:1/8:endptshort)-startptshort)*24)
                 set(gca,'FontSize',16)
                datetick('x', 'hhPM', 'Keepticks')
                title('\bf \fontsize{24} Spring Tide')
                ylabel('Pressure (cm)')   

                tt2 = tidal(locs,1)';  formatOut = 'HH:MM AM'; ttt = datestr(tt2, formatOut);
                ct = C(locs1c,1)';   ctt = datestr(ct, formatOut);
                dt = D(locs1d,1)';   dtt = datestr(dt, formatOut);
                dxt = 0.08; dyt = 0.1; dxt2= 0.05; dyt2 = 35;% displacement so the text does not overlay the data points
                text(tidal(locs,1)+dxt2, pks+dyt, ttt);
                text(C(locs1c,1)-0.05, pks1c+dyt2, ctt, 'Color', 'blue');
                text(D(locs1d,1)+dxt, pks1d+15, dtt, 'Color', 'red');

                axes1 = axes('Position',[0.1300    0.528    0.7750    0.3358],...
               'XAxisLocation','bottom',...
               'Color', 'none', 'Ycolor', 'none', ...
                    'Xlim', [startptshort endptshort], ...
                    'XTick', [startptshort datenum('July 17, 2015') ...
                    datenum('July 18, 2015') datenum('July 19, 2015') endptshort],...
                    'FontSize', 16,...
                    'XTickLabel', {'7/16/15','7/17/15','7/18/15','7/19/15','7/20/15'});


        subplot(row,col,2)
            plot(tidal(:,1), tt, 'k', 'LineWidth', 1.5);
            hold on;
            plot(C(:,1),CC, 'b', 'LineWidth', 1.5);
            plot(D(:,1),DD, 'r', 'LineWidth', 1.5);
            plot(F(:,1),FF, 'g', 'LineWidth', 1.5);
            plot(G(:,1),GG, 'm', 'LineWidth', 1.5);

            plot(location, pks, 'ko', 'LineWidth', 2,'MarkerFaceColor', 'k');
            plot(location1c, pks1c, 'bo', 'LineWidth', 2,'MarkerFaceColor', 'b');
            plot(location1d, pks1d, 'ro', 'LineWidth', 2,'MarkerFaceColor', 'r');
            plot(location1f, pks1f, 'go', 'LineWidth', 2,'MarkerFaceColor', 'g');
            plot(location1g, pks1g, 'mo', 'LineWidth', 2,'MarkerFaceColor', 'm');
                grid on
                grid minor
                xlim([startptshort2 endptshort2])
                ylim([-280 280])
                set(gca, 'XMinorTick', 'on')
                set(gca,'Xtick',startptshort2:1/3:endptshort2)
                set(gca,'XtickLabel',((startptshort2:1/8:endptshort2)-startptshort2)*24)
                 set(gca,'FontSize',16)
                datetick('x', 'hhPM', 'Keepticks')
                title('\bf \fontsize{24} Neap Tide')
                ylabel('Pressure (cm)')    

                            tt2 = tidal(locs,1)';  formatOut = 'HH:MM AM'; ttt = datestr(tt2, formatOut);
                ct = C(locs1c,1)';   ctt = datestr(ct, formatOut);
                dt = D(locs1d,1)';   dtt = datestr(dt, formatOut);
                dxt = 0.08; dyt = 0.1; dxt2= 0.05; dyt2 = 35;% displacement so the text does not overlay the data points
                text(tidal(locs,1)+dxt2, pks+dyt, ttt);
                text(C(locs1c,1)-0.05, pks1c+dyt2, ctt, 'Color', 'blue');
                text(D(locs1d,1)+dxt, pks1d+15, dtt, 'Color', 'red');

                axes2 = axes('Position',[0.1300    0.05    0.7750    0.3358],...
               'XAxisLocation','bottom',...
               'Color', 'none', 'Ycolor', 'none', ...
                    'Xlim', [startptshort2 endptshort2], ...
                    'XTick', [startptshort2 datenum('July 26, 2015') ...
                    datenum('July 27, 2015') datenum('July 28, 2015') endptshort2],...
                    'FontSize', 16,...
                    'XTickLabel', {'7/25/15','7/26/15','7/27/15','7/28/15','7/29/15'});
%}    
%% Site 2
%{
CC = C(:,2)- nanmean(C(:,2));DD = D(:,2)- nanmean(D(:,2));
FF = F(:,2)- nanmean(F(:,2));GG = G(:,2)- nanmean(G(:,2));
tt = tidal(:,2)- nanmean(tidal(:,2));


fCC=lpfilt(CC(~isnan(CC)),5/60,1/38);
fDD=lpfilt(DD(~isnan(DD)),5/60,1/38);
fFF=lpfilt(FF(~isnan(FF)),5/60,1/38);
fGG=lpfilt(GG(~isnan(GG)),5/3/60,1/38);
ftt=lpfilt(tt(~isnan(tt)),5/3/60,1/38);

Cx = C(:,1);Cx = Cx(~isnan(Cx));
Dx = D(:,1);Dx = Dx(~isnan(Dx));
Fx = F(:,1);Fx = Fx(~isnan(Fx));
Gx = G(:,1);Gx = Gx(~isnan(Gx));
Tx = tidal(:,1);Tx = Tx(~isnan(Tx));

startpt = datenum('July 1, 2015');
endpt = datenum('Aug 1, 2015');
startptshort = datenum('July 16, 2015');
endptshort = datenum('July 20, 2015');
startptshort2 = datenum('July 25, 2015');
endptshort2 = datenum('July 29, 2015');

%peaks
[pks, locs] = findpeaks(tt, 'MinPeakDistance',50);
location = tidal(locs, 1);
[pks2, locs2] = findpeaks(-tt, 'MinPeakDistance',50);
location2 = tidal(locs2, 1);

[pks1c, locs1c] = findpeaks(CC, 'MinPeakDistance',50);
location1c = C(locs1c, 1);
[pks1c2, locs1c2] = findpeaks(-CC, 'MinPeakDistance',50);
location1c2 = C(locs1c2, 1);

[pks1d, locs1d] = findpeaks(DD, 'MinPeakDistance',50);
location1d = D(locs1d, 1);
[pks1d2, locs1d2] = findpeaks(-DD, 'MinPeakDistance',50);
location1d2 = D(locs1d2, 1);

[pks1f, locs1f] = findpeaks(FF, 'MinPeakDistance',50);
location1f = F(locs1f, 1);
[pks1f2, locs1f2] = findpeaks(-FF, 'MinPeakDistance',50);
location1f2 = F(locs1f2, 1);

[pks1g, locs1g] = findpeaks(GG, 'MinPeakDistance',50);
location1g = G(locs1g, 1);
[pks1g2, locs1g2] = findpeaks(-GG, 'MinPeakDistance',50);
location1g2 = G(locs1g2, 1);

%calculate lags
t = (location(location >= startpt & location <= endpt)-startpt)*24;
c = (location1c(location1c >= startpt & location1c <= endpt)-startpt)*24; %hours
d = (location1d(location1d >= startpt & location1d <= endpt)-startpt)*24;%lalt_s = (la_s-lt_s)*60; %minutes
f = (location1f(location1f >= startpt & location1f <= endpt)-startpt)*24; %hours
g = (location1g(location1g >= startpt & location1g <= endpt)-startpt)*24;%lalt_s = (la_s-lt_s)*60; %minute

%spring
lt_s = (location(location >= startptshort & location <= endptshort)-startptshort)*24;
lc_s = (location1c(location1c >= startptshort & location1c <= endptshort)-startptshort)*24; %hours
ld_s = (location1d(location1d >= startptshort & location1d <= endptshort)-startptshort)*24;
lf_s = (location1f(location1f >= startptshort & location1f <= endptshort)-startptshort)*24;
lg_s = (location1g(location1g >= startptshort & location1g <= endptshort)-startptshort)*24;
%lclt_s = (lc_s-lt_s)*60; %minutes
%ldlt_s = (ld_s-lt_s)*60; %minutes
%lflt_s = (lf_s-lt_s)*60; %minutes
%lglt_s = (lg_s-lt_s)*60; %minutes

%neap
lt_n = (location(location >= startptshort2 & location <= endptshort2)-startptshort2)*24;
lc_n = (location1c(location1c >= startptshort2 & location1c <= endptshort2)-startptshort2)*24; %hours
ld_n = (location1d(location1d >= startptshort2 & location1d <= endptshort2)-startptshort2)*24;
lf_n = (location1f(location1f >= startptshort2 & location1f <= endptshort2)-startptshort2)*24; %hours
lg_n = (location1g(location1g >= startptshort2 & location1g <= endptshort2)-startptshort2)*24;
%lclt_n = (lc_n-lt_n)*60; %minutes
%ldlt_n = (ld_n-lt_n)*60; %minutes
%lflt_n = (lf_n-lt_n)*60; %minutes
%lglt_n = (lg_n-lt_n)*60; %minutes

H1 = figure('units','normalized','outerposition',[0 0 1 1]);
row = 2; col = 1;
    subplot(row,col,1)
        plot(Tx, ftt, 'k', 'LineWidth', 1.5)
        hold on
        plot(Cx,fCC, 'b', 'LineWidth', 1.5)
        plot(Dx,fDD, 'r', 'LineWidth', 1.5)
        plot(Fx,fFF, 'g', 'LineWidth', 1.5)
        plot(Gx,fGG, 'm', 'LineWidth', 1.5)
        datetick('x', 'mmm yyyy', 'KeepLimits')
        plot([startpt startpt], [-40 70], 'k-', 'LineWidth', 3)
        plot([endpt endpt], [-40 70], 'k-', 'LineWidth', 3)
        plot([startpt endpt], [-40 -40], 'k-', 'LineWidth', 3)
        plot([startpt endpt], [70 70], 'k-', 'LineWidth', 3)
        ylabel('Pressure (cm)')
        title('\bf \fontsize{24} Site 2, Filtered')
        legend('Tidal', '2.C', '2.D', '2.F', '2.G')
    subplot(row,col,2)
        h = plot(Tx, ftt, 'k', 'LineWidth', 1.5);
        ylim([-40 70])
        box on;
        hold on
        plot(Cx,fCC, 'b', 'LineWidth', 1.5)
        plot(Dx,fDD, 'r', 'LineWidth', 1.5)
        plot(Fx,fFF, 'g', 'LineWidth', 1.5)
        plot(Gx,fGG, 'm', 'LineWidth', 1.5)
        xlim([startpt endpt]); 
        ylabel('Pressure (cm)');
        datetick('x', 'mm/dd/yy', 'keeplimits')
        title('\bf \fontsize{24} Site 2, Zoomed Filtered')
        set(gcf,'color','w');
    
H2 = figure('units','normalized','outerposition',[0 0 1 1]);
row = 2; col = 2;
    subplot(row,col,1:2)
        plot(tidal(:,1), tt, 'k', 'LineWidth', 1.5);
        hold on;
        plot(C(:,1),CC, 'b', 'LineWidth', 1.5);
        plot(D(:,1),DD, 'r', 'LineWidth', 1.5);
        plot(F(:,1),FF, 'g', 'LineWidth', 1.5);
        plot(G(:,1),GG, 'm', 'LineWidth', 1.5);
        plot([startptshort startptshort], [-280 280], 'k-', 'LineWidth', 3)
        plot([endptshort endptshort], [-280 280], 'k-', 'LineWidth', 3)
        plot([startptshort endptshort], [-280 -280], 'k-', 'LineWidth', 3)
        plot([startptshort endptshort], [280 280], 'k-', 'LineWidth', 3)
        plot([startptshort2 startptshort2], [-280 280], 'k-', 'LineWidth', 3)
        plot([endptshort2 endptshort2], [-280 280], 'k-', 'LineWidth', 3)
        plot([startptshort2 endptshort2], [-280 -280], 'k-', 'LineWidth', 3)
        plot([startptshort2 endptshort2], [280 280], 'k-', 'LineWidth', 3)
        xlim([startpt endpt]); 
        datetick('x', 'mm/dd/yy','keeplimits')
        title('\bf \fontsize{24} Site 2, Unfiltered')
        ylabel('Pressure (cm)')
        hold off
        set(gcf,'color','w');
        legend('Tidal', '2.C', '2.D', '2.F', '2.G')

    subplot(row,col,3)
        plot(tidal(:,1), tt, 'k', 'LineWidth', 1.5);
        hold on;
        plot(C(:,1),CC, 'b', 'LineWidth', 1.5);
        plot(D(:,1),DD, 'r', 'LineWidth', 1.5);
        plot(F(:,1),FF, 'g', 'LineWidth', 1.5);
        plot(G(:,1),GG, 'm', 'LineWidth', 1.5);
        plot(location, pks, 'k.', 'LineWidth', 2); plot(location2, -pks2, 'k.', 'LineWidth', 2)
        plot(location1c, pks1c, 'b.', 'LineWidth', 2); plot(location1c2, -pks1c2, 'b.', 'LineWidth', 2)
        plot(location1d, pks1d, 'r.', 'LineWidth', 2); plot(location1d2, -pks1d2, 'r.', 'LineWidth', 2)
        plot(location1f, pks1f, 'g.', 'LineWidth', 2); plot(location1f2, -pks1f2, 'g.', 'LineWidth', 2)
        plot(location1g, pks1g, 'm.', 'LineWidth', 2); plot(location1g2, -pks1g2, 'm.', 'LineWidth', 2)
            grid on
            grid minor
            xlim([startptshort endptshort])
            ylim([-280 280])
            set(gca, 'XMinorTick', 'on')
            set(gca,'Xtick',startptshort:1/3:endptshort)
            set(gca,'XtickLabel',([startptshort:1/8:endptshort]-startptshort)*24)
             set(gca,'FontSize',10)
            datetick('x', 'hhPM', 'Keepticks')
            title('\bf \fontsize{24} Spring Tide')
            ylabel('Pressure (cm)')   
    subplot(row,col,4)
        plot(tidal(:,1), tt, 'k', 'LineWidth', 1.5);
        hold on;
        plot(C(:,1),CC, 'b', 'LineWidth', 1.5);
        plot(D(:,1),DD, 'r', 'LineWidth', 1.5);
        plot(F(:,1),FF, 'g', 'LineWidth', 1.5);
        plot(G(:,1),GG, 'm', 'LineWidth', 1.5);
        plot(location, pks, 'k.', 'LineWidth', 2); plot(location2, -pks2, 'k.', 'LineWidth', 2)
        plot(location1c, pks1c, 'b.', 'LineWidth', 2); plot(location1c2, -pks1c2, 'b.', 'LineWidth', 2)
        plot(location1d, pks1d, 'r.', 'LineWidth', 2); plot(location1d2, -pks1d2, 'r.', 'LineWidth', 2)
        plot(location1f, pks1f, 'g.', 'LineWidth', 2); plot(location1f2, -pks1f2, 'g.', 'LineWidth', 2)
        plot(location1g, pks1g, 'm.', 'LineWidth', 2); plot(location1g2, -pks1g2, 'm.', 'LineWidth', 2)
            grid on
            grid minor
            xlim([startptshort2 endptshort2])
            ylim([-280 280])
            set(gca, 'XMinorTick', 'on')
            set(gca,'Xtick',startptshort2:1/3:endptshort2)
            set(gca,'XtickLabel',([startptshort2:1/8:endptshort2]-startptshort2)*24)
             set(gca,'FontSize',10)
            datetick('x', 'hhPM', 'Keepticks')
            title('\bf \fontsize{24} Neap Tide')
            ylabel('Pressure (cm)')       
%}
%%
lalt_s = (la_s-lt_s)*60; 
lblt_s = (lb_s-lt_s)*60; 

lalt_n = (la_n-lt_n)*60; %minutes
lblt_n = (lb_n-lt_n)*60;

lclt_s = (lc_s-lt_s)*60; %minutes
ldlt_s = (ld_s-lt_s)*60; %minutes
lflt_s = (lf_s-lt_s)*60; %minutes
lglt_s = (lg_s-lt_s)*60; %minutes

lclt_n = (lc_n-lt_n)*60; %minutes
ldlt_n = (ld_n-lt_n)*60; %minutes
lflt_n = (lf_n-lt_n)*60; %minutes
lglt_n = (lg_n-lt_n)*60; %minutes

lilt_s = (li_s-lt_s)*60; %minutes
ljlt_s = (lj_s-lt_s)*60; %minutes

lilt_n = (li_n-lt_n)*60; %minutes
ljlt_n = (lj_n-lt_n)*60; %minutes

Name = {'A';'B';'An','Bn'};
LagTable = table(lalt_s,lalt_n,lblt_s, lblt_n,...
    'RowNames',Name);