%% The script plots the temperature against elevation
% Plots the BTD data against a resampled DEM file, downloaded from the USGS
% website. 
% Gaps in the DEM was first filled using QGIS and GDALfill. THe filled DEM
% was then resampled to match the pixel size of the BTD data.

%% This section loads the data

clear

addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'

%------------------------Config to change-------------

Volcano = 'Sinabung';
YYYYMM = '201906';
DD = '09';
DayNight = 'Night';

%------------------------------------------------------

DEM_Data_Folder = (['/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/DEM/',Volcano]);

Matfile_Data_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Processed_Data/';

DEMFileName = '/resampled_dem.tif';

%%

% creating filenames
%foldername = [Volcano,'_',YYYYMM,'/',Volcano,'_',YYYYMM,DD,'_',DayNight];
foldername = [Volcano,'_2019'];
% tbbfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'.mat'];
% btdfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'_BTD.mat'];
NTBfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'_NTB.mat'];
%stackfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'_Stacked.mat'];

% combining filenames and paths
DEMfiletoread = ([DEM_Data_Folder,DEMFileName]);
% btdfiletoread = ([Matfile_Data_Folder,'/',foldername,'/',btdfilename]);
% tbbfiletoread = ([Matfile_Data_Folder,'/',foldername,'/',tbbfilename]);
NTBfiletoread = ([Matfile_Data_Folder,'/',foldername,'/',NTBfilename]);
%stackfiletoread = ([Matfile_Data_Folder,'/',foldername,'/',stackfilename]);

[DEM,R] = readgeoraster(DEMfiletoread,"OutputType","double");
% load(btdfiletoread)
% load(tbbfiletoread)
load(NTBfiletoread)
%load(stackfiletoread)

mkdir([Matfile_Data_Folder,foldername,'/','DEMvsNTB_Night'])
cd([Matfile_Data_Folder,foldername,'/DEMvsNTB_Night'])

%%
variableNames = {'NTB'};%,...
    % 'tbb_08','tbb_09','tbb_10','tbb_11','tbb_12',...
    % 'tbb_13','tbb_14','tbb_15','tbb_16'};

for k = 1:length(variableNames)

currentVarName = variableNames{k};

currentVarValue = evalin('base', currentVarName);

myStruct = currentVarValue;

fieldName = fieldnames(myStruct);

%% This section combines the data in the structs into a single variable.
% the combined data can be controlled for now by looking at the the
% fieldName 

xData = [];
yData = [];

for i = 1:length(fieldName)
data = myStruct.(fieldName{i});

% repeatedly combines the DEM values. Position of the DEM values
% corresponds to the positions of the data values.
xData = [xData;DEM(:)]; 
yData = [yData;data(:)];

end
yData = yData-273;

greater_than_18_index = yData >=18;

yData = yData(greater_than_18_index);
xData = xData(greater_than_18_index);
%%

% Perform least squares fit (linear fit in this case)
degree = 1;  % Degree of the polynomial (1 for linear fit)
coefficients = polyfit(xData, yData, degree);

hold on

% Create a scatter plot
scatter(xData, yData);


% Plot the least squares fit line
fitLine = polyval(coefficients, xData);
plot(xData, fitLine, 'r-', 'LineWidth', 2);

% % Plot the linear fit line
% xFit = linspace(min(xData), max(xData), 100);
% yFit = predict(mdl, xFit');
% plot(xFit, yFit, 'r-', 'LineWidth', 2, 'DisplayName', 'Linear Fit');

% Customize the plot
title('Scatter Plot of Temperature vs Elevation');
xlabel('Elevation');
ylabel('Brightness Temperature (Celsius)');
legend('Scatter Plot', 'Least Squares Fit','Location','best');

hold off;

% fig_filename = ([strrep(variableNames{k},'_',' '),' TempvsElev_0400.png']);
% saveas(gcf, fig_filename);
% close

end

