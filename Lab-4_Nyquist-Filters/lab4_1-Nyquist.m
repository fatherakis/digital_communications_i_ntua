close all;
k=4; 
Nsymb = 10000;
nsamp = 20;
EbNo = 14;
step = 2;
L = 2^k;
%% Transmission with Nyqiust pulses
delay = 6; %Group delay (# of input symbols)
filtorder = delay*nsamp*2; %filter order
rolloff = 0.25; %rolloff factor
%Impulse response of root raised cosine filter
rNyquist = rcosine(1,nsamp,'fir/sqrt',rolloff,delay);
%figure; freqz(rNyquist);

%% gray coding

mapping=[step/2; -step/2];
if(k>1)
    for j=2:k
        mapping=[mapping+2^(j-1)*step/2; -mapping-2^(j-1)*step/2];
    end
end


%x=round(rand(1,k*Nsymb));
x=randi(2,1,k*Nsymb)-1;
xsym=bi2de(reshape(x,k,length(x)/k).','left-msb'); %binary to dec for conversion
y1=[];
for i = 1:length(xsym)
    y1=[y1 mapping(xsym(i)+1)];
end
%y = upsample(x,nsamp);
y = upsample(y1,nsamp); %upsampling is required
ytx = conv(y,rNyquist); %emmiter
%------NOISE-----
SNR = EbNo-10*log10(nsamp/2/k); %SNR per signal sample
Py=10*log10(ytx*ytx'/length(ytx)); %Signal Power (dB)
Pn=Py-SNR; %Noise Power
n=sqrt(10^(Pn/10))*randn(1,length(ytx));
ynoisy = ytx + n;
%ynoisy=awgn(ytx,SNR,'measured');

yrx = conv(ynoisy,rNyquist); %dektis
yrx = yrx(2*delay*nsamp+1:end-2*delay*nsamp); % Edge trimming
grid on;
hold on;
yr = downsample(yrx,nsamp); % samples at kT time

plot(yrx(64:64+12*nsamp));
pause
stem(y(64:64+12*nsamp));
pause
figure; pwelch(yrx,[],[],[],1);
%stem([1:nsamp:nsamp*12],yr(1:12),'filled');

xr=[];
for i=1:length(yr)
    [m,j]=min(abs(mapping-yr(i)));
    xr=[xr de2bi(j-1,k,'left-msb')];
end

errors=sum(not(x==xr));
