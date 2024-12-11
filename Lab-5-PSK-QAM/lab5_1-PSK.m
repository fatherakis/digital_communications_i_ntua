function mapping=lab5_1(k)
% M-PSK implementation  where k = log2(M)
%close all
ph1=[pi/4];
theta=[ph1; -ph1; pi-ph1; -pi+ph1];
mapping=exp(1j*theta);
if(k>2)
 for j=3:k
 theta=theta/2;
 mapping=[exp(1j*theta)];
 mapping=[mapping; -conj(mapping)];
 theta=angle(mapping);
 end
end
if(k>=2)
    scatterplot(mapping)
    grid on
    M = 2^k;
    for j=1:M
     text(real(mapping(j)),imag(mapping(j)),num2str(de2bi((j-1),k,'left-msb')), 'FontSize', 6)
    end
end