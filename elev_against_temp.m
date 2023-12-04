%% The script plots the temperature against elevation

%% Load the data

clear

addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'

%------------------------Config to change-------------

Volcano = 'Sinabung';
YYYYMM = '201906';
DD = '02';
DayNight = 'Night';

%------------------------------------------------------

DEM_Data_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/DEM/Sinabung/';

Matfile_Data_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Processed_Data/';

DEMFileName = 'resampled_dem.tif';

foldername = [Volcano,'_',YYYYMM,'/',Volcano,'_',YYYYMM,DD,'_',DayNight];
matfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'.mat'];
%stackfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'_Stacked.mat'];



DEMfiletoread = ([DEM_Data_Folder,DEMFileName]);
matfiletoread = ([Matfile_Data_Folder,'/',foldername,'/',matfilename]);
%stackfiletoread = ([Matfile_Data_Folder,'/',foldername,'/',stackfilename]);

[DEM,R] = readgeoraster(DEMfiletoread,"OutputType","double");
load(matfiletoread)
%load(stackfiletoread)

mkdir([Matfile_Data_Folder,foldername,'/','DEMvsTBB'])
cd([Matfile_Data_Folder,foldername,'/DEMvsTBB'])

%%

variableNames = {'tbb_07','tbb_08','tbb_09','tbb_10','tbb_11','tbb_12',...
    'tbb_13','tbb_14','tbb_15','tbb_16'};

for k = 1:length(variableNames)

currentVarName = variableNames{k};

currentVarValue = evalin('base', currentVarName);

myStruct = currentVarValue;

fieldName = fieldnames(myStruct);

%%

xData = [];
yData = [];

for i = 1:length(fieldName)
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
title('Scatter Plot of DEM vs Temperature');
xlabel('Elevation');
ylabel('Brightness Temperature');
legend('Scatter Plot', 'Least Squares Fit');

hold off;

fig_filename = ([strrep(variableNames{k},'_',' '),'TempvsElev.png']);
saveas(gcf, fig_filename);
close

end