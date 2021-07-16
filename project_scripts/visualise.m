function [] = visualise(theta,N,sampleupdate_alpha,sampleupdate_d,min_angle,max_angle,tolerance,minSLL, final, it, goal, worst_SLL_it)
    theta_deg = rad2deg(theta);
    AF = af_fun(N, sampleupdate_alpha(1,:),sampleupdate_d(1,:),theta);
    subplot(2,1,1);
    plot(theta_deg,AF)
    
    xline(min_angle-tolerance,'g');
    xline(max_angle+tolerance,'b');
    yline(minSLL,'-r');
    legend('Radiation pattern','Lower angle limit','Higher angle limit','SLL limit');
    grid;
    xlabel('Theta [deg]')
    ylabel('Normalized amplitude [dB]')
    
    if final
        title('Log plot at final iteration');
    else
        title(sprintf('Log plot at iteration spacing of %f', it));
        pause(0.00001)
    end
    
    subplot(2,1,2);
    error = goal - worst_SLL_it;
    plot(error);
    grid;
    title('Error plot');
    xlabel('Iteration number');
    ylabel('Error [indices under the SLL threshold]');
    
end