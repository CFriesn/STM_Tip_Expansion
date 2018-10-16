function par = ParseNanonisData(varargin)

if ~isempty(varargin)
    filename = varargin{1};
else
    [filename, path] = uigetfile('*.dat');
    filename = [path filename];
end

if ~filename
    error('Missing/incorrect filename. Exiting.');
end

par.fileid = fopen(filename);

par = ParseHeader(par);

par = ParseData(par);

par = ParseColNames(par);

if length(par.ParsedColNames)>1
    par = CondenseColumns(par);
end

fclose(par.fileid);

end

function par = CondenseColumns(par)

ColNames = par.ParsedColNames;

CondNames{1} = ColNames{1};

if CheckNumeric(par,1)
    dat = str2double(par.RawData(:,1));
else
    dat = par.RawData(:,1);
end

if strcmpi(ColNames{1},'Time')
    try
        dat = datetime(par.RawData(:,1),'InputFormat','dd.MM.yyyy HH:mm:ss');
    catch 
        dat = par.RawData(:,1);
    end
end

CondData{1} = dat;

for i = 2:length(ColNames)
    tmp = ColNames{i};
    
    ind = find(strcmp(CondNames,tmp));
    
    if CheckNumeric(par,i)
        dat = str2double(par.RawData(:,i));
    else
        dat = par.RawData(:,i);
    end
    
    if strcmpi(tmp,'Time')
        try
            dat = datetime(par.RawData(:,i),'InputFormat','dd.MM.yyyy HH:mm:ss');
        catch 
            dat = par.RawData(:,i);
        end
    end

    if isempty(ind)
        CondNames{end+1} = tmp;
        
        CondData{end+1} = dat;

    elseif ~isempty(ind)
        CondData{ind(1)} = [CondData{ind(1)} dat];
    end
    
end

par.ColNames = CondNames;
par.Data = CondData;

end

function res = CheckNumeric(par,ind)
tmp = str2double(par.RawData{1,ind});

if isnan(tmp)
    res = 0;
else
    res = 1;
end

end

function par = ParseColNames(par)

RawColNames = par.RawColNames;
Units = cell(length(RawColNames),1);
ColNames = cell(length(RawColNames),1);
Ind = {};

for i = 1:length(RawColNames)
    curr = RawColNames{i};
    tmp = strsplit(curr,' ');
    
    for j = 1:length(tmp)
        if tmp{j}(1) == '(' && tmp{j}(end) == ')'    
            Units{i} = tmp{end}(2:end-1);
        elseif tmp{j}(1) == '[' && tmp{j}(end) == ']'   
            if ~isempty(str2num(tmp{j}(2:end-1)))
                Ind{i} = str2num(tmp{j}(2:end-1));
            elseif strcmp(tmp{j}(2:end-1),'bwd')
                ColNames{i} = [ColNames{i} 'bwd'];
            elseif strcmp(tmp{j}(2:end-1),'AVG')
                ColNames{i} = [ColNames{i} 'avg'];
            end
        else
            ColNames{i} = [ColNames{i} tmp{j}];
        end
    end
end

par.ParsedColNames = ColNames;
par.Ind = Ind;
par.Units = Units;

end
    
   

function par = ParseData(par)

fileid = par.fileid;


ColNames = strsplit(strtrim(fgetl(fileid)),'\t');

n = GetRemainingLines(fileid);

Data = cell(n,length(ColNames));
Data(1,:) = strsplit(strtrim(fgetl(fileid)),'\t');
i = 2;
while ~feof(fileid)
    tmp = strsplit(strtrim(fgetl(fileid)),'\t');
     
    if ~strcmp(tmp{1},'')
        Data(i,:) = tmp;
        i = i+1;
    end
end

for i = 1:size(Data,1)
    if isempty(Data{i,1})
        Data(i,:) = [];
    end
end
        
    
par.RawColNames = ColNames;
par.RawData = Data;
par.fileid = fileid;

end

function n = GetRemainingLines(fileid)

n = 0;
startpos = ftell(fileid);
while ~feof(fileid)
    n = n + 1;
    tmp = fgetl(fileid);    
end

fseek(fileid,startpos,-1);
% tmp  = fgetl(fileid);
% 
% while ~strcmp('[DATA]',strtrim(tmp))
%     tmp  = fgetl(fileid);
% end
% tmp  = fgetl(fileid);

end

function par = ParseHeader(par)

fileid = par.fileid;

Header = strsplit(strtrim(fgetl(fileid)),'\t');
if length(Header) == 1
    Header{1,2} = '';
end
i = 2;
in = strsplit(strtrim(fgetl(fileid)),'\t');
tmp = strcmp('[DATA]',Header{i-1,1}) || strcmp('[DATA]',in{1});

while ~tmp    
    if ~isempty(in)
        if length(in) > 1
            Header = [Header; in];
        elseif length(in) == 1
            in{2} = '';
            Header = [Header; in];
        end
        i = i+1;
        
    end
    in = strsplit(strtrim(fgetl(fileid)),'\t');
    tmp = strcmp('[DATA]',in);
end

par.fileid = fileid;
par.Header = Header;

end
