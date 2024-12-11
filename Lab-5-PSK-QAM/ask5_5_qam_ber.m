function [ber,numBits] = ask5_5_qam_ber(EbNo, maxNumErrs, maxNumBits)
% Import Java class for BERTool.
import com.mathworks.toolbox.comm.BERTool;
%  Initialize variables related to exit criteria.
totErr  = 0; % Number of errors observed
numBits = 0; % Number of bits processed
% ?. --- Set up parameters. ---
% --- INSERT YOUR CODE HERE.
k= 4; % number of bits per symbol
Nsymb=2000; % number of symbols in each run
nsamp=16; % oversampling,i.e. number of samples per T


%  Simulate until number of errors exceeds maxNumErrs
% or number of bits processed exceeds maxNumBits.
while((totErr < maxNumErrs) && (numBits < maxNumBits))
   % Check if the user clicked the Stop button of BERTool.
      if (BERTool.getSimulationStop)
         break;
end
% ?. --- INSERT YOUR CODE HERE. 

errors=ask5_5_qam_sim(k,Nsymb,nsamp,EbNo);

% Assume Gray coding: 1 symbol error ==> 1 bit error 
totErr=totErr+errors;
numBits=numBits + k*Nsymb;
end    % End of loop
% Compute the BER
ber = totErr/numBits;