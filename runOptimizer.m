%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% runOptimizer for AA290 Trajectory Optimization
% Author: Anjali Roychowdhury
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Set-Up
close all; clear all; clc;

verbose         = true;

%% Define Variable Conditions
x0              = [40           % thrust duration
                12          % thrust magnitude
                1               % nozzle:diameter ratio
                45               % launch azimuth
                15];            % angle of attack
            
nVars           = length(x0);

%% Define Constraints
A               = eye(nVars);
b               = [100           % max thrust duration (s)
                30              % max thrust (N)
                1.5             % max nozzle:diameter ratio
                60              % max launch azimuth
                60];            % max angle of attack

lb              = [25
                   5
                   0.8
                   0
                   0];
               
ub              = [100
                30
                1.5
                60
                60];
            
Aeq             = [];
beq             = [];
               
%% Optimizer Options
Optimizer = "Powell";
% "Interior-Point" or "SQP" or "Powell"

%% Run Optimizer
[x, nIters, runTime, fval] ...
    = selectOptimizer(x0, Optimizer, A, b, Aeq, beq, lb, ub)

%% Run Nominal Case w/ Optimized Inputs
[maxHeight_km, finalVelocity_kmps, FPA_deg] = runCase(x, verbose);
