clear
% PSO implementation
N = 500;
D = 4;
lb = [0.0625 0.0625 10 10];
ub = [99*0.0625 99* 0.0625 200 200];
itermax = 100;
num_runs = 1;
% PSO specific params
wmax = 0.9;
wmin = 0.4;
c1 = 2.05;
c2 = 2.05;

% start PSO
for run=1:num_runs
    % Init of position and velocity
    for i=1:N
        for j=1:D
            pos(i,j)=lb(j)+rand.*(ub(j)-lb(j));
        end
    end
    vel=0.1.*pos;

    % Init best values
    out=obj_test(pos);
    pbestval = out;
    pbest = pos;
    [fminval, index] = min(out);
    gbest=pbest(index,:);

    iter= 1;
    while iter<=itermax
        w=wmax-(iter/itermax).*(wmax-wmin);
        % Calculate PBEST and GBEST
        x=pos;
        out=obj_test(pos);
        % Update PBEST
        har= find(out<=pbestval);
        pbest(har,:)=x(har,:);
        pbestval(har)=out(har);

        % Update GBEST
        [fbestval, ind1]=min(pbestval);
        if fbestval<=fminval
            fminvalue=fbestval;
            gbest=pbest(ind1,:);
        end
        
        % Update velocity and position
        for i=1:N
            vel(i,:)=w.*vel(i,:)+ ...
            c1.*rand.*(pbest(i,:)-pos(i,:)) + ...
            c2.*rand.*(gbest-pos(i,:));
            pos(i,:) = vel(i,:) + pos(i,:);
            % Handle bounds
            pos(i,:) = max(pos(i,:),lb);
            pos(i,:) = min(pos(i,:),ub);
        end
        f_ans(iter) = obj_test(gbest);
        f_gbest(iter,:) = gbest;
        disp(['Iteration ' num2str(iter) ...
        ': Best Cost = ' num2str(f_ans(iter))]);
        iter = iter+1;
    end
end

[best_fun, best_run] = min(f_ans);
best_x = f_gbest(best_run,:);
plot(f_ans,'LineWidth', 2)
xlabel('Iteration')
ylabel('Fitness function value');
title('PSO convergence');
