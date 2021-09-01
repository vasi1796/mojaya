%% Initialise paper variables
rng('default')
clear; 
clc;

% debug level
% 0 - final graphs
% 1 - obj functions graphs included
% 2 - step by step gradient animation
DEBUG_LEVEL=0;

% number of iterations
ita = 2000; 
% population number
pop = 10; 
theta =0:0.005:pi; 
c = 3e8;
f = 15e9;
lambda = c/f;
k0 = 2*pi/lambda;
% SLL threshold
minSLL=-6; 
% tolerance in deg
tolerance = 1;
% (-12,-8) in (0,180) are (78,82)
max_angle = 82+tolerance;
min_angle = 78-tolerance;
% (-22,-28) in (0,180) are (58,62)
max_angle2 = 62+tolerance;
min_angle2 = 58-tolerance;
% number of array elements
N = 50;
% weights for the weighted sum obj function
% need to amount to 1
% weight for SLL
w_1 = 0.9392;
% weight for max lobes
w_2 = 0.0608;


% convert degrees to rads to for angle ranges
theta1=deg2rad(min_angle); 
theta2=deg2rad(max_angle);
theta3=deg2rad(min_angle2); 
theta4=deg2rad(max_angle2);

% store vector indices for objective functions
k=1;
% indices for SLL min
ind_v = zeros(length(theta));
% indices for main lobe max
ind_w = zeros(length(theta));
for i=theta
    if i> theta2
      ind_v(k)=k;
    elseif i>theta4 && i<theta1
      ind_v(k)=k;
    elseif i<theta3
      ind_v(k)=k;
    elseif (i>theta1 && i<theta2) || (i>theta3 && i<theta4)
      ind_w(k)=k;
    end
    k=k+1;
end
ind_v=nonzeros(ind_v)';
ind_w=nonzeros(ind_w)';
goal=length(ind_v);
goal_2=length(ind_w);
global_goal = goal*w_1+goal_2*w_2;

% define phase shift
% use mixture model distribution 
alpha_min=-pi;
alpha_max=-pi/6;

for i=1:pop
    alphaMrx=mixture_sample(N);
    samplenow_alpha(i,1:length(alphaMrx))=alphaMrx;
end

% define d
% use non uniform distribution
d_min=1e-4;
d_max=0.6*lambda;

for i=1:pop
    dMrx=d_min+(d_max-d_min)*rand(N,1);
    samplenow_d(i,1:length(dMrx))=dMrx;
end

% define element excitation value
I_min=0.0;
I_max=1.0;

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

% Objective functions vectors
num_pop_SLL = zeros(ita+1,pop);
z_1_vec = zeros(ita+1,pop);
z_2_vec = zeros(ita+1,pop);

%% Start optimization

% initial run
for k=1:pop 

    AF = af_fun(N,samplenow_alpha(k,:),samplenow_d(k,:),samplenow_I(k,:),theta);
  
    % check data points for objective functions
    [num_pop_SLL(1,k),z_1_vec(1,k),z_2_vec(1,k)] = checkSLL(ind_v,minSLL,AF,ind_w, w_1,w_2);
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
        % calculate array factor levels
        AF = af_fun(N, sampleupdate_alpha(k,:),sampleupdate_d(k,:),sampleupdate_I(k,:),theta);
        
        % check objective function
        [num_pop_SLL(m+1,k),z_1_vec(m+1,k),z_2_vec(m+1,k)] = checkSLL(ind_v,minSLL,AF,ind_w,w_1,w_2);
        
        % elitism algorithm, should be replaced with non domination
        % algorithm
        if num_pop_SLL(m+1,k)<num_pop_SLL(m,k)
            sampleupdate_alpha(k,:) = samplenow_alpha(k,:);
            sampleupdate_d(k,:) = samplenow_d(k,:);
            sampleupdate_I(k,:) = samplenow_I(k,:);
            num_pop_SLL(m+1,k) = num_pop_SLL(m,k);
        end
        % Stop condition
        if(global_goal-num_pop_SLL(m+1,k)==0)
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
    
    % used to record individual obj function progress
    if DEBUG_LEVEL > 0
        z_1_at_it(m) = max(z_1_vec(m,:));
        z_2_at_it(m) = max(z_2_vec(m,:));
    end
    
    % used for step by step visualisation
    if DEBUG_LEVEL > 1
        visualise(theta,N,sampleupdate_alpha,sampleupdate_d,sampleupdate_I,min_angle,max_angle,minSLL, 0, m, goal, SLL_at_it,goal_ind)
    end
    
end
%% Plot radiation pattern of optimal solution

visualise(theta,N,sampleupdate_alpha,sampleupdate_d,sampleupdate_I,min_angle,max_angle,minSLL, 1, ita, global_goal, SLL_at_it, goal_ind)
if DEBUG_LEVEL > 0
    obj_fun_visualise(z_1_at_it,z_2_at_it)
end