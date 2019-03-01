%% Cleandata_salinity.m
% Clean deep piezometer data but does not smooth specific conductivity
function [clean] = cleandata_salinity(data)
[~,n] = size(data);
if n==4
    cut = [find(data(:,2)>2000); find(data(:,2)<1300)];
    cut2 = [find(data(:,3)>30); find(data(:,4)<4)];
    data(cut2,:) = NaN;
    data(cut,:) = NaN;
    abcdef = data(:,4);
    %data(:,4)=smoothn2(data(:,4),1e12);
elseif n==3
    cut = [find(data(:,2)>2000); find(data(:,2)<1300); find(data(:,3)>30)];
    data(cut,:) = NaN;
end
clean = data;
