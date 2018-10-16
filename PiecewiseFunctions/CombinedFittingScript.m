%% Combined fitting scratch
BasePar = WeekendFittingBaseParams();

% delT vs. LHolder_0
LogFileBase = 'delTvsHolderLength_';

LHolder_0 = 1:9;

for i = 1:length(LHolder_0);
    par = BasePar;
    par.Model.T_0 = 60;
    
    par.Model.VarInitial(2) = LHolder_0(i);
    par.Logging.LogFilename = [LogFileBase num2str(LHolder_0(i)) '.txt'];
    par.Vars.Current = par.Model.VarInitial; 
    
    [VarLog par] = PerformPiecewiseFit(par);
    FitData{i} = VarLog;
end

save('delTvsHolderLength_VarLogs.mat','FitData');

%delT vs. T_0

LogFileBase = 'delTvsT0_';

T_0 = 55:65;

for i = 1:length(T_0);
    par = BasePar;
    
    par.Model.T_0 = T_0(i);    
    par.Logging.LogFilename = [LogFileBase num2str(T_0(i)) '.txt'];
    par.Vars.Current = par.Model.VarInitial; 
    
    [VarLog par] = PerformPiecewiseFit(par);
    
    FitData{i} = VarLog;
end

save('delTvsT0_VarLogs.mat','FitData');   


%%
TFits = FitData;

T_0 = 55:65;
T_max = [];
for i = 1:length(TFits)
    Tmax(i) = TFits{i}(2,5);
end

%%
figure();
plot(T_0,Tmax)

%%
LFits = FitData;

LHolder_0 = 6:11;
T_LSweep = [];
for i = 1:length(LFits)
    T_LSweep(i) = LFits{i}(2,1);
end

%%
figure();
plot(LHolder_0,T_LSweep)

%%
par = BasePar;
par.Logging.LogFilename = 'AlternatingFitLog.txt';
[VarLog par] = PerformPiecewiseFit(par);
par.Model.VarInitial = par.Vars.Current;
par.Model.OptimizeVars = [false true false false];
[VarLog(2,:) par] = PerformPiecewiseFit(par);