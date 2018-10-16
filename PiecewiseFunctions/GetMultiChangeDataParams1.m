function par = GetMultiChangeDataParams1()
% Assumed units:
% Power: mW
% Temperature: K
% Length: mm --> Vol: mm^3
% Time: s
% Thermal conductance: mW/K

%ODE solver options
par.ODEOptions.Solver = @ode45;
par.ODEOptions.odeopt = odeset();
par.ODEOptions.odeopt.Refine = 3;
par.ODEOptions.odeopt.InitialStep = 1;
par.ODEOptions.odeopt.MaxStep = 2;

%Global Optimizer optionso
par.Optimizer.Solver = @fminsearch;
par.Optimizer.solvopt = optimset();
par.Optimizer.OutOfBoundsVal = 1E10;

%Material property functions: Should all have form prop =
%Function(Temperature[K]), output in base SI units.

%Chromium
par.Material.Cr.CFunc = @Cr_SpecificHeat_LowT;
par.Material.Cr.LinExpFunc = @Cr_LinearExpansion_Fit;
par.Material.Cr.DensityFunc = @Cr_Density;
%Steel
par.Material.Steel.CFunc = @Steel_SpecificHeat_LowT;
par.Material.Steel.LinExpFunc = @Steel_LinearExpansion;
par.Material.Steel.DensityFunc = @Steel_Density;
%Molybdenum
par.Material.Mo.CFunc = @Mo_SpecificHeat_LowT;
par.Material.Mo.LinExpFunc = @Mo_LinearExpansion_Fit;
par.Material.Mo.DensityFunc = @Mo_Density;



%Data Import
par.DataImport.Filename = 'MultiChangeData';
par.DataImport.DataImportFunc = @ImportMultiChangeData;

%For full data range
% par.DataImport.RawRange = [1 1161];
% par.DataImport.BackRange = [1 3];

%For starting at 0mW state
par.DataImport.RawRange = [340 1161];
par.DataImport.BackRange = [320 340];

%Data Processing
par.DataProcess.SubtractLinearBackground = false; %Subtract a linear background from the raw data, acquired from BackRange data?
par.DataProcess.ApplyBinning = false; %Bin and average data to apply smoothing?
par.DataProcess.BinSize = 10; %By time in s
par.DataProcess.ZOffset = 0; %In nm. Will be applied after processing. For chaining together datasets

%Laser Properties
% par.Laser.Q = 4; %mW, nominal power output of the laser
% par.Laser.RawWindow = [1307 4073]; %Indices, time over which the laser is active
% par.Laser.Func = @GetLaserPower; %Function that returns the current laser power at any time t
 %Has form: QLas = GetLaserPower(t,par)
 
%For full data range
% par.Laser.PowerChangeInd = [2 4 230 361 532 703 949];
% par.Laser.Q = [3.33 1.66 0 1.66 3.33 2.49 1.66];

%For starting at the 0mW state
par.Laser.PowerChangeInd = [341 361 532 703 949];
par.Laser.Q = [0 1.66 3.33 2.49 1.66];
par.Laser.Func = @GetLaserPower;
 
 
%Model settings (these should not change during the simulation)
par.Model.TSTM_0 = 50; %Initial STM Bath temperature
par.Model.T_0 = 55; %Initial Tip and holder temperature
par.Model.T_Offset = 0;
par.Model.OptimizeVars = [true false false true]; %[k LHolder LTip LaserTrans] Set which parameters to optimize 
par.Model.VarUpperBounds = [inf  12 1.5 1];
par.Model.VarLowerBounds = [0 5 0.5 0.05];
par.Model.VarInitial = [0.1239 8 1 0.2781]; %[k LHolder LTip LaserTrans] Initial values for the optimizer. If var not optimized, this will be taken as the fixed value.
par.Model.tStep = 0.5; %Simulation time steps? Check if used
par.Model.DynamicC = true; %If true, specific heat calculated only used T_0 temperature


%Settings for the holder. Modify V and Mass as required, with better
%information
par.Model.Holder.Material = par.Material.Steel;
par.Model.Holder.Radius = 1.1; %[mm] Assumed holder radius (for calc volume, to get heat capacity)
par.Model.Holder.V = pi*par.Model.Holder.Radius^2*par.Model.VarInitial(2);
par.Model.Holder.Mass = par.Model.Holder.V * par.Model.Holder.Material.DensityFunc(293);
par.Model.Holder.delZ_0 = 0;

%Settings for the tip. Modify V and Mass as required, with better
%information
par.Model.Tip.Material = par.Material.Cr;
par.Model.Tip.Radius = 0.4; %[mm] Assumed tip radius
par.Model.Tip.V = pi*par.Model.Tip.Radius^2*par.Model.VarInitial(3);
par.Model.Tip.Mass = par.Model.Tip.V * par.Model.Tip.Material.DensityFunc(293);
par.Model.Tip.delZ_0 = 0;

%Current set of variables from the optimizing.
par.Vars.Current = par.Model.VarInitial; %[k LHolder LTip LaserTrans]
par.Vars.LogFileHandle = [];

%Logging settings
par.Logging.ActivateLog = true;
par.Logging.PlotFitting = true;
par.Logging.LogFilename = 'TestLog.txt';


