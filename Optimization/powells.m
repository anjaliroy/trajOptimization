function [x, nIters, fval] = powells(x0, tol)
nVars = length(x0);

e = getBasisVectors(nVars);
u = e;
delta = inf;
x = x0;
f = runOptimizationCase(x0);

maxIters    = 15;
alpha0      = 10;
i = 1;

while abs(delta) > tol && i < maxIters*2
    x1 = x;
    
    for i = 1:nVars
        d = u(:,1);
        [x1, ~]= lineSearch(x1, d, alpha0, maxIters);
    end
    
    d = x1 - x;
    u = updateDirections(u, nVars, d);
    
    [x1, f1] = lineSearch(x1, d, alpha0, maxIters);
    
    delta = norm(f1 - f);
    
    x = x1;
    f = f1;
    i = i + 1;
end

if i == maxIters*2
    disp("Out of Iterations")
end

nIters = i;
fval = f;
end

function u = updateDirections(u, nVars, slope)

u(:, 1:nVars-1) = u(:, 2:nVars);
u(:, nVars) = slope;
end

function e = getBasisVectors(nVars)
e = eye(nVars);
end