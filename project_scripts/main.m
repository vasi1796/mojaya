%% Initialise paper variables
rng('default')
clear; 
clc;

% number of iterations
ita = 1000; 
% population number
pop = 10; 
theta =0:0.005:pi; 
c = 3e8;
f = 15e9;
lambda = c/f;
k0 = 2*pi/lambda;
% SLL threshold
minSLL=-10; 
% tolerance in deg
tolerance = 1;
% (-12,-8) in (0,180) are (78,82)
max_angle = 82+tolerance;
min_angle = 78-tolerance;
% number of array elements
N = 30;

theta1=deg2rad(min_angle); 
theta2=deg2rad(max_angle);

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

% define phase shift, 
% use mixture model distribution 
alpha_min=-pi;
alpha_max=-pi/6;

for i=1:pop
    alphaMrx=mixture_sample(N);
    samplenow_alpha(i,1:length(alphaMrx))=alphaMrx;
end

% define d- This will have to be non uniform distribution
d_min=1e-4;
d_max=0.6*lambda;

for i=1:pop
    dMrx=d_min+(d_max-d_min)*rand(N,1);
    samplenow_d(i,1:length(dMrx))=dMrx;
end

% define excitation value
I_min=0;
I_max=1;

for i=1:pop

IMrx=I_min+(I_max-I_min)*rand(N,1);
samplenow_I(i,1:length(IMrx))=IMrx;

end

best_alpha=zeros(ita,N);
worst_alpha=zeros(ita,N);

best_d=zeros(ita,N);
worst_d=zeros(ita,N);

best_I=zeros(ita,N);
worst_I=zeros(ita,N);

% worst_SLL_it=zeros(ita,1);
num_pop_SLL = zeros(ita+1,pop);

%% Start optimization

% initial run
for k=1:pop 

    AF = af_fun(N,samplenow_alpha(k,:),samplenow_d(k,:),samplenow_I(k,:),theta);
  
    % check how many data points are under db threshold
    z = checkSLL(ind_v,minSLL,AF);
    num_pop_SLL(1,k) = z; 
end

% Stop flag init
stop = 0;
% Index of individual from population that finds the solution
goal_ind=1;

% Main algorithm run
for m=1:ita
    
    % mojaya update process 
    [ sampleupdate_alpha,sampleupdate_d, sampleupdate_I] = updatepopulation(N,samplenow_alpha,samplenow_d,samplenow_I,num_pop_SLL(m,:),pop);
    % clamp bounds of variables
    [ sampleupdate_alpha,sampleupdate_d, sampleupdate_I] = trimr(alpha_min, alpha_max, d_min, d_max,I_min,I_max, sampleupdate_alpha, sampleupdate_d, sampleupdate_I);

    for k=1:pop    
        AF = af_fun(N, sampleupdate_alpha(k,:),sampleupdate_d(k,:),sampleupdate_I(k,:),theta);
        % check how many data points are under db threshold
        num_pop_SLL(m+1,k) = checkSLL(ind_v,minSLL,AF);
        % elitism algorithm
        if num_pop_SLL(m+1,k)<num_pop_SLL(m,k)
            sampleupdate_alpha(k,:) = samplenow_alpha(k,:);
            sampleupdate_d(k,:) = samplenow_d(k,:);
            sampleupdate_I(k,:) = samplenow_I(k,:);
            num_pop_SLL(m+1,k) = num_pop_SLL(m,k);
        end
        % Stop condition
        if(goal-num_pop_SLL(m+1,k)==0)
            stop = 1;
            goal_ind = k;
        end
    end
    if stop
        break
    end
    samplenow_alpha = sampleupdate_alpha;
    samplenow_d = sampleupdate_d; 
    samplenow_beta = sampleupdate_I;
    SLL_at_it(m) = max(num_pop_SLL(m,:));
    
    % used for step by step visualisation
    % visualise(theta,N,sampleupdate_alpha,sampleupdate_d,sampleupdate_I,min_angle,max_angle,minSLL, 0, m, goal, SLL_at_it,goal_ind)
end

%% Plot radiation pattern of optimal solution

visualise(theta,N,sampleupdate_alpha,sampleupdate_d,sampleupdate_I,min_angle,max_angle,minSLL, 1, ita, goal, SLL_at_it, goal_ind)

