function errors=ask_Nyq_filter(k,step,Nsymb,nsamp,EbNo)
%k=4; step = 2; Nsymb = 20000; nsamp = 16; EbNo = 14;
L = 2^k;
%% transmission with Nyquist pulses
delay = 4; %Group delay (# of input symbols)
filtorder = delay*nsamp*2; %filter order
rolloff = 0.35; %rolloff factor
%Impulse response of root raised cosine filter
rNyquist = rcosine(1,nsamp,'fir/sqrt',rolloff,delay);
%figure; freqz(rNyquist);

%% gray coding

%mapping=-(L-1):step:(L-1); %non - grey coding

mapping=[step/2; -step/2];
if(k>1)
    for j=2:k
        mapping=[mapping+2^(j-1)*step/2; -mapping-2^(j-1)*step/2];
    end
end



x=randi(2,1,k*Nsymb)-1;
xsym=bi2de(reshape(x,k,length(x)/k).','left-msb'); %binary to dec for conversion
y1=[];
for i = 1:length(xsym)
    y1=[y1 mapping(xsym(i)+1)];
end

y = upsample(y1,nsamp); %upsampling
ytx = conv(y,rNyquist);
%------NOISE-----
SNR = EbNo-10*log10(nsamp/2/k); %SNR per sample
Py=10*log10(ytx*ytx'/length(ytx)); % Signal Power (dB)
Pn=Py-SNR; %Noise Power
n=sqrt(10^(Pn/10))*randn(1,length(ytx));
ynoisy=ytx+n;

yrx = conv(ynoisy,rNyquist);
yrx = yrx(2*delay*nsamp+1:end-2*delay*nsamp); %edge trimming

yr = downsample(yrx,nsamp); % samples at kT times

xr=[];
for i=1:length(yr)
    [m,j]=min(abs(mapping-yr(i)));
    xr=[xr de2bi(j-1,k,'left-msb')];
end
errors=sum(not(x==xr));

