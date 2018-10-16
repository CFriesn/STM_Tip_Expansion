function par = ImportMultiChangeData(par)
load('MultiChangeData.mat');
par.Data.Z_RawData = combZ/1E-9;
par.Data.t_RawData = combt;