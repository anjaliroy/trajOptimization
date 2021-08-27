function [maxHeight_km, finalVelocity_kmps, FPA_deg] = runCase(vars, verbose)
%% Define Simulation Conditions
maxTime_s       = 500;                              % maximum sim time
dt              = 1;
time            = 0:dt:maxTime_s;                              


%% Define Initial Conditions
pos_i_m(1)      = 10;                                % position at t-0
pos_i_m(2)      = 20;
pos_i_m(3)      = 2;

azl             = vars(4);
alpha           = vars(5);                          % angle of attack
theta           = 90 - alpha;
phi             = 90 - azl;

v_mag           = 0.001;                            % velocity at t-0
vel_i_mps(1)    = v_mag*sind(theta)*cosd(phi);
vel_i_mps(2)    = v_mag*sind(theta)*sind(phi);
vel_i_mps(3)    = v_mag*cosd(theta);

x0              = [pos_i_m, vel_i_mps]';             % initial state


%% Vehicle Parameterss
Vehicle.Cd                  = 0.5;
Vehicle.gravity_mps2        = 9.8067; %gravity
Vehicle.rocketDiameter_m    = 1.82;
Vehicle.thrustDuration_s    = vars(1);
Vehicle.thrustMagnitude_N   = vars(2)*1000;
Vehicle.totalMass_kg        = 15665.6;
massFraction                = 0.8460;
Vehicle.dryMass_kg          = (1 - massFraction)*Vehicle.totalMass_kg;
nozzleDiameterRatio         = vars(3);
Vehicle.A_e_m2              = nozzleDiameterRatio*Vehicle.rocketDiameter_m;
Vehicle.s                   = ((Vehicle.rocketDiameter_m/2)^2)*pi;


%% Run Simulator
[t, solution]   = ode45(@(t,x) find_dxdt(t,x,Vehicle), time, x0);

%% Plot
plotSingleCase(time, solution, verbose);

%% Metrics
[maxHeight_km, finalVelocity_kmps, FPA_deg] = evaluateMetrics(solution, verbose);

end