% Simple signal creation and FFT

Fs=1000; %Freq
Ts=1/Fs; %Period
T=1;    
t=0:Ts:T-Ts;
A=1;

x=A*sin(2*pi*100*t);
L=length(x);
plot(t,x)
pause

%Discreate Sine wave
N = 2 * L; 
Fo = Fs/N;
Fx = fft(x,N);
freq=(0:N-1)*Fo;
plot(freq,abs(Fx))
title('FFT')
pause              
axis([0 100 0 L/2])
pause

power = Fx.*conj(Fx)/Fs/L;
plot(freq,power)
xlabel('Frequency (Hz)')
ylabel('Power')
title('{\bf Periodogram}')


power_theory=A^2/2
dB=10*log10(power_theory)
power_time_domain=sum(abs(x).^2)/L
power_frequency_domain=sum(power*Fo)



