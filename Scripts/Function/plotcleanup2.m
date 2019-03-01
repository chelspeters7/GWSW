function H = plotcleanup2(hAx,hLine1,hLine2,ylabelon, yylabelon, adjustx, shallow)

% Provide example initial and final date
inoutlim = [datenum('5-1-2014') datenum('6-1-2016')];
abcd = linspace(datenum('05-01-2014'),datenum('06-01-2016'),26);
monthvec = {'', 'J','','A','', 'O','','D','', 'F','', 'A', '','J', '', ...
        'A', '', 'O', '', 'D',  '', 'F', '','A', '', 'J'};
in = '20140401';
fi = '20160601';

% Decompose with datevec, count number of months, and skip one month if day > 1
infi    = datevec({in,fi},'yyyymmdd');
nmonths = diff(infi(:,1:2))*[12 1]' + infi(1,2);
skipone = infi(1,3) ~= 1;

% Calculate dates 
out = datenum(infi(1), (infi(1,2) + skipone):nmonths, 1);

if shallow == 0    
ylim(hAx(1),[-700 100]); 
ylim(hAx(2),[0 40]);
set(hAx(1),'xtick',[]) %'xticklab',[],
set(gca,'Xtick',out);%set(hAx(1),'xtick',linspace(datenum('04-01-2014'),datenum('06-01-2016'),27));
datetick(hAx(1),'x','m', 'KeepTicks')
datetick(hAx(2),'x','m')
%set(hAx(2),'xtick',get(hAx(1),'xtick'))%'xticklab',get(hAx(1),'xticklab'
set(hAx(1),'FontSize',14)
set(hAx(2),'Box','off'); %remove y1 ticks from the right side
set(hAx(1),'Box','on'); %remove y2 ticks from the left side

set(hAx(1),'ytick',[-600,-400,-200,0],'FontSize',14,'yticklabel',{'600', '400', '200', '0'} )
set(hAx(2),'ytick',[]);
set(hAx(2),'ytick',[5,15,25,35],'FontSize',14)
set(gca,'ycolor',[0 0 0])
set(gca,'xcolor',[0 0 0])

xlim(hAx(1),inoutlim); 
xlim(hAx(2),inoutlim);
set(hAx(1),'Xgrid','on')
set(hAx(1),'FontSize',14)
set(gca,'xcolor',[0 0 0])
set(hLine2,'LineWidth',1.5);
end

if shallow == 1
    ylim(hAx(1),[400 700]);%[1000 1300]); 
    ylim(hAx(2),[0 60]);
    set(hAx(1),'xtick',[]) %'xticklab',[],
    set(gca,'Xtick',out);
    datetick(hAx(1),'x','m', 'KeepTicks')
    datetick(hAx(2),'x','m')
    set(hAx(2),'xtick',get(hAx(1),'xtick'))%,'xticklab',get(hAx(1),'xticklab')
    set(hAx(2),'Box','on'); %remove y1 ticks from the right side
    set(hAx(1),'Box','on'); %remove y2 ticks from the left side
    set(hAx(1),'ytick',[400,450,500,550,600,650,700],'FontSize',16)% set(hAx(1),'ytick',[1000,1050,1100,1150,1200,1250,1300],'FontSize',10)
    set(hAx(2),'ytick',[0,10,20,30,40,50,60],'FontSize',16)
    xlim(hAx(1),inoutlim); 
    xlim(hAx(2),inoutlim);
    set(gca,'ycolor',[0 0 0])
    set(gca,'xcolor',[0 0 0])
    set(hAx(1),'Xgrid','on')
    set(gca,'xcolor',[0 0 0])
    set(hLine2,'LineWidth',1.5);
end
if ylabelon == 1
    ylabel(hAx(1),'Depth bgl (cm)','FontSize',20)
    set(gca,'ycolor',[0 0 0])
end
if yylabelon == 1
   ylabel(hAx(2),'{\color[rgb]{0.8500 0.3250 0.0980}Tem (C)}  {\color[rgb]{0.9290 0.6940 0.1250}SpC  (mS/cm)}','FontSize',20) % right y-axis
   set(gca,'ycolor',[0 0 0])
end
if adjustx == 1
    set(hAx(2),'xtick',[])
    set(gca,'ycolor',[0 0 0])
    set(gca,'xcolor',[0 0 0])
    %set(gca,'Xtick',out2);
    set(gca,'XTick',abcd); 
    set(gca,'XTickLabel', monthvec);
end

