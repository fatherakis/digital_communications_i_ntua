
clear all; close all; clc;

load lab2_sima;
figure;

pwelch(s,[],[],[],Fs);
% Bandpass filter frequencies
f1=1500;
f2=3000;

Ts = 1/Fs;
f2m1= (f2-f1);
f2p1=(f2+f1)/2; N=256;
t=[-(N-1):2:N-1]*Ts/2;

% We define the bandpass filter function using its detailed definition and multiply with kaiser window (could use Hamming)

hbp=2/Fs*cos(2*pi*f2p1*t).*sin(pi*f2m1*t)/pi./t;

hbpw=hbp.*kaiser(length(hbp),5)';
wvtool(hbpw);
sima_bpw=conv(s,hbpw);
figure;
pwelch(sima_bpw,[],[],[],Fs);
pause

% Parks-McClellan Filter
hpm=firpm(256, [0 f1*0.96 f1*1.04  f2*0.96 f2*1.01 0.5*Fs]*2/Fs, [0 0 1 1 0 0]);
% Due to a bug, we use f2*1.01. Using 1.02 causes an undesirable lobe
% For lower values like 1.001 the filter cuts earlier than desired.

figure;
freqz(hpm,1);
wvtool(hpm);
s_pm=conv(s,hpm);
figure;
pwelch(s_pm,[],[],[],Fs);