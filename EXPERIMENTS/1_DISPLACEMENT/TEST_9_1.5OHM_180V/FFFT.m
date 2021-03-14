function [fr,ffft]=FFFT(t,y)
SAMP=t(2)-t(1);
fs=1/SAMP;
n=length(t);
fr=[0:n-1]*fs/(n);
ffft=2*(fft(y))/n;%2*abs(fft(y))/n;
end

