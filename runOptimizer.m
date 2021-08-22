%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% runOptimizer for AA290 Trajectory Optimization
% Author: Anjali Roychowdhury
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Set-Up
close all; clear all; clc;

verbose         = true;

%% Run a Case
[maxHeight_km, finalVelocity_kmps] = runCase(verbose);
