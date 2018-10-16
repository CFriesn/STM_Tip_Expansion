function par = ProcessRawData(par)

%First apply any Z-Scaling factor to the data, based on piezo calibration
par.Data.Z_RawData = par.Data.Z_RawData*par.DataImport.ZPiezoCorrection;

%Truncate and crop out the actual data and the background range
par.Data.Z_ExpData = par.Data.Z_RawData(par.DataImport.RawRange(1):par.DataImport.RawRange(2));
par.Data.t_ExpData = par.Data.t_RawData(par.DataImport.RawRange(1):par.DataImport.RawRange(2));
par.Data.Z_BackData = par.Data.Z_RawData(par.DataImport.BackRange(1):par.DataImport.BackRange(2));
par.Data.t_BackData = par.Data.t_RawData(par.DataImport.BackRange(1):par.DataImport.BackRange(2));

%Offset the laser window to match to cropped data
% par.Laser.Window = par.Laser.RawWindow - par.DataImport.RawRange(1);
par.Laser.PowerChangeInd = par.Laser.PowerChangeInd - par.DataImport.RawRange(1)+1;

%Next, make a corrected dataset and apply corrections as necessary:
par.Data.Z_CorrData = par.Data.Z_ExpData;
par.Data.t_CorrData = par.Data.t_ExpData;

%First, offset Z and t data to zero
par.Data.Z_CorrData = par.Data.Z_CorrData-par.Data.Z_CorrData(1);
par.Data.t_CorrData = par.Data.t_CorrData-par.Data.t_CorrData(1);
par.Data.Z_BackData = par.Data.Z_BackData-par.Data.Z_BackData(1);
par.Data.t_BackData = par.Data.t_BackData-par.Data.t_BackData(1);

%If chosen in the params, take a linear background from the back z data
if (par.DataProcess.SubtractLinearBackground)
    BackFit = fit(par.Data.t_BackData, par.Data.Z_BackData,'poly1');
    par.Data.Z_CorrData = par.Data.Z_CorrData - BackFit.p1*par.Data.t_CorrData;
end

%If chosen in params, bin the corrected data
if par.DataProcess.ApplyBinning && par.DataProcess.BinSize > 1
    [N, Edges, Bins] = histcounts(par.Data.t_CorrData,'BinWidth',par.DataProcess.BinSize);
    for i = length(Edges)-1:-1:1
        tmpZ(i) = sum(par.Data.Z_CorrData(Bins == i));
        tmpt(i) = sum(par.Data.t_CorrData(Bins == i));
    end
    par.Data.Z_CorrData = tmpZ./N;
    par.Data.t_CorrData = tmpt./N;
    
%     par.Laser.Window = [Bins(par.Laser.Window(1)) Bins(par.Laser.Window(2))];
    
    for i = 1:length(par.Laser.PowerChangeInd)
        par.Laser.PowerChangeInd(i) = Bins(par.Laser.PowerChangeInd(i));
    end    
end

% par.Laser.t_Window = par.Data.t_CorrData([par.Laser.Window]);
par.Laser.t_PowerChange_Window = par.Data.t_CorrData([par.Laser.PowerChangeInd]);

%Time span for the ODE solvers to use
par.Vars.tspan = [par.Data.t_CorrData(1), par.Data.t_CorrData(end)];

par.Data.Z_CorrData = par.Data.Z_CorrData + par.DataProcess.ZOffset;

%Remove raw data from the struct, to save memory
par.Data.Z_RawData = [];
par.Data.t_RawData = [];