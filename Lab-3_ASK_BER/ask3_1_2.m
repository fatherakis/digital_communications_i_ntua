% Observe the effects of lower and higher Signal power to Noise ratio (Eb/No)


% Signal Generation
 k=3; Nsymb=5000; nsamp=16; EbNo=12;
 L=2^k;
 x=2*floor(L*rand(1,Nsymb))-L+1;
 Px=(L^2-1)/3; % Theoretical Power
 sum(x.^2)/length(x); % Evaluated power
 
 
 SNR=EbNo-10*log10(nsamp/2/k); % SNR per signal sample
 y=rectpulse(x,nsamp);
 n=wgn(1,length(y),10*log10(Px)-SNR); %white noise
 ynoisy=y+n; % noised signal
 y=reshape(ynoisy,nsamp,length(ynoisy)/nsamp);
 matched=ones(1,nsamp);
 z=matched*y/nsamp;
 figure("Name","EbNo=12 Part1");
 hist(z,200)
 
 pause
 
 EbNo=14;
 
 SNR=EbNo-10*log10(nsamp/2/k); % SNR per signal sample
 y=rectpulse(x,nsamp);
 n=wgn(1,length(y),10*log10(Px)-SNR);
 ynoisy=y+n; % noised signal
 y=reshape(ynoisy,nsamp,length(ynoisy)/nsamp);
 matched=ones(1,nsamp);
 z=matched*y/nsamp;
 
 figure("Name","EbNo=14 Part1"); hist(z,200)
 
 pause
 
 EbNo=18;
 
 SNR=EbNo-10*log10(nsamp/2/k); % SNR per signal sample
 y=rectpulse(x,nsamp);
 n=wgn(1,length(y),10*log10(Px)-SNR);
 ynoisy=y+n; % noised signal
 y=reshape(ynoisy,nsamp,length(ynoisy)/nsamp);
 matched=ones(1,nsamp);
 z=matched*y/nsamp;
 
 figure("Name","EbNo=18 Part1"); hist(z,200)