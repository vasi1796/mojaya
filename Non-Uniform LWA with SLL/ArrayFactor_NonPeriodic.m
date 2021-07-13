function [AF]=ArrayFactor_NonPeriodic(N,alpha,beta,d);


   alphaAF=alpha;
   betaAF=beta;
   distance=d;    
   minSLL=-6;
   sita=0:0.02:pi;
    
   frp=15*10^9;
   c=3*10^8;
   wn=2*pi*frp/c;

AF0=zeros(N,length(sita));

  for n=1:N
         
       phase=-(n-1)*distance(n)*betaAF(n);
       mag=exp(-alphaAF(n)*(n-1)*distance(n));
       AF0(n,:)=mag*exp(sqrt(-1)*(n-1)*wn*distance(n)*cos(sita)+sqrt(-1)*phase);

  end
  anAF=sum(AF0(1:N,:));
  actAF=abs(anAF);
  maxAF=max(actAF);
  AF=20*log10(actAF/maxAF);
  

end