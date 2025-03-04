function pq = biqtdec(NoBits,Xmin,Xmax,I)
  L=2^NoBits;
  delta=(Xmax-Xmin)/L;
  pq=Xmin+I*delta;

