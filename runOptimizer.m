%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% runOptimizer for AA290 Trajectory Optimization
% Author: Anjali Roychowdhury
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Set-Up
close all; clear all; clc;

verbose         = true;

%% Define Variable Conditions
vars = [3,      % thrust duration
    21525,      % thrust magnitude
    1];         % nozzle:diameter ratio
    

%% Run a Case
[maxHeight_km, finalVelocity_kmps] = runCase(verbose,vars);
