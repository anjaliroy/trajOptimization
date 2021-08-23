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
    
    figure(3)
    magXY = (((solution(:,4).^2)+(solution(:,5).^2)).^.5);
    FPA_deg = atand(solution(:,6)./magXY);
    figure(3)
    plot(time, FPA_deg)
    title('Flight Path Angle vs. Time')
    xlabel('Time (s)')
    ylabel('Flight Path Angle (deg)')
end
end