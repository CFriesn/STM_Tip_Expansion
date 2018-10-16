function fitval = CalcFitness(vars,par)
% 
% For a particular set of kcon, Tip Length, Holder Length, and Trans, this function will
% calculate the expected linear expansion of the tip. This will be
% subtracted from the recorded expansion data to acquire a fitness
% value

%1) Integrate optimize variables into the general model vars
par.Vars.Current = par.Model.VarInitial;
tmp = find(par.Model.OptimizeVars);
for i = 1:length(tmp)
    par.Vars.Current(tmp(i)) = vars(i);
end

%2) Call a solve function to calculate the Z vs t for the given variables
par = SolveExpansionModel(par);

%3) Calc diff of squares with experimental data from this result, return as
%fitval
par.Data.Z_InterpData = interp1(par.Data.t_ModelData,par.Data.Z_ModelData,par.Data.t_CorrData);

fitval = sum((par.Data.Z_CorrData - par.Data.Z_InterpData).^2);

BoundCheck = sum(par.Vars.Current >= par.Model.VarUpperBounds) + ...
    sum(par.Vars.Current <= par.Model.VarLowerBounds);

if(BoundCheck)
    fitval =  par.Optimizer.OutOfBoundsVal;
end

%Logging if active
if par.Logging.ActivateLog
    fprintf(par.Vars.LogFileHandle,'%d %d %d %d %d %d %d\n', ...
        [par.Vars.Current, max(par.Data.T_ModelData), max(par.Data.Z_ModelData) fitval]);
end

if par.Logging.PlotFitting
    gcf = par.Vars.LogFig;
    subplot(1,2,1);
    plot(par.Data.t_ModelData,par.Data.Z_ModelData);
    hold all;
    plot(par.Data.t_CorrData,par.Data.Z_CorrData);
    hold off;
    ylabel('Z [nm]');
    subplot(1,2,2);
    plot(par.Data.t_ModelData,par.Data.T_ModelData);
    ylabel('T [K]');
    
    drawnow;
end   


end

