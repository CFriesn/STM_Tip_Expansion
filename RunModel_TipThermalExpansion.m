function par = RunModel_TipThermalExpansion(varargin)

% Assumed units:
% Power: mW
% Temperature: K
% Length: mm --> Vol: mm^3
% Time: s

%Use provided arguments or use internal defaults
if ~isempty(varargin)
    par = varargin{1};
else
    par = GetDefaultParams();
    [filename, path] = uigetfile();
    par.DataImport.Filename = [path filename];
end

%Open the logging file
if par.Logging.ActivateLog
    par.Vars.LogFileHandle = fopen(par.Logging.LogFilename,'w+');
    fprintf(par.Vars.LogFileHandle,'k LHolder LTip LaserTrans MaxT MaxZ FitVal\n');
    
end

if par.Logging.PlotFitting
    par.Vars.LogFig = figure();
end

%Import the raw data
par = par.DataImport.DataImportFunc(par);

%Extract from full data the actual data to be used, the background
%data, and subtract linear background from full data
par = ProcessRawData(par);

%Run the actual optimization
par = ParameterOptimization(par);
par = SolveExpansionModel(par);
% %Plot results as required



if par.Logging.PlotFitting
    close(par.Vars.LogFig);
end

if par.Logging.ActivateLog
    fclose(par.Vars.LogFileHandle);
end

save([par.DataImport.Filename(1:end-4) '-ModelOutput.mat'],'par');

end










