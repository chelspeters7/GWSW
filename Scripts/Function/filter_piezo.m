function [filtered_data]= filter_piezo(x,y)
    filtered_data=lpfilt(y(~isnan(y)),5/60,1/38);
    %p = plot(x(~isnan(x)),filtered_data, 'r', 'LineWidth',1.5);