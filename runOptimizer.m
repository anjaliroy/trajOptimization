%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% runOptimizer for AA290 Trajectory Optimization
% Author: Anjali Roychowdhury
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Set-Up
close all; clear all; clc;

verbose         = true;

%% Define Variable Conditions
x0              = [3            % thrust duration
                21525           % thrust magnitude
                1               % nozzle:diameter ratio
                45];            % launch azimuth

%% Define Constraints
A               = eye(4);
b               = [50           % max thrust duration (s)
                30000           % max thrust (N)
                1.5             % max nozzle:diameter ratio
                60];            % max launch azimuth

% %% Run a Case
% score           = runOptimizationCase(x0);

%% Run Optimizer
x               = fmincon(@runOptimizationCase,x0,A,b);
