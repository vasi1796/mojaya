function [] = obj_fun_visualise(z_1,z_2)
    figure;
    subplot(2,1,1);
    plot(z_1);
    xlabel('Iterations');
    ylabel('Function value');
    title('SLL indices');
    subplot(2,1,2);
    plot(z_2);
    xlabel('Iterations');
    ylabel('Function value');
    title('Main lobes maximized');
end