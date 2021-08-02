% pd = makedist('Binomial','N',20,'p',0.1);
% pd = makedist('Uniform','lower',1,'upper',8);
% pd = makedist('InverseGaussian','mu',1/8,'lambda',1/8);
% pd = makedist('Normal','mu',1,'sigma',7);
% x = random(pd,1000,1);
% %x=0:200;
% pdf_n = pdf(pd,x);
% subplot(2,1,1)
% plot(x);
% subplot(2,1,2)
% histfit(x)

% The number of random samples to generate
N = 10000;
% First, generate a binomial variable, which 40% of the time (on average) will be equal to 1,
% and 60% of the time (on average) will be equal to zero.
frac = rand(N,1) < 0.5;
% Generate the two normal distributions to sample from
norm1 = pi/2 + 0.5*randn(N,1);
norm2 = -pi/2 + 0.5*randn(N,1);
% If "frac" is equal to 1, then the choice will be from the first normal.
% If "frac" is equal to 0, then the choice will be from the second normal.
d = frac.*norm1 + (1-frac).*norm2;
% Plot the resulting distribution
figure
subplot(2,1,1)
histogram(d)
subplot(2,1,2)
plot(d)