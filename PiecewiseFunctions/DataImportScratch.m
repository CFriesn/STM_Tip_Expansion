% ZExpansion Import Scratch

%%
filenames = dir('*.txt');

for i = 1:length(filenames)
    tmp = importdata(filenames(i).name);
    xdata{i} = tmp.data(:,1);
    ydata{i} = tmp.data(:,2);
    names{i} = filenames(i).name(1:6);
end

%%
xData = {Img162x Img166x Img174x Img178x Img182x Img187x};
yData = {Img162y Img166y Img174y Img178y Img182y Img187y};
PStart = [3.33 1.66 0 1.66 3.33 2.49];
PEnd = [1.66 0 1.66 3.33 2.49 1.66];
ImgInd = [162 166 174 178 182 187];

vData = [100/20550 100/20570 100/18880 100/18880 100/1024/9.216/2 100/18880];

for i = 1:length(xData)
    tData{i} = xData{i}/1E-9/vData(i);
end

%%
figure();
hold all;
for i = 1:length(tData)
    plot(tData{i},yData{i});
end

%%
combZ = yData{1};
combt = tData{1};

for i = 2:length(yData)
    offZ = yData{i};
    offZ = offZ - (offZ(1)-combZ(end));
    
    offt = tData{i};
    offt = offt - (offt(1)-combt(end));
    
    combZ = [combZ; offZ];
    combt = [combt; offt];
end

combZ = combZ - min(combZ);

%%
figure();
plot(combt,combZ);