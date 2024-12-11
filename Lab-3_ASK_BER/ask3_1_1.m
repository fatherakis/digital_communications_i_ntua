 % Create a vecotr of random integers of L different values
 % Verify that it follows uniform distribution along all values
 
 close all; clear all; clc;
 k=3; Nsymb=30000; nsamp=16; d=3;
 L=2^k;
 c = d/2;
 x=(2*floor(L*rand(1,Nsymb))-L+1);
 x=x*c;
 sum(x.^2)/length(x)
 A=[-(L+1):2:(L-1)]*c;
 hist(x,A)