function score = runOptimizationCase(vars)
%% Define Target Conditions
targetHeight_km     = 200;
r_km                = 6387+targetHeight_km;
mu                  = 3.986004418e14; % GM for earth
targetVFinalmps     = sqrt(mu/(r_km*1000));
targetFPA_deg       = 0;

% x_target            = [targetHeight_km, targetVFinalmps]; 
x_target            = [targetHeight_km, targetVFinalmps, targetFPA_deg]; 
%% Run Case
verbose             = false;
[maxHeight_km, finalVelocity_kmps, FPA_deg] = runCase(vars, verbose);

%% Evaluate Score
% x_achieved          = [maxHeight_km, finalVelocity_kmps];
x_achieved          = [maxHeight_km, finalVelocity_kmps, FPA_deg];

score               = norm(x_target-x_achieved);
end