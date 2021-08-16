%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% runOptimizer for AA290 Trajectory Optimization
% Author: Anjali Roychowdhury
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Set-Up
close all; clear all; clc;


%% Define Simulation Conditions
maxTime_s       = 100;                              % maximum sim time
dt              = 0.1;
% time            = 0:dt:maxTime_s;
time            = 0;


%% Define Initial Conditions
pos_i_m(1)      = 0;                                % position at t-0
pos_i_m(2)      = 0;
pos_i_m(3)      = 210;

azl             = 45;
alpha           = 0;                                % angle of attack
theta           = 90 - alpha;
phi             = 90 - azl;

v_mag           = 0.001;                            % velocity at t-0
vel_i_mps(1)    = v_mag*sind(theta)*cosd(phi);
vel_i_mps(2)    = v_mag*sind(theta)*sind(phi);
vel_i_mps(3)    = v_mag*cosd(theta);

x0              = [pos_i_m, vel_i_mps]';            % initial state

outputs         = zeros(10,1);                      % initial outputs of dxdt

%% Run Simulator
while time <= maxTime
    x0              = [pos_i_m, vel_i_mps]';
    [t, solution]   = ode45(@find_dxdt, [time, time+dt], x0);
    [xDot, drag, thrust, mass, acceleration] = find_dxdt(time+dt, initialState);
    x               = solution(end,:);
    
    pos_i_m         = x(1:3);
    vel_i_mps       = x(4:6);
    time            = time + dt;
    
    range           = norm(pos_i_m);
    magXY           = (((vel_i_mps(1)^2)+(vel_i_mps(2)^2))^.5);
    fpa_deg         = atand(vel_i_mps(3)/magXY);
    
    newOutputs      = [time, pos_i_m, vel_i_mps,...
        drag, thrust, mass, acceleration, fpa_deg];
    
    outputs         = cat(1,outputs, newOutputs);
end

%% Plot
figure(1)
plot(solution(:,3),time)
title('Altitude vs. Height ODE45')
xlabel('Time (s)')
ylabel('Altitude (m)')

% figure(2)
% plot(timeData,zdata)
% title('Z vs Time')
% xlabel('Time')
% ylabel('Z')