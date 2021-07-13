clear all;

% element numbers
N = 30;

% element spacing
d = 0.12;

% theta zero direction
% 90 degree for braodside, 0 degree for endfire.
theta_zero = 0;

An = 1;
j = sqrt(-1);
AF = zeros(1,360);

for theta=1:360
    
    % change degree to radian
    deg2rad(theta) = (theta*pi)/180;
    
    %array factor calculation
    for n=0:N-1
        AF(theta) = AF(theta) + An*exp(j*n*2*pi*d*(cos(deg2rad(theta))-cos(theta_zero*pi/180))) ;
    end
    AF(theta) = abs(AF(theta));
    
end

% plot the array factor
polar(deg2rad,AF);
