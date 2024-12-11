function errors=lab5_3(k,Nsymb,nsamp,EbNo)
M = 2^k; % M-PSK -> log2(M) = k
L = k;
pulse_type =1; %rtrapezium as formatting filter
%pulse_type =0 % rectangular filter

fc = 6;  %sampling frequency 

SNR=EbNo-10*log10(nsamp/k/2); %SNR per sample
ph1=[pi/4];
theta=[ph1; -ph1; pi-ph1; -pi+ph1];
mapping=exp(1j*theta);  %case k = 2 -> M = 4
if(k>2)
for j=3:k
theta=theta/2;
mapping= exp(1j*theta);
mapping=[mapping;-conj(mapping)];
theta=angle(mapping);
end
end     % " lab_5_1.m "  M-PSK encoding

x=floor(2*rand(k*Nsymb,1)); % random binary sequence
xsym=bi2de(reshape(x,k,length(x)/k).','left-msb')';
y=[];
for n=1:length(xsym)
 y=[y mapping(xsym(n)+1)];
end

%% Formatting filter definition
if (pulse_type==1) % Nyquist pulse - rtrapezium.m
delay = 8; % Group delay (# ???????? ?)
filtorder = delay*nsamp*2;
 rolloff = 0.33; % rollof factor
 % rtrapezium.m located at current directory
 shaping_filter = rtrapezium(nsamp,rolloff,delay);
else % rect pulse
 delay=0.5;
 shaping_filter=ones(1,nsamp)/sqrt(nsamp);% with normalization
end
%% transmitted signal
ytx=upsample(y,nsamp);
ytx = conv(ytx,shaping_filter);
% Calculation and graph of signal
 figure(1);pwelch(real(ytx),[],[],[],nsamp);% scale 1/T
% quadrature modulation
m=(1:length(ytx));
s=real(ytx.*exp(1j*2*pi*fc*m/nsamp));
figure(2); pwelch(s,[],[],[],nsamp);
%wvtool(s,[],[],[],nsamp);
%---------------------
% eyediagram of rectangular pulse
% if (pulse_type==1) eyediagram(ytx(1:2000),nsamp*2);
% Addition of Gaussian white noise
Ps=10*log10(s*s'/length(s)); % signal power in db
Pn=Ps-SNR; % respective signal power in db
n=sqrt(10^(Pn/10))*randn(1,length(ytx));
snoisy=s+n;%Noised Bandpass signal
clear ytx xsym s n; % resource saving
%%%%%%%%% Receiver %%%%%%%%%%%%%
% Demodulation
yrx=2*snoisy.*exp(-1j*2*pi*fc*m/nsamp); clear s;


yrx = conv(yrx,shaping_filter);
figure(3); pwelch(real(yrx),[],[],[],nsamp); % scale 1/T
yrx = downsample(yrx,nsamp); % downsampling in spectrum  nT.
yrx = yrx(2*delay+(1:length(y))); % convolution edge trimming
%----------------------
yi=real(yrx); yq=imag(yrx); % in-phase and cross-phase compontents
xrx=[]; % Binary output sequence vector
q=[0:1:M-1];
for n=1:length(yrx)  % choose closest point
[m,j]=min(abs(angle(mapping)-angle(yrx(n))));
yrx(n)=q(j);
xrx=[xrx; de2bi(q(j),k,'left-msb')'];
end
 %scatterplot(yrx);
 
%% Error Rate Calculation
 % 2 tropoi: (a) compare PSK points  (y-yrx)
 % (b) compare binary points (x-xrx)
 %ber1=sum(not(y==(yi+i*yq)))/length(x)
 ber2=sum(not(xrx==x));
 errors=ber2;
end
