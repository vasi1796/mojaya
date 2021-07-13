function [AF]=af_fun(N, alpha, d, theta)

% imaginary 
j=sqrt(-1);
% frequency of project
freq=15e9;
% speed of light
c=3e8;
% wavelength
lambda=c/freq;
k=2*pi/lambda;

AF_init=zeros(N,length(theta));
for m=1:N
    % from UOT lecture
    % calculate each array element factor
    AF_init(m,:) = 0.5*exp(j*k*(m-1)*d(m)*cos(theta)+j*(m-1)*d(m)*alpha(m));
end

% calculate array factor
AF_sum = sum(AF_init(1:N,:));
AF_abs = abs(AF_sum);
% lobe level in db, function to be minimised w.r.t. specs
AF = 20*log10(AF_abs/max(AF_abs));


end