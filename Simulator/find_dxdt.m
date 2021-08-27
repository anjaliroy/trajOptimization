function [ xDot, F_drag_N, F_thrust_N, mass_kg, a_mps2] = find_dxdt( time, x , Vehicle)
timeTable       = [0,...
    Vehicle.thrustDuration_s,...
    Vehicle.thrustDuration_s+0.001,...
    100];
thrustTable     = [Vehicle.thrustMagnitude_N,
    Vehicle.thrustMagnitude_N,
    0,
    0];
massTable       = [Vehicle.totalMass_kg,
    Vehicle.totalMass_kg,
    Vehicle.dryMass_kg,
    Vehicle.dryMass_kg];

pos_i_m     = x(1:3)';
vel_i_mps   = x(4:6)';
altitude    = pos_i_m(3);
normVel     = norm(vel_i_mps);


[T_K, P_atm, rho, acousticSpeed] = getAtmoConditions(altitude);

machNumber = normVel/acousticSpeed;

mass_kg = interp1(timeTable, massTable, time, 'linear', 'extrap');
thrustVac_N = (interp1(timeTable,thrustTable,time,'linear','extrap'));

[a_mps2, F_gravity_N, F_drag_N, F_thrust_N] ...
    = getAcceleration(mass_kg, pos_i_m, vel_i_mps, Vehicle.s, rho, Vehicle.Cd, P_atm, Vehicle.A_e_m2, thrustVac_N);

xDot = [vel_i_mps'; a_mps2'];
end