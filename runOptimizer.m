%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% runOptimizer for AA290 Trajectory Optimization
% Author: Anjali Roychowdhury
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Set-Up
close all; clear all; clc;


%% Define Simulation Conditions
maxTime_s       = 100;                              % maximum sim time
dt              = 0.1;
time            = 0:dt:maxTime_s;                              


%% Define Initial Conditions
pos_i_m(1)      = 10;                                % position at t-0
pos_i_m(2)      = 20;
pos_i_m(3)      = 2;

azl             = 45;
alpha           = 0;                                % angle of attack
theta           = 90 - alpha;
phi             = 90 - azl;

v_mag           = 0.001;                            % velocity at t-0
vel_i_mps(1)    = v_mag*sind(theta)*cosd(phi);
vel_i_mps(2)    = v_mag*sind(theta)*sind(phi);
vel_i_mps(3)    = v_mag*cosd(theta);

x0              = [pos_i_m, vel_i_mps]';             % initial state


%% Run Simulator
[t, solution]   = ode45(@find_dxdt, time, x0);

%% Plot
figure(1)
plot(time,solution(:,3))
title('Altitude vs. Height')
xlabel('Time (s)')
ylabel('Altitude (m)')

% figure(2)
% plot(timeData,zdata)
% title('Z vs Time')
% xlabel('Time')
% ylabel('Z')