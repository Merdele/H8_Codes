%% The script plots the temperature against elevation

%% Load the data

clear

addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'

%------------------------Config to change-------------

Volcano = 'Marapi';
YYYYMM = '202312';
DD = '05';
DayNight = 'Day';

%------------------------------------------------------

DEM_Data_Folder = (['/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/DEM/',Volcano]);

Matfile_Data_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Processed_Data/';

DEMFileName = '/resampled_dem.tif';
%%



foldername = [Volcano,'_',YYYYMM,'/',Volcano,'_',YYYYMM,DD,'_',DayNight];
tbbfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'.mat'];
btdfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'_BTD.mat'];
%stackfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'_Stacked.mat'];



DEMfiletoread = ([DEM_Data_Folder,DEMFileName]);
btdfiletoread = ([Matfile_Data_Folder,'/',foldername,'/',btdfilename]);
tbbfiletoread = ([Matfile_Data_Folder,'/',foldername,'/',tbbfilename]);
%stackfiletoread = ([Matfile_Data_Folder,'/',foldername,'/',stackfilename]);

[DEM,R] = readgeoraster(DEMfiletoread,"OutputType","double");
load(btdfiletoread)
load(tbbfiletoread)
%load(stackfiletoread)

mkdir([Matfile_Data_Folder,foldername,'/','DEMvsTBB_Night'])
cd([Matfile_Data_Folder,foldername,'/DEMvsTBB_Night'])

%%


variableNames = {'tbb_13_15','tbb_7_13','tbb_13_14','tbb_14_15','tbb_07',...
    'tbb_08','tbb_09','tbb_10','tbb_11','tbb_12',...
    'tbb_13','tbb_14','tbb_15','tbb_16'};

for k = 1:length(variableNames)

currentVarName = variableNames{k};

currentVarValue = evalin('base', currentVarName);

myStruct = currentVarValue;

fieldName = fieldnames(myStruct);

%%

xData = [];
yData = [];

for i = 36:length(fieldName)
data = myStruct.(fieldName{i});

xData = [xData;DEM(:)];
yData = [yData;data(:)];
end



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

% Customize the plot
% Customize the plot
title('Scatter Plot of Temperature vs Elevation');
xlabel('Elevation');
ylabel('Brightness Temperature');
legend('Scatter Plot', 'Least Squares Fit');

hold off;

fig_filename = ([strrep(variableNames{k},'_',' '),' TempvsElev_Night.png']);
saveas(gcf, fig_filename);
close

end