EbNo1 = (0:0.2:22);
Ber1 = zeros(1,length(EbNo1));
for i=1:length(EbNo1)
   Ber1(i)=lab4_4function(4,2,50000,20,EbNo1(i))/(50000*4);
end
semilogy(EbNo1,Ber1,'x')