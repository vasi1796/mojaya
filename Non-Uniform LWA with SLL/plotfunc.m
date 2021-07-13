N=[1:30];
c=3e8;
f=15e9;
k0=2*pi*f/c;
figure;
scatter(N,sampleupdate_beta(1,:)./k0)
set(gca,'yscale','log')
ylabel ('\beta/k_{0}')
xlabel('Number of elements')
grid;
%%
figure;
scatter(N,sampleupdate_alpha(1,:)./k0)
set(gca,'yscale','log')
ylabel ('\alpha/k_{0}')
xlabel('Number of elements')
grid;
%%
lamda=c/f;

figure;
scatter(N,sampleupdate_d(1,:)./lamda)
ylabel ('d_{i}/\lambda_{0}')
xlabel('Number of elements')
grid;
