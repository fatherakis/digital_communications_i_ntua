function errors=ask6_5(nsamp,Nsymb,EbNo)
k = 2;
M = 2^k; %  log2(M) = k
L = k;
pulse_type =1; % rtrapezium as formatting filter
%pulse_type =0 
R = 3000000;
T=1/R; % period 1 bit
Ts=T/nsamp;
fc = 10;  %sampling frequency
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
end 

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
 rolloff = 0.5; % Filter dispersion factor
 % rtrapezium.m in current working directory
 shaping_filter = rtrapezium(nsamp,rolloff,delay);
else % rect pulse
 delay=0.5;
 shaping_filter=ones(1,nsamp)/sqrt(nsamp);% with normalization
end
%% Transmitting signal
ytx=upsample(y,nsamp);
ytx = conv(ytx,shaping_filter);
% Calculation and graph of signal
 figure();pwelch(real(ytx),[],[],[],nsamp);% in scale 1/T
% quadrature modulation
m=(1:length(ytx));
s=real(ytx.*exp(1j*2*pi*fc*m/nsamp));
figure(); pwelch(s,[],[],[],nsamp);
%---------------------
% Eyediagram for rectangular pulse
% if (pulse_type==1) eyediagram(ytx(1:2000),nsamp*2);
% Addition of Gaussian white noise
Ps=10*log10(s*s'/length(s)); % signal power in db
Pn=Ps-SNR; % respective signal power in db
n=sqrt(10^(Pn/10))*randn(1,length(ytx));
snoisy=s+n;%Noised Bandpass signal
clear ytx xsym s n; % resourse saving
%%%%%%%%% Receiver %%%%%%%%%%%%%
% Demodulation
yrx=2*snoisy.*exp(-1j*2*pi*fc*m/nsamp); clear s;


yrx = conv(yrx,shaping_filter);
figure(); pwelch(real(yrx),[],[],[],nsamp); % klimaka 1/T
yrx = downsample(yrx,nsamp); % downsampling in spectrum  nT.
yrx = yrx(2*delay+(1:length(y))); % convolution edge trimming
%----------------------
%yi=real(yrx); yq=imag(yrx); % in-phase and cross-phase components
xrx=[]; % Binary output sequence vector
q=[0:1:M-1];
for n=1:length(yrx)  % choose closest point
[m,j]=min(abs(angle(mapping)-angle(yrx(n))));
yrx(n)=q(j);
xrx=[xrx; de2bi(q(j),k,'left-msb')'];
end
% scatterplot(yrx);
 
%% Error Rate Calculation
 % 2 tropoi: (a) compare PSK points  (y-yrx)
 % (b) compare binary points (x-xrx)
 %ber1=sum(not(y==(yi+i*yq)))/length(x)
 ber2=sum(not(xrx==x));
 errors=ber2;
end
