clear
% Jaya algorithm
N = 100;
D = 4;
lb = [0.0625 0.0625 10 10];
ub = [99*0.0625 99*0.0625 200 200];
itermax = 100;

% Random init in ub and lb
for i=1:N
    for j=1:D
        pos(i,j)=lb(j)+rand.*(ub(j)-lb(j));
    end
end

% Evaluate Obj function
fx = obj_test(pos);

for iter=1:itermax
    % find x best 
    [fmin, minind] = min(fx);
    x_best = pos(minind,:);
    % find x worst
    [fmax, maxind] = max(fx);
    x_worst = pos(maxind,:);
    for i=1:N
        x = pos(i,:);
        x_n = x+rand.*(x_best-abs(x))-rand.*(x_worst-abs(x));
        % check bounds
        x_n = max(x_n,lb);
        x_n = min(x_n,ub);
        fnew = obj_test(x_n);
        if fnew<fx(i)
            pos(i,:)=x_n;
            fx(i,:)=fnew;
        end
    end
    [optval,optind] = min(fx);
    best_fx(iter) = optval;
    best_x(iter,:) = pos(optind,:);
    disp(['Iteration ' num2str(iter) ...
        ': Best Cost = ' num2str(best_fx(iter))]);
    
    plot(best_fx, 'LineWidth',2);
    xlabel('Iteration Number');
    ylabel('Fitness Value')
    title('Convergence vs Iteration')
    grid on;   
end

 