function errors=ask_errors(k,Nsymb,nsamp,EbNo)
    L=2^k;
    SNR=EbNo-10*log10(nsamp/2/k); 
    x=(2*floor(L*rand(1,Nsymb))-L+1);
    Px=(L^2-1)/3; % Theoretical
    sum(x.^2)/length(x); % Real
    y=rectpulse(x,nsamp);
    n=wgn(1,length(y),10*log10(Px)-SNR);
    ynoisy=y+n; % Noised signal
    y=reshape(ynoisy,nsamp,length(ynoisy)/nsamp);
    matched=ones(1,nsamp);
    z=matched*y/nsamp;
    A=[-(L+1):2:(L-1)];
    for i=1:length(z)
        [m,j]=min(abs(A-z(i)));
        z(i)=A(j);
    end
    err=not(x==z);
    errors=sum(err);
    end