%close all
clear all
Nbits=2000; nsamp = 32; EbNo=10;
 n=Nbits; %data bits
 %R=270833; %  bit rate
 R = 3000000;
 %fc = 3*R;
 fc=3.3*R;    %carrier frequency
 ns=nsamp;  %upsampling factor
 %
 % link awgn
 SNR=EbNo-10*log10(ns/2); % in db

T=1/R; % period 1 bit (= vasiki period) 
Ts=T/ns;
%Ts=T/fc; % sampling frequency
% input sequence
y=[1;sign(rand(n-1,1)-0.5)]; % random numbers, -1 ? 1
 %
% pre-encoding
 x(1)=1;
for i=2:length(y)
 x(i)=y(i)*y(i-1);
end
 x=x';
 g=ones(ns,1);
 xx=conv(upsample(x,ns),g); % NRZ polar pulse sequence sample

 ts=[0:Ts:length(xx)*Ts]'; %length ns*(n+1)
 %
%% Transmitter MSK
 xs=xx;
 theta=cumsum(xs)*pi/2/ns;
 xs_i=cos(theta); % in-phase component
 xs_i=[xs_i; xs_i(length(xs_i))]; % extension by one sample
 xs_q=sin(theta); % cross-phase component
 xs_q=[xs_q; xs_q(length(xs_q))]; % extension by one sample
% modulation
 s=xs_i.*cos(2*pi*fc*ts)-xs_q.*sin(2*pi*fc*ts); 
% noise addition
figure('Name',"Part 4"); pwelch(s,[],[],fc,1/Ts);
%figure(); pwelch(xs,[],[],[],1/Ts);