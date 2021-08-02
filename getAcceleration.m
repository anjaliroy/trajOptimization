function [ newAcceleration] = getAcceleration(thrust, drag, gravity, mass, launchClearSpeed, normVelocity)
a = (thrust + drag)./mass;

if launchClearSpeed > normVelocity
    a_z = (thrust(1,3)+(drag(1,3)))/(mass);
else
    a_z = ((thrust(1,3)+(drag(1,3)))- mass*gravity)/(mass);
end
newAcceleration = [a(1), a(2), a_z];

end
