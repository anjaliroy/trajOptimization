function [x,fval,exitflag,output] = sqpSolve(x0,A,b,Aeq,beq,lb,ub,nonlcon,options)
% Based On: https://github.com/rensor/fminsqp

x = x0;

% Options
options.MoveLimit = 0.1;
options.MoveLimitExpand = 1.1;
options.MoveLimitReduce = 0.25;

% Initialize the current box constraints with upper and lower bounds.
xLcur = lb;
xUcur = ub;

% Initialize "old" design variables
xold1 = x;
xold2 = x;


% evaluate initial non-linear in-equality constraints
nGnl = 0;
history.maxInf = [];

% evaluate objective function at initial point
f0  = runOptimizationCase(x);

% Get scaling factor for merit function
aFac = max([abs(f0),1]);

% Evaluate merit function
f = runOptimizationCase(x);
% Store initial value for filter
filter.initF = f;

% Store "old" value for convergence check
fOld = f;
df = zeros(length(x),1);
deltax = zeros(length(x),1);
H = eye(length(x));

% Set counters and switches
nFeval = 1;
iterNo = 0;
optimize = true;
% Main loop
while optimize
    
    % update iteration counter
    iterNo = iterNo + 1;
    
    % Store previous gradients (minus 1)
    dfm1 = df;
    % evaluate gradients
    [~,df] = getObj(x,true);
    [g] = getConstraints(x,false);
    [~,dg] = getConstraints(x,true);
    
    if iterNo > 1
        H = updateHessian(H,df,dfm1,deltax);
    end
    
    % Assemble linear and non-linear in-equality constraints
    Am = zeros(size(A,1)+nGnl,size(A,2)); % Allocate
    Am(1:size(A,1),1:size(A,2)) = A; % Load linear
    bm = zeros(size(b,1)+nGnl,1); % Allocate
    bm(1:size(b,1)) = b; % Load linear
    
    % Expand linear equality constraints to account for slag variables
    Ameq = [];
    
    % update move-limits
    reduceSwitch = false;
    [xLcur, xUcur] = AdaptiveMoveLimit(x, xLcur, xUcur, lb, ub, options.MoveLimit ,options.MoveLimitReduce, options.MoveLimitExpand, xold1, xold2, reduceSwitch);
    
    % update old values
    xold2 = xold1;
    xold1 = x;
    
    % Set switches
    backtrack = true;
    
    % Inner loop
    while backtrack
        
        % Set lower and upper bounds for the lp problem
        xL = xLcur(:);
        xU = xUcur(:);
        
        % Call optimizer
        [xNew,exitflag] = qpSolver(df,Am,bm,Ameq,beq,xL,xU,x);
        
        % Determine design deltas
        deltax = xNew - x;
        deltanorm = norm(deltax);
        
        % Determine optimality Norm for convergence check
        optimalityNorm = norm(df);
        
        % evaluate constraints
        [g] = getConstraints(xNew,false);
        
        % Evaluate objective function at new point
        nFeval = nFeval + 1;
        
        [f] = getObj(xNew,false);
        
        % Determine delta for merit function
        deltaf = fOld - f;
        
        % Determine maximum infeasibility for current design
        filter.h = max([g;0]);
        % Store objective function value for current design
        filter.f = f/filter.initF;
        
        % Evaluate current (h,f) point against the convergence filter
        [filter] = EvaluateCurrentDesignPointToFilter(filter);
        
        % Assume that we don't want to update the convergence filter
        AddToFilter = false;
        if (filter.PointAcceptedByFilter)
            % Determine Delta values for filter checks
            deltaQ = -df'*deltax-0.5*deltax'*H*deltax;
            
            % Check if we should add accept the current point
            if ( (deltaf<filter.sigma*deltaQ) && (deltaQ>0.0) )
                % Not accepted
                reduceSwitch = true;
            else
                % Accepted
                reduceSwitch = false;
                backtrack = false;
                % Check if we should but the new point (h,f) into the filter
                if(deltaQ <= 0.0)
                    AddToFilter = true;
                end
            end
        else
            reduceSwitch = true;
        end
        
        if reduceSwitch
            [xLcur, xUcur] = AdaptiveMoveLimit(x, xLcur, xUcur,lb, ub, options.MoveLimit ,options.MoveLimitReduce, options.MoveLimitExpand, xold1, xold2, reduceSwitch);
        end
        
        % check for convergence
        if (optimalityNorm <= options.OptimalityTolerance) || (deltanorm <=options.StepTolerance) || (iterNo >= options.MaxIterations) || (nFeval >= options.MaxFunctionEvaluations)
            optimize = false;
            backtrack = false;
            exitflag = 1;
            fval = fun(x);
        end
        
    end % Inner loop
    
    % Does the new point(h,f) qualify to be added to the filter?
    if (AddToFilter)
        [ filter ] = UpdateFilter(filter, filter.h, filter.f);
    end
    
    % Update design variables
    x = xNew;
    
    % Update "old" design
    fOld = f;
    history.f(iterNo) = f;
    history.xnorm(iterNo) = deltanorm;
    maxInf = max([g;0]);
    history.maxInf(iterNo) = maxInf;
    history.nIter = iterNo;
    history.nFeval = nFeval;
    
   
end % Main loop

history.f(iterNo+1:end)=[];
history.xnorm(iterNo+1:end)=[];
history.maxInf(iterNo+1:end)=[];
output.history = history;

end % Solve function

function H = updateHessian(H,df,dfm1,deltax)
s = deltax;
y = df-dfm1;
sHs = s'*H*s;
sy = s'*y;
if sy >=0.2*sHs
    theta = 1;
    r = y;
else
    theta = 0.8*sHs/(sHs-sy);
    r = theta*y+(1-theta)*H*s;
end

H = H - H*s*s'*H/(sHs)+r*r'/(s'*r);
end

function [xLcur, xUcur] = AdaptiveMoveLimit(x, xLcur, xUcur, xLorg, xUorg, moveLimit ,reduceFac, expandFac, xold1, xold2, reduceSwitch)

if (reduceSwitch)
    Expand = reduceFac;
    Reduction = reduceFac;
else
    Reduction = reduceFac;
    Expand = expandFac;
end

nDv = numel(x);
for dvNo = 1:nDv
    delta = (xUcur(dvNo)-xLcur(dvNo))/2; % This was the previous allowable change
    % Use the iteration history to determine whether we have oscillations
    % in the design variables
    if (abs(x(dvNo)-xold1(dvNo)) > 1.e-10)
        s1 = (xold1(dvNo)-xold2(dvNo)) / (x(dvNo)-xold1(dvNo));
        if (s1 < 0.0)
            delta = delta*Reduction;      % oscillation, slow increase
        else
            delta = delta*Expand;       % Stable, allow more rapid increase
        end
    else
        delta = delta*moveLimit;
    end
    dmax = (xUorg(dvNo)-xLorg(dvNo))*moveLimit;
    if (delta > dmax)
        delta = dmax;
    end
    % Initial extimate of lower and upper bound on x(i)
    xLcur(dvNo) = x(dvNo) - delta;
    xUcur(dvNo) = x(dvNo) + delta;
    % Make sure we are within the feasible domain
    xLcur(dvNo) = max(xLcur(dvNo),xLorg(dvNo));
    xUcur(dvNo) = min(xUcur(dvNo),xUorg(dvNo));
    % Take care of extremely small design changes where the bounds may be interchanged
    if (xLcur(dvNo) >= xUcur(dvNo)); xLcur(dvNo) = 0.9999999*xUcur(dvNo); end;
    if (xUcur(dvNo) <= xLcur(dvNo)); xUcur(dvNo) = 1.0000001*xLcur(dvNo); end;
end
end