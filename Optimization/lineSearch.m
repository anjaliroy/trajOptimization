function [x2, f2] = lineSearch(x1, direction, alpha0, maxIters)
f1 = runOptimizationCase(x1);
f2 = f1;

alpha = alpha0;
x2 = x1;
i = 0;

while f2 >= f1 && i < maxIters
    x2 = x1 + alpha*(direction);
    f2 = runOptimizationCase(x1);
    alpha = 0.8*alpha;
    i = i+1;
end
end