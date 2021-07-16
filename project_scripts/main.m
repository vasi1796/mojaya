%% Initialise paper variables

clear; 
clc;

% number of iterations
ita = 5000; 
% population number
pop = 10; 
theta =0:0.02:pi; 
c = 3e8;
f = 15e9;
lambda = c/f;
k0 = 2*pi/lambda;
% SLL threshold
minSLL=-10; 
% (-12,-8) in (0,180) are (78,82)
max_angle = 82;
min_angle = 78;
% tolerance in deg
tolerance = 5;
% number of array elements
N = 30;

theta1=deg2rad(min_angle)-deg2rad(tolerance); 
theta2=deg2rad(max_angle)+deg2rad(tolerance);

% store vector indices for SLL verification
k=1;
ind_v = zeros(length(theta));
for i=theta
    if i> theta2
      ind_v(k)=k;
    elseif i<theta1
      ind_v(k)=k;
    end
    k=k+1;
end
ind_v=nonzeros(ind_v)';
goal=length(ind_v);

% define phase shift
alpha_min=-1.3*k0;
alpha_max=1.3*k0;

for i=1:pop
    alphaMrx=alpha_min+(alpha_max-alpha_min)*rand(N,1);
    samplenow_alpha(i,1:length(alphaMrx))=alphaMrx;
end

% define d- This will have to be non uniform distribution
d_min=1e-4;
d_max=0.6*lambda;

for i=1:pop
    dMrx=d_min+(d_max-d_min)*rand(N,1);
    samplenow_d(i,1:length(dMrx))=dMrx;
end

% define beta mag shift weight
% NOT USED IN AF FUNC
beta_min=0.1;
beta_max=1.5*k0;

for i=1:pop

betaMrx=beta_min+(beta_max-beta_min)*rand(N,1);
samplenow_beta(i,1:length(betaMrx))=betaMrx;

end

best_alpha=zeros(ita,N);
worst_alpha=zeros(ita,N);

best_d=zeros(ita,N);
worst_d=zeros(ita,N);

best_beta=zeros(ita,N);
worst_beta=zeros(ita,N);

worst_SLL_it=zeros(ita,1);

%% Start optimization

% initial run
for k=1:pop 

    AF = af_fun(N,samplenow_alpha(k,:),samplenow_d(k,:),samplenow_beta(k,:),theta);
  
    % check how many data points are under db threshold
    z = checkSLL(ind_v,minSLL,AF);
    num_pop_SLL(1,k) = z; 
end

% main algorithm run
for m=1:ita
    
    % mojaya update process 
    [ sampleupdate_alpha,sampleupdate_d, sampleupdate_beta] = updatepopulation(N,samplenow_alpha,samplenow_d,samplenow_beta,num_pop_SLL(m,:),pop);
    % clamp bounds of variables
    [ sampleupdate_alpha,sampleupdate_d, sampleupdate_beta] = trimr(alpha_min, alpha_max, d_min, d_max,beta_min,beta_max, sampleupdate_alpha, sampleupdate_d, sampleupdate_beta);

    for k=1:pop    
    AF = af_fun(N, sampleupdate_alpha(k,:),sampleupdate_d(k,:),sampleupdate_beta(k,:),theta);
    % check how many data points are under db threshold
    num_pop_SLL(m+1,k) = checkSLL(ind_v,minSLL,AF);
        if num_pop_SLL(m+1,k)<num_pop_SLL(m,k)
            sampleupdate_alpha(k,:) = samplenow_alpha(k,:);
            sampleupdate_d(k,:) = samplenow_d(k,:);
            sampleupdate_beta(k,:) = samplenow_beta(k,:);
            num_pop_SLL(m+1,k) = num_pop_SLL(m,k);
        end    
    end
    samplenow_alpha = sampleupdate_alpha;
    samplenow_d = sampleupdate_d; 
    samplenow_beta = sampleupdate_beta;
    worst_SLL_it(m) = max(num_pop_SLL(m,:));
    
    %visualise(theta,N,sampleupdate_alpha,sampleupdate_d,sampleupdate_beta,min_angle,max_angle,tolerance,minSLL, 0, m, goal, worst_SLL_it)
end

%% Plot radiation pattern of optimal solution

visualise(theta,N,sampleupdate_alpha,sampleupdate_d,sampleupdate_beta,min_angle,max_angle,tolerance,minSLL, 1, ita, goal, worst_SLL_it)

