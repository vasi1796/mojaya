function out = obj_test(X)
x1 = X(:,1);
x2 = X(:,2);
x3 = X(:,3);
x4 = X(:,4);
% minimize
fx = 0.6224.*x1.*x3.*x4 + ...
    1.7781.*x2.*x3.^2+ ...
    3.1661.*x1.^2.*x4 + ...
    19.84.*x1.^2.*x3;
% subject to
g(:,1) = -x1+0.0193.*x3;
g(:,2) = -x2+0.00954.*x3;
g(:,3) = -pi.*x3.^2.*x4 ...
    -(4/3).*pi.*x3.^3 ...
    + 1296000;
g(:,4) = x4-240;
% penalty term
pp = 10^9;
for i=1:size(g,1)
    for j=1:size(g,2)
    if g(i,j)>0
        penalty(i,j) = pp.*g(i,j);
    else
        penalty(i,j) = 0;
    end 
    end
end
out = fx + sum(penalty,2);
end