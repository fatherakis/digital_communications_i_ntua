function [rtrfilter Ho]=rtrapezium(nsamp,rolloff,delay)
F0 = 1/2/nsamp;
% hypersampling for accuracy
dense=32;
nsamp1=nsamp*dense;
F1=F0*(1-rolloff); F2=F0*(1+rolloff);
N = 2*delay*nsamp1;   %filter order , length of impulse response
for k=1:N/2
    f=(k-1)/N;
    if (f<F1) Ho(k)=1;
    elseif (f>F2) Ho(k)=0;
    else Ho(k)=max(0,1-(f-F1)/(F2-F1)); 
    end
    Ho(N/2+1)=0;
    Ho(N+2-k)=Ho(k);
end
H=sqrt(Ho).*exp(j*pi*(N+2)/(N+1)*[0:N]);
h=ifft(H,'symmetric');
% rectangular window
M=N/dense;
for k=-M/2:M/2
    rtrfilter(k+M/2+1)=h(N/2+1+k);
end
% normalization
rtrfilter=rtrfilter/sqrt(sum(rtrfilter.^2));
end