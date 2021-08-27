function [T_K, P_atm_Pa, rho_kgpm3, a] = getAtmoConditions(altitude)
[T_K, a, P_atm_Pa, rho_kgpm3] = atmosisa(altitude);
end