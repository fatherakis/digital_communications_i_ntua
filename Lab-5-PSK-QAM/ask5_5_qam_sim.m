function errors=ask5_5_qam_sim(k,Nsymb,nsamp,EbNo)
M=k^2;
L=sqrt(M);
l=log2(L);
pulse_type=1; %  rtrapezium as formatting filter
% pulse_type=0; % rectangular pulse
fc=4.8; % carrier frequency.
SNR=EbNo-10*log10(nsamp/k/2); % SNR per signal sample
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
core=[1+i;1-i;-1+i;-1-i];
mapping=core;
if(l>1)
for j=1:l-1
mapping=mapping+j*2*core(1);
mapping=[mapping;conj(mapping)];
mapping=[mapping;-conj(mapping)];
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% ������ %%%%%%%%%%%%
x=floor(2*rand(k*Nsymb,1)); % random binary sequence
xsym=bi2de(reshape(x,k,length(x)/k).','left-msb')';
y=[];
for n=1:length(xsym)
y=[y mapping(xsym(n)+1)];
end
%% Formatting filter definition
if (pulse_type==1) % Nyquist pulse -- rtrapezium
delay = 8; % Group delay (# periodon T)
filtorder = delay*nsamp*2;
rolloff = 0.33; % Filter dispersion factor
% H rtrapezium is in the current working directory
shaping_filter = rtrapezium(nsamp,rolloff,delay);
else % rectangular pulse
delay=0.5;
shaping_filter=ones(1,nsamp)/sqrt(nsamp);% with normalization
end
%% Transmitted signal
ytx=upsample(y,nsamp);
ytx = conv(ytx,shaping_filter);
% calculation and plot of signal
%figure(1); pwelch(real(ytx),[],[],[],nsamp); % scale 1/T
% quadrature modulation
m=(1:length(ytx));
s=real(ytx.*exp(1j*2*pi*fc*m/nsamp));
%figure(2); pwelch(s,[],[],[],nsamp); % se klimaka 1/T
% ---------------------
% eyediagram for rectangular pulse
% if (pulse_type==1) eyediagram(ytx(1:2000),nsamp*2);
% prosthiki Leukou gausianou thorivou
Ps=10*log10(s*s'/length(s)); % Signal Power (dB)
Pn=Ps-SNR; % Noise Power (dB)
n=sqrt(10^(Pn/10))*randn(1,length(ytx));
snoisy=s+n; % Noisy bandpass signal
clear ytx xsym s n; % resource optimization
%%%%%%%%% Dekths %%%%%%%%%%%%%
% Demodulation
yrx=2*snoisy.*exp(-1j*2*pi*fc*m/nsamp); clear s;
%  Normally a bandpass filter follows
%  However since we use Nyquist format, it isn't required
%  Since the formatting Nyquist filter is also a good bandpass filter
yrx = conv(yrx,shaping_filter);
%figure(3); pwelch(real(yrx),[],[],[],nsamp); % scale 1/T
yrx = downsample(yrx,nsamp); % downsampling in spectrum nT
yrx = yrx(2*delay+(1:length(y))); % convolution edge trimming
% ----------------------
yi=real(yrx); yq=imag(yrx); % in-phase and cross-phase components 
xrx=[]; %Binary output sequence Vector
q=[-L+1:2:L-1];
for n=1:length(yrx) % Select closest point
[m,j]=min(abs(q-yi(n)));
yi(n)=q(j);
[m,j]=min(abs(q-yq(n)));
yq(n)=q(j);
end
err=not(y==(yi+i*yq));
errors=sum(err);
end