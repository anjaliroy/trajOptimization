function [maxHeight_km, finalVelocity_kmps] = evaluateMetrics(solution, verbose)
maxHeight_km        = max(solution(:,3))./1000;
finalVelocity_kmps  = vecnorm(solution(end,4:6)')./1000;

if verbose
    fprintf("\nMaximum Altitude (km): %.2f\n",maxHeight_km)
    fprintf("Final Velocity (km/s): %.2f\n",finalVelocity_kmps)
end
end