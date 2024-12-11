close all
clear all
clc

%Signal Creation

Fs=2000;
Ts=1/Fs;
L=2000;
T=L*Ts;
t=0:Ts:(L-1)*Ts;
x= sin(2*pi*100*t) + 0.3*sin(2*pi*150*(t-2)) + sin(2*pi*200*t);

% Signal in Time domain

figure(1)
plot(t,x)
title('Time domain plot of x')
xlabel('t (sec)')
ylabel('Amplitude')
pause
axis([0 0.3 -2 2])
pause

% Discreate fourier transform

N= 2^nextpow2(L);
Fo= Fs/N;
f=(0:N-1)*Fo;
X= fft(x,N);

% Signal in Frequenct domain

figure(2)
plot(f(1:N),abs(X(1:N)));
title('Frequency domain plot of x')
xlabel('f (Hz)')
ylabel('Amplitude')
pause

% Bilateral Signal Spectrum

figure(3)
f=f-Fs/2;
X=fftshift(X);
plot(f,abs(X));
title('Two sided spectrum of x');
xlabel('f (Hz)');
ylabel('Amplitude')
pause

% Signal Strength and Periodogram

power=X.*conj(X)/N/L;
figure(4)
plot(f,power)
xlabel('Frequency (Hz)')
ylabel('Power')
title('{\bf Periodogram}')
pause

disp('Part2') % Add Noise 

% Noise generation and graph in Time

figure(5)
n = randn(1,2000).*0.2;
plot(t,n)
axis([0 0.3 -2 2])
xlabel('Time (sec)')
ylabel('Noise')
title('{\bf Noise Diagram}')
pause

% Noise strength and Periodogram

n_f = fft(n,N);
power_n = n_f.*conj(n_f)/N/L;
n_f = fftshift(n_f);
plot(f,power_n)
xlabel('Frequency (Hz)')
ylabel('Power')
title('{\bf Periodogram of Noise}')
pause

% Fusion of signal and noise. Representation in time domain

s = x+n;
figure(7)
plot(t,s)
axis([0 0.2 -2 2])
xlabel('Time (sec)')
ylabel('Amplitude with noise')
title('{\bf S Signal Diagram}')
pause

% Bilateral spectrum of noisy signal

s_f = fft(s,N);
s_f = fftshift(s_f);
figure(8)
plot(f, abs(s_f));
title('Two sided spectrum of Amp with noise');
xlabel('f (Hz)');
ylabel('Amplitude')
pause

disp('Part 3') % Signal multiplication with another sinusoidal

% Signal definition and time representation

f1 = 600;
x1 = sin(2*pi*f1*t);
new_s = s.*x1;
figure(9)
plot(t,new_s)
axis([0 0.2 -2 2])
xlabel('Time (sec)')
ylabel('Amplitude with noise +')
title('{\bf S*sin Signal Diagram}')
pause

% Bilateral Spectrum representation

new_s_f = fft(new_s, N);
new_s_f = fftshift(new_s_f);
figure(10)
plot(f, abs(new_s_f));
title('Frequency domain of Amp w noise +');
xlabel('f (Hz)');
ylabel('Amplitude');
pause

