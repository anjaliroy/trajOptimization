function [maxHeight_km, finalVelocity_kmps, FPA_deg] = evaluateMetrics(solution, verbose)
maxHeight_km        = max(solution(:,3))./1000;
finalVelocity_kmps  = vecnorm(solution(end,4:6)')./1000;

magXY = (((solution(end,4)^2)+(solution(end,5)^2))^.5);
FPA_deg = atand(solution(end,6)/magXY);

if verbose
    fprintf("\nMaximum Altitude (km): %.2f\n",maxHeight_km)
    fprintf("Final Velocity (km/s): %.2f\n",finalVelocity_kmps)
    fprintf("Final FPA (deg): %.2f",FPA_deg)
end
end