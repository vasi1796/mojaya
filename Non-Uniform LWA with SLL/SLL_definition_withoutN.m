clear all; clc;

ita=30000; %
pop=10; 
sita=0:0.02:pi; 
c=3e8;
f=15e9;
k0=2*pi*f/c;
minSLL=-10; %in dB, minimize SLL



sita_mid1=deg2rad(78); %The smaller angle
sita_mid2=deg2rad(82); %The bigger angle
tol=deg2rad(3); %beamwidth/2

%target SLL- a vector stores the indices of the theta-SLL-region
k=1;

for i=0:0.02:pi
    if i> sita_mid2+tol 
      ind_v(k)=k;
    elseif sita_mid1+tol<i & i<sita_mid2-tol
        ind_v(k)=k;
    elseif i<sita_mid1-tol 
        ind_v(k)=k;
    end
    k=k+1;
end
ind_v=nonzeros(ind_v)'; %defined once
goal=length(ind_v);

%%
%define N
N=30;



% define alpha 0<alfa<100
alpha_min=0.1;
alpha_max=1.5*k0;


for i=1:pop

alphaMrx=alpha_min+(alpha_max-alpha_min)*rand(N,1);
samplenow_alpha(i,1:length(alphaMrx))=alphaMrx;

end

%define beta
beta_min=-1.3*k0;
beta_max=1.3*k0;

for i=1:pop

betaMrx=beta_min+(beta_max-beta_min)*rand(N,1);
samplenow_beta(i,1:length(betaMrx))=betaMrx;

end

%define d- This will have to be non uniform distribution

d_min=1e-4;
d_max=1e-2;



for i=1:pop

dMrx=d_min+(d_max-d_min)*rand(N,1);
samplenow_d(i,1:length(dMrx))=dMrx;

end



best_alpha=zeros(ita,N);
worst_alpha=zeros(ita,N);

best_beta=zeros(ita,N);
worst_beta=zeros(ita,N);

best_d=zeros(ita,N);
worst_d=zeros(ita,N);

%%

for k=1:pop % do the first run
    alpha=samplenow_alpha(k,:); 
    beta=samplenow_beta(k,:);
    
    d=samplenow_d(k,:);
    
    AF(k,:)=ArrayFactor_NonPeriodic(N,alpha,beta,d);
  
   %scan AF;
   z=0;
   for i=1:length(ind_v)
       if AF(k,ind_v(i))<minSLL
           z=z+1;
       end          
   end
    num_pop_SLL(1,k)=z; %NoE that are below minSLL in the SLL region
end
%%
for m=1:ita
    
   [ sampleupdate_alpha,sampleupdate_beta,sampleupdate_d]=updatepopulation(N,samplenow_alpha,samplenow_beta,samplenow_d,num_pop_SLL(m,:));
   [ sampleupdate_alpha,sampleupdate_beta,sampleupdate_d]=trimr(alpha_min, alpha_max, beta_min, beta_max, d_min, d_max, sampleupdate_alpha, sampleupdate_beta, sampleupdate_d);
    
    
    for k=1:pop    
     AF=ArrayFactor_NonPeriodic(N, sampleupdate_alpha(k,:),sampleupdate_beta(k,:),sampleupdate_d(k,:));
   %scan AF;
   z=0;
   for i=1:length(ind_v)
       if AF(ind_v(i))<minSLL
           z=z+1;
       end          
   end
    num_pop_SLL(m+1,k)=z; %NoE that are below minSLL in the SLL region
        
        if num_pop_SLL(m+1,k)<num_pop_SLL(m,k)
           
           sampleupdate_alpha(k,:)=samplenow_alpha(k,:);
          sampleupdate_beta(k,:)=samplenow_beta(k,:);
          sampleupdate_d(k,:)=samplenow_d(k,:);
           num_pop_SLL(m+1,k)=num_pop_SLL(m,k) ;
   
        end    
    end
    samplenow_alpha=sampleupdate_alpha;
    samplenow_beta=sampleupdate_beta;
    samplenow_d=sampleupdate_d;
     
end
%%
sita=rad2deg(0:0.02:pi);
% plot
AF=ArrayFactor_NonPeriodic(N, sampleupdate_alpha(1,:),sampleupdate_beta(1,:),sampleupdate_d(1,:));
plot(sita,AF)

line([0 180],[minSLL minSLL],'Color','r','LineStyle','--')
grid;
xline(78)
xline(82)
xlabel('Theta [deg]')
ylabel('Normalized amplitude [dB]')

