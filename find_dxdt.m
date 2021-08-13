function [ xDot, drag, thrust, mass, acceleration] = find_dxdt( time, x )
Cd                  = 0.5;
gravity_mps2        = 9.8067; %gravity
rocketDiameter_m    = 0.122;
thrustDuration_s    = 160;
thrustMagnitude_N   = 121525;
burnoutMass         = 45.2;
mass                = 65.6;


timeTable       = [0     1.8   1.8001 3];
thrustTable     = [21525 21525 0      0];
massTable       = [65.6  45.2  45.2   45.2];
launchClearSpeed = sqrt(2*(thrustMagnitude_N/launchMass_kg)*rocketLength);

position    = x(1:3)';
velocity    = x(4:6)';
altitude    = position(3);
normVel     = norm(velocity);
s           = ((rocketDiameter_m/2)^2)*pi;

[temperature, pressure, density, acousticSpeed] = getAtmoConditions(altitude);

machNumber = normVel/acousticSpeed;

drag = getDrag(s, density, velocity, Cd, normVel);

mass = interp1(timeTable, massTable, time, 'linear', 'extrap');

thrust = (velocity/norm(velocity))*interp1(timeTable,thrustTable,time,'linear','extrap');

acceleration = getAcceleration(thrust, drag, gravity, mass, launchClearSpeed, normVel);

xDot = [velocity'; acceleration'];

end