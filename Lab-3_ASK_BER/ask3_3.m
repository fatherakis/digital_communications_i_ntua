function errors=ask_errors2(k,Nsymb,nsamp,EbNo)
 L=2^k;
 SNR=EbNo-10*log10(nsamp/2/k); 
 x=2*floor(L*rand(1,Nsymb))-L+1;
 Px=(L^2-1)/3; % Theoretical
 sum(x.^2)/length(x); % Real
 
 %h = ones(1,nsamp);  %Rectangular Filter impulse response
 h=cos(2*pi*(1:nsamp)/nsamp);  %Sinusoidal pulse impulse response
 h = h/sqrt(h*h');
 
 
 y = upsample(x,nsamp);% Dense plegma conversion
 y = conv(y,h);% Convolution with impulse resonse
 y = y(1:Nsymb*nsamp); %Excess convolution tail trimming
 
 ynoisy=awgn(y,SNR,'measured'); % Noised signal
 %ynoisy = y;                     % Non noised signal

 %Customized filter with the impulse response
 matched = h;
 
 yrx=conv(ynoisy,matched);
 z = yrx(nsamp:nsamp:Nsymb*nsamp);
 A=[-L+1:2:L-1];
 for i=1:length(z)
 [m,j]=min(abs(A-z(i)));
 z(i)=A(j);
 end
 err=not(x==z);
 errors=sum(err);
 end