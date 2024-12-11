function errors=fsk_errors(bps,Nsymb,ns,EbNo)
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % ns = 16; EbNo = 10; bps =  2; Nsymb = 32000;
 %% Input parameters
 % bps: bits per symbol (k) , Nsymb: numb of simulated symbols 
 % ns: number of samples per symbol (oversampling) (nsamp)
 % EbNo: normalized signal-to-noise ratio, in db 
 M=2^bps; %(L)
 BR=1;
 fc=2*M*BR;
 n=Nsymb/log2(M);
%% Derived parameters
 nb=bps*Nsymb; % number of different symbols
 T=1/BR; % Baud  Rate
 Ts=T/ns; % RF frequency
% M frequencies in "non-coherent" distance (BR)
 f=fc+BR/2*((1:M)-(M+1)/2);
 %awgn channel 
 SNR=EbNo+10*log10(bps)-10*log10(ns/2); %in db 
 %input data bits
 y=randi(2, 1, nb)-1;
 x=reshape(y,bps,length(y)/bps)';
 t=[0:T:length(x(:,1))*T]'; % time vector on the T grid
 tks=[0:Ts:T-Ts]';
%% FSK signal
 s=[];
 A=sqrt(2/T/ns);
for k=1:length(x(:,1))
 fk=f(bi2de(x(k,:))+1);
 tk=(k-1)*T+tks;
 s=[s; sin(2*pi*fk*tk)];
end
% add noise to the FSK (passband) signal 
s=awgn(s,SNR, 'measured');

%% FSK receiver
% coherent demodulation
th=0;
 xr=[];
for k=1:length(s)/ns
 tk=(k-1)*T+tks; sk=s((k-1)*ns+1:k*ns);
 smi=[];
for i=1:M
 si=sin(2*pi*f(i)*tk);
 smi(i)=sum(sk.*si);
 end
 [m,j]=max(smi);
 xr=[xr;de2bi(j-1,bps)];
end

% figure(2); pwelch(s,[],[],[],ns);  %Erotima 3

% count errors
 err=not(x==xr);
 errors=sum(sum(err));
end