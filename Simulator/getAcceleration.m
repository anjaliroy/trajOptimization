function [a_mps2, F_gravity_N, F_drag_N, F_thrust_N] ...
    = getAcceleration(mass, pos_i, vel_i, s, rho, Cd, P_atm, A_e, thrustVac_N)
% F = -GMm/r^2 = ?m/r^2 where ? = 3.986004418e14 for Earth
F_gravity_N     = 3.986004418e14*mass*pos_i/(norm(pos_i)^3);

F_drag_N        = getDrag(s, rho, vel_i, Cd);

F_thrust_N      = get_thrust(P_atm, A_e, thrustVac_N, vel_i);

a_mps2          = (F_gravity_N + F_drag_N + F_thrust_N)/mass;
end
