%% Jaya algorithm 
%% Constrained optimization 
%% Himmelblau 
clc; clear all; 
RUNS=1; 
runs=0; 
while(runs<RUNS) 
   pop=5; % population size 
   var=2; % no. of design variables 
   maxFes=150000; 
   maxGen=2; 
   mini=[-10 -10]; 
   maxi=[35 35]; 
   [row,var]=size(mini) 
   x=zeros(pop,var); 
   for i=1:var 
       x(:,i)=mini(i)+(maxi(i)-mini(i))*rand(pop,1);  %initial population
   end
   ch=1; gen=0; 
   f=myobj(x); %calculate objective function
   while(gen<maxGen) 
       xnew=updatepopulation(x,f); 
       xnew=trimr(mini,maxi,xnew); 
       fnew=myobj(xnew); 
       for i=1:pop 
           if (fnew(i)<f(i)) 
               x(i,:)=xnew(i,:); 
               f(i)=fnew(i); 
           end
       end
           disp('%%%%%% Final population%%%%%%%'); 
           disp([x,f]); 
           fnew=[]
           xnew=[]
           gen=gen+1; 
           fopt(gen)=min(f); 
   end
   runs=runs+1; 
   [val,ind]=min(fopt); 
   Fes(runs)=pop*ind; 
   best(runs)=val; 
end
bbest=min(best); 
mbest=mean(best); 
wbest=max(best); 
stdbest=std(best); 
mFes=mean(Fes); 
fprintf('\n best=%f',bbest); 
fprintf('\n mean=%f',mbest); 
fprintf('\n worst=%f',wbest); 
fprintf('\n std. dev.=%f',stdbest); 
fprintf('\n mean Fes=%f',mFes); 


function[z]=trimr(mini,maxi,x) 
[row,col]=size(x); 
for i=1:col x(x(:,i)<mini(i),i)=mini(i); 
    x(x(:,i)>maxi(i),i)=maxi(i); 
end
z=x; 
end

function [xnew]=updatepopulation(x,f) 
[row,col]=size(x); 
[t,tindex]=min(f); 
Best=x(tindex,:); 
[w,windex]=max(f); 
worst=x(windex,:); 
xnew=zeros(row,col); 
for i=1:row 
    for j=1:col
        r=rand(1,2); 
        xnew(i,j)=x(i,j)+r(1)*(Best(j)-abs(x(i,j)))-r(2)*(worst(j)-abs(x(i,j)));  %Jaya
    end
end
end

function [f]=myobj(x) %My Array factor
[r,c]=size(x); 
Z=zeros(r,1); 
for i=1:r 
    x1=x(i,1); 
    x2=x(i,2); 
    z=(((x1^2)+x2-11)^2)+((x1+x2^2-7)^2); %Himmelblau function
    g1=26-((x1-5)^2)-((x2)^2); 
    g2=20-(4*x1)-x2; 
    p1=10*((min(0,g1))^2); % penalty if constraint 1 is violated 
    p2=10*((min(0,g2))^2); % penalty if constraint 2 is violated 
    Z(i)=z+p1+p2; % penalized objective function value 
end
f=Z; 
end