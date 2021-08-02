function [d] = mixture_sample(N)
% First, generate a binomial variable, which 40% of the time (on average) will be equal to 1,
% and 60% of the time (on average) will be equal to zero.
frac = rand(N,1) < 0.5;
% Generate the two normal distributions to sample from
norm1 = pi/2 + 0.5*randn(N,1);
norm2 = -pi/2 + 0.5*randn(N,1);
% If "frac" is equal to 1, then the choice will be from the first normal.
% If "frac" is equal to 0, then the choice will be from the second normal.
d = frac.*norm1 + (1-frac).*norm2;