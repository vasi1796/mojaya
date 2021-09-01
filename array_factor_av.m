clear all;
%load('./project_scripts/conv_alpha_d.mat')

% imaginary 
j=sqrt(-1);
% frequency of project
freq=15e9;
% speed of light
c=3e8;
% wavelength
lambda=c/freq;
k=2*pi/lambda;
% number of elements
N=30;
% phase shift of the elements in degrees
alpha=-70;
% distancing limit from project spec
d_limit = 0.6*lambda;
% x axis spec
theta=0:0.02:pi;

% simulation for different spacings
for i=0:0.001:d_limit/2
    % uniform element spacing experiment
    % d = i;
    % reinitialise AF on each run
    AF_init = zeros(30,length(theta));
    for m=1:N
        % individual spaced elements experiment
        % I = (1.0-0).*rand(1,1) + 0;
        % from UOT lecture
        AF_init(m,:) = 1*exp(j*k*(m-1)*d*cos(theta)+j*(m-1)*alpha*pi/180);
    end
    AF_sum = sum(AF_init(1:N,:));
    AF_abs = abs(AF_sum);
    AF = 20*log10(AF_abs/max(AF_abs));
    
    % Visualisation
    tiledlayout(2,1); 
    nexttile
    % planar radiation pattern
    plot(theta,AF);
    hold on;
    % constant line for SLL threshold
    % yline(-10,'r');
    hold off;
    title(sprintf('Log plot with spacing of %s', d));
    xlabel('Angle [rad]');
    ylabel('AF [dB]');
    grid;
    legend('Radiation pattern');
    
    nexttile
    % polar radiation pattern 
    polarplot(theta,AF_abs);
    title(sprintf('Polar plot with spacing of %s', d));
    
    % used to create animation effect
    pause(0.1);
end
