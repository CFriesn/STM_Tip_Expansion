function par = ParameterOptimization(par)

fitVars = par.Optimizer.Solver(@CalcFitness, ...
    par.Model.VarInitial(par.Model.OptimizeVars), ...
    par.Optimizer.solvopt, par);
par.Vars.Current = par.Model.VarInitial;
tmp = find(par.Model.OptimizeVars);
for i = 1:length(tmp)
    par.Vars.Current(tmp(i)) = fitVars(i);
end

end