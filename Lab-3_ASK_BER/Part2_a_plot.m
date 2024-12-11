function Pe=plotter(k,EbNo)
    L = 2^k;
    a = (L-1)/L;
    b = 3*k*(10^(EbNo/10));
    c = (L^2 -1);
    er = sqrt(b/c);
    Pe = a*erfc(er);
    end