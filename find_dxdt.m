function [ xDot, F_drag_N, F_thrust_N, mass_kg, a_mps2] = find_dxdt( time, x )
Cd                  = 0.5;
gravity_mps2        = 9.8067; %gravity
rocketDiameter_m    = 0.122;
thrustDuration_s    = 3;
thrustMagnitude_N   = 21525;
dryMass_kg          = 845.2;
totalMass_kg        = 15665.6;
A_e_m2              = rocketDiameter_m;


timeTable       = [0     thrustDuration_s  thrustDuration_s+0.001 100];
thrustTable     = [thrustMagnitude_N thrustMagnitude_N 0      0];
massTable       = [totalMass_kg totalMass_kg  dryMass_kg   dryMass_kg];

pos_i    = x(1:3)';
vel_i    = x(4:6)';
altitude    = pos_i(3);
normVel     = norm(vel_i);
s           = ((rocketDiameter_m/2)^2)*pi;

[T_K, P_atm, rho, acousticSpeed] = getAtmoConditions(altitude);

machNumber = normVel/acousticSpeed;

mass_kg = interp1(timeTable, massTable, time, 'linear', 'extrap');
thrustVac_N = (interp1(timeTable,thrustTable,time,'linear','extrap'));

[a_mps2, F_gravity_N, F_drag_N, F_thrust_N] ...
    = getAcceleration(mass_kg, pos_i, vel_i, s, rho, Cd, P_atm, A_e_m2, thrustVac_N);

xDot = [vel_i'; a_mps2'];
end