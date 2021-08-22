function [maxHeight_km, finalVelocity_kmps] = evaluateMetrics(solution, verbose)
maxHeight_km        = max(solution(:,3))./1000;
finalVelocity_kmps  = vecnorm(solution(end,4:6)');

if verbose
    fprintf("\nMaximum Altitude (km): %.2f",maxHeight_km)
    fprintf("\nFinal Velocity (km/s): %.2f",finalVelocity_kmps)
end
end