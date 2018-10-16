function par = ImportRawData(par)

filename = par.DataImport.Filename;

tmp = ParseNanonisData(filename);

%Change to searching for indices from the ColNames vector

par.Data.Z_RawData = tmp.Data{6};
par.Data.Z_RawData = par.Data.Z_RawData/1E-9; %Convert the raw data to nm from m

par.Data.t_RawData = str2double(tmp.Data{1});
par.Data.t_RawData = par.Data.t_RawData/1E3; %Convert raw time to s from ms

par.Data.VarNames_RawData = tmp.RawColNames;

% par.T0 = str2num(FindHeaderValue(tmp.Header,'Ext. VI 1>Temp A (K)'));

% tmp = importdata(filename);
% par.Data.t_RawData = tmp.data(:,1)/(100E-9/20550);
% 
% par.Data.Z_RawData = tmp.data(:,2)/1E-9;