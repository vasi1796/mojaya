clear
clc
%Balanis Chapter 6 formulas 3rd edition
%Array factor of planar arrays
j=sqrt(-1);
M=361; %Angle resolution
k=2*pi; %wavenumber
theta=linspace(0,pi,M);
phi=linspace(-pi/2,pi/2,M);
[THETA,PHI]=meshgrid(theta,phi);
dtheta=pi/M;
dphi=pi/M;
%Planar Array variables
My=8; 
Nz=8;
dy=0.5; %Interelement spacing in y
dz=0.5; %Interelement spacing in z
deltay=0; %Steering angle in phi
deltaz=0; %Steering angle in theta
%Array factor
psiy=(-k*dy*sin(THETA).*sin(PHI))+deltay;
psiz=(-k*dz*cos(THETA))+ deltaz;
AFy=0;
AFz=0;
for m=1:My
    AFy= AFy+ exp(j*(m-1)*psiy);
end
for n=1:Nz
    AFz=AFz+ exp(j*(n-1)*psiz);
end
AF=AFy.*AFz;
AFmag=abs(AF);
%Directivity
Utheta=AFmag.^2;
Prad=sum(sum(Utheta.*sin(THETA)*dtheta*dphi));
D=4*pi*Utheta/Prad;
dBd=20.*log10(D);
%Directivity Plot
% figure;
surf(PHI,THETA,dBd);
shading interp;
colormap('default');
xlabel('\phi[deg]','Fontsize',6);
set(gca,'XTick',-pi/2:pi/6:pi/2);
set(gca,'XTickLabel',{'-90','-60','-30','0','30','60','90'},'Fontsize',10,'fontweight','bold','box','on');
ylabel('\Theta[deg]','Fontsize',6);
set(gca,'YTick',0:pi/6:pi);
set(gca,'YTickLabel',{'-90','-60','-30','0','30','60','90'},'Fontsize',10,'fontweight','bold','box','on');
zlabel('Directivity',"FontSize",10)