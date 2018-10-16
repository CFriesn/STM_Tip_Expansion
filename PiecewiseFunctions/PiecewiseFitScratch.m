%%

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

Iterations = 2;

par = GetMultiChangeDataParams1();
VarLog = [par.Vars.Current 0];

for i = 1:Iterations    
    
    %Get the initial parameters
    par = GetMultiChangeDataParams1();
    par.Data.T_ModelData = par.Model.T_0;
    par.Data.Z_ModelData = 0;
    par.Data.Z_Tip = par.Vars.Current(3);
    par.Data.Z_Holder = par.Vars.Current(2);
    
    if i == 2
        par.Model.OptimizeVars = [false true true false];
    end
    for j = 1:size(RawRanges,1)
        %Use the results to set up the next section
        par.Model.VarInitial = par.Vars.Current;
        par.Model.T_Offset = par.Data.T_ModelData(end) - par.Model.T_0;
        par.DataProcess.ZOffset = par.Data.Z_ModelData(end);
        par.Model.Tip.delZ_0 = par.Data.Z_Tip(end) - par.Vars.Current(3);
        par.Model.Holder.delZ_0 = par.Data.Z_Holder(end) - par.Vars.Current(2);
        par.DataImport.RawRange = RawRanges(j,:);
        par.Laser.PowerChangeInd = LaserPowerChangeInds(j,:);
        par.Laser.Q = Qs(j,:);
        par.Logging.LogFilename = ['PieceFitLog_It' num2str(i) '_Piece' num2str(j) '_T0-' num2str(par.Model.T_0) '.txt'];
        par = RunModel_TipThermalExpansion(par);
        VarLog = [VarLog; [par.Vars.Current max(par.Data.T_ModelData)-par.Model.T_0]];
    end
end
    