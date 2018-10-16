function [VarLog, par] = PerformPiecewiseFit(par)

BasePar = par;

RawRanges = [ ...
    340 531; ...
    525 701; ...
    695 946; ...
    940 1160; ...
    ];

LaserPowerChangeInds = [ ...
    341 361; ...
    526 532; ...
    696 703; ...
    941 950; ...
    ];

Qs = [ ...
    0 1.66; ...
    1.66 3.33; ...
    3.33 2.49; ...
    2.49 1.66; ...
    ];

VarLog = [par.Vars.Current 0 0 0];

par.Data.T_ModelData = par.Model.T_0;
par.Data.Z_ModelData = 0;
par.Data.Z_Tip = par.Vars.Current(3);
par.Data.Z_Holder = par.Vars.Current(2);

BaseLog = par.Logging.LogFilename(1:end-4);

for j = 1:size(RawRanges,1)
    %Use the results to set up the next section initial parameters
    par.Model.VarInitial = par.Vars.Current;
    
    par.Model.T_Offset = par.Data.T_ModelData(end) - par.Model.T_0;
    
    par.DataProcess.ZOffset = par.Data.Z_ModelData(end);
    par.Model.Tip.delZ_0 = par.Data.Z_Tip(end) - par.Vars.Current(3);
    par.Model.Holder.delZ_0 = par.Data.Z_Holder(end) - par.Vars.Current(2);
    
    %Switch to the index settings for the next segment
    par.DataImport.RawRange = RawRanges(j,:);
    par.Laser.PowerChangeInd = LaserPowerChangeInds(j,:);
    par.Laser.Q = Qs(j,:);
    
    %Change to a new logfile name, indexed according to segment
    par.Logging.LogFilename = [BaseLog '_' num2str(j) '.txt'];
    
    %Run model and save resulting parameters and convenient data
    par = RunModel_TipThermalExpansion(par);
    par.Logging.ActivateLog = false;
    finalfitval = CalcFitness(par.Vars.Current,par);
    par.Logging.ActivateLog = true;
    VarLog = [VarLog; [par.Vars.Current ...
        par.Data.T_ModelData(end)-par.Data.T_ModelData(1) ...
        par.Data.Z_ModelData(end) - par.Data.Z_ModelData(1) finalfitval] ];
end