function plotSingleCase(time, solution, verbose)
if verbose
    figure(1)
    plot(time,solution(:,3)./1000)
    title('Altitude vs. Time')
    xlabel('Time (s)')
    ylabel('Altitude (km)')
    
    magVelocity = vecnorm(solution(:,4:6)');
    figure(2)
    plot(time,magVelocity./1000)
    title('Velocity vs. Time')
    xlabel('Time (s)')
    ylabel('Velocity (km/s)')
end
end