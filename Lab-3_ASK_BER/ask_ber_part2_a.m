function ask_BER_eval(EbNo)
   close all
   k = mod(18870,2)+3;
   M = 20000;
   nsamp = 16;
   EbNo1 = (0:EbNo);
   % Using Theoretical value via Part_2_a_plot function
   Ber = zeros(1,length(EbNo1));
   for i=1:length(EbNo1)
      Ber(i)=Part2_a_plot(k,EbNo1(i))/k;
   end
   figure("Name","Part2.a");
   semilogy(EbNo1,Ber)
   title("BER 8-ASK , k = 3");
   xlabel("Eb/No (dB)");
   ylabel("BER");
   grid on
   hold on
   pause 

   % Using ask_errors function
   Ber1 = zeros(1,length(EbNo1));
   for i=1:length(EbNo1)
      Ber1(i)=ask_errors(k,M,nsamp,EbNo1(i))/(M*k);
   end
   semilogy(EbNo1,Ber1,'x')
   end