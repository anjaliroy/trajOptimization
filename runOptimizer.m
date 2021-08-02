%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% runOptimizer for AA290 Trajectory Optimization
% Author: Anjali Roychowdhury
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Set-Up
close all; clear all; clc;

%% Define Simulation Conditions
dt = 0.01;

%% Define Initial Conditions
pos(1)      = 0;
pos(2)      = 0;
pos(3)      = 0;

azl         = 0;
alpha       = 0;
theta       = 90 - alpha;
phi         = 90 - azl;

v_mag       = 0.001;
vel(1)      = v_mag*sind(theta)*cosd(phi);
vel(2)      = v_mag*sind(theta)*sind(phi);
vel(3)      = v_mag*cosd(theta);


