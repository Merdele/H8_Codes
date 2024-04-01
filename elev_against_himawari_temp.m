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
YYYYMM = '201905';
DD = {'12','13','14','15','16',...
    '17','18','19','20','21','22','23','24','25','26','27','28','29','30','31'};
% {'01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16',...
%     '17','18','19','20','21','22','23','24','25','26','27','28','29','30'};
DayNight = 'Night';

%------------------------------------------------------

DEM_Data_Folder = (['/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/DEM/',Volcano]);

Himawari_Data_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Processed_Data/';

DEMFileName = '/resampled_dem.tif';


%%

cumulative_coefficients = [];

for h = 1:length(DD)

% creating filenames
foldername = [Volcano,'_',YYYYMM,'/',Volcano,'_',YYYYMM,DD{h},'_',DayNight];
% foldername = [Volcano,'_2019'];
tbbfilename = [Volcano,'_',YYYYMM,DD{h},'_',DayNight,'.mat'];
% btdfilename = [Volcano,'_',YYYYMM,DD{h},'_',DayNight,'_BTD.mat'];
% NTBfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'_NTB.mat'];
%stackfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'_Stacked.mat'];

% combining filenames and paths
DEMfiletoread = ([DEM_Data_Folder,DEMFileName]);
% btdfiletoread = ([Himawari_Data_Folder,'/',foldername,'/',btdfilename]);
tbbfiletoread = ([Himawari_Data_Folder,'/',foldername,'/',tbbfilename]);
% NTBfiletoread = ([Matfile_Data_Folder,'/',foldername,'/',NTBfilename]);
%stackfiletoread = ([Matfile_Data_Folder,'/',foldername,'/',stackfilename]);

[DEM,R] = readgeoraster(DEMfiletoread,"OutputType","double");
% load(btdfiletoread)
load(tbbfiletoread)
% load(NTBfiletoread)
% load(stackfiletoread)

mkdir([Himawari_Data_Folder,foldername,'/','DEMvsTBB_Night'])
cd([Himawari_Data_Folder,foldername,'/DEMvsTBB_Night'])

% 
variableNames = {'tbb_07','tbb_08','tbb_09','tbb_10','tbb_11','tbb_12',...
    'tbb_13','tbb_14','tbb_15','tbb_16'};
% variableNames = {'BTD_13_14','BTD_13_15','BTD_14_15','BTD_7_13','BTD_7_14',...
% 'BTD_7_15'};

%%

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

greater_than_18_index = yData >=0;

yData = yData(greater_than_18_index);
xData = xData(greater_than_18_index);
%%

% Perform least squares fit (linear fit in this case)
degree = 1;  % Degree of the polynomial (1 for linear fit)
coefficients = polyfit(xData, yData, degree);

YYYYMMDD = [YYYYMM,DD{h}];

one_row_coefficients = {YYYYMMDD,currentVarName,coefficients(1)*1000};

cumulative_coefficients=[cumulative_coefficients;one_row_coefficients];

% figure
% hold on
% 
% % Create a scatter plot
% scatter(xData, yData);
% 
% 
% % Plot the least squares fit line
% fitLine = polyval(coefficients, xData);
% plot(xData, fitLine, 'r-', 'LineWidth', 2);
% 
% % % Plot the linear fit line
% % xFit = linspace(min(xData), max(xData), 100);
% % yFit = predict(mdl, xFit');
% % plot(xFit, yFit, 'r-', 'LineWidth', 2, 'DisplayName', 'Linear Fit');
% 
% % Customize the plot
% 
% title([Volcano,' ',YYYYMM,DD{h},sprintf(' %s Temperature vs Elevation',...
%     strrep(variableNames{k},'_',' '))]);
% % title(sprintf('Scatter Plot of Temperature %s vs Elevation',...
% %     strrep(variableNames{k},'_',' ')));
% xlabel('Elevation');
% ylabel('Brightness Temperature (Celsius)');
% legend('Data Points', 'Least Squares Fit','Location','best');
% 
% hold off;

% fig_filename = ([strrep(variableNames{k},'_',' '),' TempvsElev.png']);
% saveas(gcf, fig_filename);
% close


Output_Folder = ([Himawari_Data_Folder,'/',Volcano,'_',YYYYMM]);
matfilename = [Volcano,'_',YYYYMM,'_',DayNight,'_coefficients_0.mat'];

% specify which variables to be saved depending on what is to be read.
save([Output_Folder,'/',matfilename],"cumulative_coefficients")


end

end
