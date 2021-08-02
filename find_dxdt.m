function [xdot] = find_dxdt(x)
Cd          = 0.5;


position    = x(1:3)';
velocity    = x(4:6)';
altitude    = position(3);
normVel     = norm(velocity);
s           = ((rocketDiameter/2)^2)*pi;

[temperature, pressure, density, acousticSpeed] = getConditions(altitude);

machNumber = normVel/acousticSpeed;


end