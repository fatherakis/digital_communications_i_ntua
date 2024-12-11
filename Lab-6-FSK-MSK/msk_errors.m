function errors=msk_errors(Nbits,nsamp,EbNo)
% defined parameters
 n=Nbits; %data bits
 %R=270833; %  bit rate
 R = 3000000;
 %fc = 3*R;
 fc=3.3*R;    %carrier frequency
 ns=nsamp;  %upsampling factor
 %
 % awgn link
 SNR=EbNo-10*log10(ns/2); % in db
% generated parameters
T=1/R; % period 1 bit (= base period) 
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
 % time grid
 ts=[0:Ts:length(xx)*Ts]'; %length ns*(n+1)
 %
%%  MSK transmitter
 xs=xx;
 theta=cumsum(xs)*pi/2/ns;
 xs_i=cos(theta); % in-phase component
 xs_i=[xs_i; xs_i(length(xs_i))]; % extension with one more sample
 xs_q=sin(theta); % cross-phase component
 xs_q=[xs_q; xs_q(length(xs_q))]; % extension with one more sample
% Modulation
 s=xs_i.*cos(2*pi*fc*ts)-xs_q.*sin(2*pi*fc*ts); 
% Noise addition
s=awgn(s,SNR, 'measured');
%% Receiver MSK
 xs_i=s.*cos(2*pi*fc*ts);
 xs_q=-s.*sin(2*pi*fc*ts);
 % Filter LP (Parks-McClellan)
 f1=0.75/ns; f2=4*f1;
 order=4*ns;
 fpts=[0 f1 f2 1];
 mag=[1 1 0 0];
 wt=[1 1];
 b = firpm(order,fpts,mag,wt);
 a=1;
 len=length(xs_i);
 dummy=[xs_i;zeros(order,1)];
 dummy1=filter(b,a,dummy);
 delay=order/2; % try with delay=0!
 xs_i=dummy1(delay+(1:len));
 dummy=[xs_q;zeros(order,1)];
 dummy1=filter(b,a,dummy);
 delay=order/2;
 xs_q=dummy1(delay+(1:len));
 bi=1; xr_1=1;
 for k=1:2:n-1
 li=(k*ns+1:(k+2)*ns)';
 lq=((k-1)*ns+1:(k+1)*ns)';
 xi=xs_i(li);
 xq=xs_q(lq);
 gmi=cos(pi/2/T*Ts*li); % pulse matched-filter
 gmq=-gmi; % =sin(pi/2/T*Ts*lq);
 bi_1=bi;
 bi=sign(sum(xi.*gmi));
 bq=sign(sum(xq.*gmq));
 % without pre-encoding: uncomment 2 below
  xr(k)=bi_1*bq;
  xr(k+1)=bi*bq;
 % with pre-encoding: uncomment 2 below
  %xr(k)=xr_1*bi_1*bq;
  %xr(k+1)=xr(k)*bi*bq;
  xr_1=xr(k+1);
 end 
 xr=xr';
 err=sum(not(x==xr)); %without pre-encoding
 %err=sum(not(y==xr));
 errors=sum(err);
end