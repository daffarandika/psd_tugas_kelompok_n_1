function [ I, pq]= biquant(NoBits,Xmin,Xmax,value)
% function pq = biquant(NoBits, Xmin, Xmax, value)
% this routine is created for simulation of uniform quantizer.
% 
%  NoBits: number of bits used in quantization.
%  Xmax: overload value.
% Xmin: minimum value
%  value: input to be quantized.
%  pq: output of quantized value
%  I: coded integer index
  L=2^NoBits;
  delta=(Xmax-Xmin)/L;
  I=round((value-Xmin)/delta);
  if ( I==L)
    I=I-1;
end
if I<0
   I=0;
end
pq=Xmin+I*delta;
