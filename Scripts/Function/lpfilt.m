function fdata = lpfilt(data,delta_t,cutoff_f)
%Hornberger and Wiberg: Numerical Methods in the Hydrological Sciences
%12-13
% Peforms low-pass filtering by multiplication in frequency domain using
% a 3-point taper (in frequency space) between pass-band and stop band.
% Coefficients suggested by D. Coats, Battelle, Ventura.
% Written by Chris Sherwood, 1989; revised by P. Wiberg, 2003.
n=length(data);
mn=mean(data);
data=data-mn; %linearly detrend data series
P=fft(data); N=length(P);
filt=ones(N,1);
k=floor(cutoff_f*N*delta_t);
% filt is a tapered box car, symmetric over the 1st and 2nd half of P,
% with 1's for frequencies < cutoff_f and 0's for frequencies > cutoff_f
filt(k+1:k+3)=[0.715 0.24 0.024];
filt(k+4:N-(k+4))=0*filt(k+4:N-(k+4));
filt(N-(k+1:k+3))=[0.715 0.24 0.024];
P=P.*filt;
fdata=real(ifft(P)); %inverse fft of modified data series
fdata=fdata(1:n)+mn; %add mean back into filtered series