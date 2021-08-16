function F_thrust_N = get_thrust(P_atm, A_e, thrustVac_N, velocity)
magThrust = thrustVac_N - P_atm*A_e;
F_thrust_N = magThrust*(velocity/norm(velocity));
end