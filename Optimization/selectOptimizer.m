function [x, nIters, runTime, fval] ...
    = selectOptimizer(x0, Optimizer, A, b, Aeq, beq, lb, ub)

tol = 1e-3;
nonlcon = [];

switch Optimizer
    case "Interior-Point"
        options = optimoptions(@fmincon,...
            'Algorithm','interior-point',...
            'PlotFcn',{@optimplotfval,@optimplotfirstorderopt});
        tic
        [x,fval,exitflag,output]...
            = fmincon(@runOptimizationCase,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);
        runTime = toc;
        nIters = output.iterations;
    case "SQP"
        options = optimoptions(@fmincon,...
            'Algorithm','sqp',...
            'PlotFcn',{@optimplotfval,@optimplotfirstorderopt});
        tic
        [x,fval,exitflag,output]...
            = fmincon(@runOptimizationCase,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);
        runTime = toc;
        nIters = output.iterations;
    case "Powell"
        tic
        [x, nIters, fval]  = powells(x0, tol);
        runTime = toc;
    otherwise
        disp("No Valid Optimizer Selected")
end

end