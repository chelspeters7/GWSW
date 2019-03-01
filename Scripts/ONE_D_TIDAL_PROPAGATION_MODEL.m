clear;clc;
%% ONE_D_TIDAL_PROPAGATION_MODEL.M 
% Manuscript: A Search for Freshwater in the Saline Aquifer of Coastal Bangladesh
% Author: Chelsea Peters, chelspeters7@gmail.com
% Last edit: 6/20/18
% Description: What thickness (or range of thicknesses) of the channel 
% clogging layer gives a tidal propagation/amplitude attenuation 
% similar to that seen on Polder 32?  
addpath(genpath('C:\Users\Chelsea\Documents\GitHub\BanglaGWSW\PiezometerAnalysis\Scripts\Function\')); %add path to main directory for function files
%% INITIALIZE MODEL 
xciii = 10;                         %Number of XC widths
TCjjj = 10;                         %Number of transmissivities
fetterlowk = 10^(-9);               %Hydraulic Conductivity, cm/s
fetterhighk = 10^(-4);              %Hydraulic Conductivity, cm/s
lowk = fetterlowk/100*60*60;        %Hydraulic Conductivity, m/h
highk = fetterhighk/100*60*60;      %Hydraulic Conductivity, m/h
b = 150;                            %Aquifer Height, m
Tlow = lowk*b;                      %Low Transmissivity, m^2/h
Thigh = 0.1;%Thigh = highk*b;       %High Transmissivity, m^2/h
allTC = linspace(Tlow, Thigh, TCjjj); %Vector of all tested transmissivities, m^2/h
dTC = allTC(2)-allTC(1);            %Step between tested transmissivities, m^2/h

%Create empty vectors for 6 different pizeometer test sites
TE20 = zeros(xciii, TCjjj);TE20_1 = zeros(xciii, TCjjj);TE20_2 = zeros(xciii, TCjjj);
TE115 = zeros(xciii, TCjjj);TE115_1 = zeros(xciii, TCjjj);TE115_2 = zeros(xciii, TCjjj);
TE5 = zeros(xciii, TCjjj);TE5_1 = zeros(xciii, TCjjj);TE5_2 = zeros(xciii, TCjjj);
TE145 = zeros(xciii, TCjjj);TE145_1 = zeros(xciii, TCjjj);TE145_2 = zeros(xciii, TCjjj);
kount = zeros(xciii,1);kount2 = zeros(1,TCjjj);
xc = 1;
%% BEGIN LOOP
% Loops through possible XC plug widths and Tc channel clogging layer
% transmissivities. 
for iii = 1:xciii               %Change xc plug width
    TC1 = Tlow;
    TC2 = Tlow;
    for jjj = 1:TCjjj           %Change channel transmissivity
        t_end = 100;                    %Length of time to run model, hrs
        dt = 1;                         %Time step, hrs
        x_end = 1000;                   %Distance between tidal channels, m
        n = 10000;                      %Number of spatial nodes to use in model

        S = 0.1;                        %Storativity of the aquifer
        TA = 10;                        %Transmissivity of the aquifer, m^2/hr

        TR1 = 1.22;                     %Transmissivity of channel 1
        TR2 = 0;                        %Transmissivity of channel 2
        RR = 2;                         %Recharge rate (0=none;1=low;2=normal;3=high; 
                                        %based on characteristic yearly precipitation 
                                        %in Bangladesh)
        tidecut = 'relative';           %Numerical value: Minimum absolute value 
                                        %below which tidal contributions are considered 
                                        %negligible;
        relcut = 0.05;                  %Percentage of tidal range below which tidal 
                                        %influences are considered negligible
        avi = 0;                        %Save video as avi (0=no; 1=yes)
        % ========================================================================
        % INITIALIZE MODEL USING INPUTS
        % Set time and space nodes
        t=0:dt:t_end;
        dx=x_end/(n+1);
        % Initialize movie configuration
        v=0;
        nframes=t_end;
        temp1=t_end/nframes;
        cw=0.05*x_end;
        % Break down tidal range into components
        % s=sun; m=moon; 0=Channel 1; X=Channel 2
        s0=TR1*1/3;
        sX=TR2*1/3;
        m0=TR1*2/3;
        mX=TR2*2/3;
        % Monsoon pulse (superimposed on tidal range below)
        mon0=0.8*0; monX=0.8*0;
        % x_bar cutoff determined by absolute or relative method
        % If tidecut=='relative' then cutoff set as a percentage (relcut) of
        % the total tidal range as assigned below. Otherwise, tidecut is the cutoff
        % value.
        if strcmp(tidecut,'relative')==1
         tidecut=relcut*2*(m0+s0);
        end
        % Initial head values
        h_old=zeros(n,1);
        % Assigns variable transmissivities using a geometric mean
        nc=round(xc/dx); % Configure node response to variable transmissivity
        T(1:nc)=TC1;
        T(nc+1:n-nc)=TA;
        T(n-nc+1:n+2)=TC2;
        Th_minus=zeros(1,n);
        Th_plus=zeros(1,n);
        r=zeros(1,n);
        for k=2:n+1
            Th_minus(k-1)=sqrt(T(k-1)*T(k));
            Th_plus(k-1)=sqrt(T(k)*T(k+1));
            r(k-1)=dt/(S*dx^2)*(Th_minus(k-1)+Th_plus(k-1)); % coefficients(r=T/S*dt/dx^2)
        end
        r=r';
        % Assign recharge values per time step
        Rch=zeros(1,length(t)); % Initial recharge values
        jcount=t/720;
        jcount=ceil(mod(jcount,12));
        r1=0; r2=0; % Initial recharge rates
        % Assign recharge based on initial input
        if RR==1 % Low
         r1=1e-6; r2=1e-6;
        elseif RR==2 % Normal
         r1=3e-6; r2=2e-6;
        elseif RR==3 % High
         r1=6e-6; r2=5e-6;
        end
        % Only assigns recharge for June (6), July (7), Aug (8), Sept (9); All
        % other months recharge is zero
        jj= jcount==6; Rch(jj)=r1;
        jj= jcount==7; Rch(jj)=r1;
        jj= jcount==8; Rch(jj)=r2;
        jj= jcount==9; Rch(jj)=r2;
        % Head of the tidal channels (Boundary Conditions)
        h0=m0*sin(2*pi*t/12.42)+s0*sin(2*pi*t/12)+mon0*sin(2*pi*t/8760+3*pi/4);
        hX=mX*sin(2*pi*t/12.42)+sX*sin(2*pi*t/12)+monX*sin(2*pi*t/8760+3*pi/4);
        % Construct the finite-difference matrix
        m_diag=sparse(1:n,1:n,1+2*r,n,n);
        l_diag=sparse(2:n,1:n-1,-r(2:n),n,n);
        u_diag=sparse(1:n-1,2:n,-r(1:n-1),n,n);
        A=m_diag+l_diag+u_diag;
        % Preallocate solution matrix
        h_all=zeros(n,length(t));
        % ========================================================================
        % SOLVE EQUATIONS for length(t) time steps
        for j=1:length(t)
            R=Rch(j);
            I=0; % Irrigation term (set manually)
            RHS=h_old+R*dt/S+I*dt/S;
            RHS(1)=RHS(1)+r(1)*h0(j);
            RHS(n)=RHS(n)+r(n)*hX(j);
            h_new=A\RHS;
            h_all(:,j)=h_new; %Head values for all space and times
            h_old=h_new;
        end
        % ========================================================================
        % FILTER DATA
        x_bar=zeros(1,n); % Initial x_bar values
        h_amp=zeros(1,n); % Initial h_amp values
        for i=1:n
            % HIGH-PASS FILTER
            % do a low-pass filter to determine monsoonal signal
            % subtract the low frequency signal from the data to obtain the tidal signal
            % DETREND AND TRANSFORM DATA
            y = h_all(i,:);
            X=length(y);
            mn=mean(y);
            data = y-mn; % Detrend data series by removing mean
            delta_t = dt/8760; % Time step associated with data
            % CALL LOW-PASS FILTER FUNCTION
            cutoff_f = 120/dt;
            fdata=lpfilt(data',delta_t,cutoff_f);
            fdata=fdata+mn; % add mean back
            % FIND HIGH FREQUENCIES
            fdata2=y-fdata'; % Subtract low-pass data from original data
            % RECORD WHETHER NODES INFLUENCED BY THE TIDES
            nOK=round(X/10);
            h_amp(i)=max(fdata2(nOK+1:X-nOK))-min(fdata2(nOK+1:X-nOK)); %Head amplitude for each node (over all times)
            x_bar(i)=0;
            if h_amp(i) >= tidecut
            x_bar(i)=1;
            end
        end
        % ========================================================================
        % % FIND THE NODE WHEN TIDES BECOME NEGLIGIBLE
        % ii=find(diff(x_bar)~=0);
        % if ~isempty(ii)
        % THI=ii(1)*dx; % Convert to real world distance from tidal channel
        % else
        % THI=x_bar(1)*x_end/2; % Tidal signal extends the length of aquifer
        % end
        % ========================================================================
        h5 = h_amp(5); %Site 1 Piezometer A, approx. 5 m from channel
        %TE5(iii, jjj) = h5/h1;
        %TE5_1(iii, jjj)=range(h_all(5,:))/range(h_all(1,:));
        TE5_2(iii, jjj)=std(h_all(5,:))/std(h_all(1,:));
        TE5ideal = 0.2132; %TE

        h145 = h_amp(145); %Site 1, Piezometer B, approx. 145 m from channel (59)
        %TE145(iii, jjj) = h145/h1;
        %TE145_1(iii, jjj)=range(h_all(145,:))/range(h_all(1,:));
        TE145_2(iii, jjj)=std(h_all(145,:))/std(h_all(1,:));
        TE145ideal = 0.4785; %TEh20 = h_amp(20); %Site 2, Piezometers C and D, approx. 20 m from channel
        
        h1 = h_amp(1);
        %TE20(iii, jjj) = h20/h1;
        %TE20_1(iii, jjj)=range(h_all(20,:))/range(h_all(1,:));
        TE20_2(iii, jjj)=std(h_all(20,:))/std(h_all(1,:));
        TE20ideal = (0.2964+0.2805)/2; %Average of medium and deep wells TE

        h115 = h_amp(115); %Site 2, Piezometers F and G, approx. 115 m from channel
        %TE115(iii, jjj) = h115/h1;
        %TE115_1(iii, jjj)=range(h_all(115,:))/range(h_all(1,:));
        TE115_2(iii, jjj)=std(h_all(115,:))/std(h_all(1,:));
        TE115ideal = (0.2504+0.2195)/2; %Average of medium and deep wells TE
       % ========================================================================
        kount(iii, 1) = xc;
        kount2(1,jjj) = TC1;
        xc = 1 + (iii*1.5);
        TC1 = Tlow + (jjj*dTC);
        TC2 = TC1;
    end
end
%% CREATE TABLES
% for each piezometer distance using tidal efficiency comparisons
diff20 = abs(TE20ideal - TE20_2);
valdiff20 = diff20 < 0.1;
prod20 = valdiff20.*diff20;
[row20, col20, v20] = find(prod20);
xcdist20 = kount(row20,1);
TC20 = kount2(1,col20);
Table20 = table(xcdist20, TC20', v20, 'VariableNames',{'PlugWidth' 'T' 'DifferenceIdealTE'});

diff115 = abs(TE115ideal - TE115_2);
valdiff115 = diff115 < 0.1;
prod115 = valdiff115.*diff115;
[row115, col115, v115] = find(prod115);
xcdist115 = kount(row115,1);
TC115 = kount2(1,col115);
Table115 = table(xcdist115, TC115', v115, 'VariableNames',{'PlugWidth' 'T' 'DifferenceIdealTE'});

diff5 = abs(TE5ideal - TE5_2);
valdiff5 = diff5 < 0.3;
prod5 = valdiff5.*diff5;
[row5, col5, v5] = find(prod5);
xcdist5 = kount(row5,1);
TC5 = kount2(1,col5);
Table5 = table(xcdist5, TC5', v5, 'VariableNames',{'PlugWidth' 'T' 'DifferenceIdealTE'});

diff145 = abs(TE145ideal - TE145_2);
valdiff145 = diff145 < 0.1;
prod145 = valdiff145.*diff145;
[row145, col145, v145] = find(prod145);
xcdist145 = kount(row145,1);
TC145 = kount2(1,col145);
Table145 = table(xcdist145, TC145', v145, 'VariableNames',{'PlugWidth' 'T' 'DifferenceIdealTE'});


