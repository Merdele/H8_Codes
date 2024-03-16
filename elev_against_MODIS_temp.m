%% The script plots the temperature against elevation
% Plots the MODIS LST data against a resampled DEM file, downloaded from the USGS
% website. 
% Gaps in the DEM was first filled using QGIS and GDALfill. THe filled DEM
% was then resampled to match the pixel size of the BTD data.

%%

clear

addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'

Volcano = 'Marapi';

DEM_Data_Folder = (['/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/DEM/',Volcano]);

DEMFileName = '/resampled_dem.tif';

DEMfiletoread = ([DEM_Data_Folder,DEMFileName]);

[DEM,R] = readgeoraster(DEMfiletoread,"OutputType","double");

MODIS_Data_Folder =  '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/LST_Inversion/MODIS/';

modis_filename_struct = (dir(fullfile(MODIS_Data_Folder,[Volcano,'*'])));

DEMData = [];
LSTData = [];

start_loop = 1;

for i = start_loop:length(modis_filename_struct)
load([MODIS_Data_Folder,modis_filename_struct(i).name])

MODIS_lat = lat;
MODIS_lon = lon;

clear('lat','lon')

LST = LST(1:10,:);

LST(LST == 0) = NaN;

test = reshape(LST, [2, size(LST, 1)/2, size(LST, 2)]);

average_LST = nanmean(test, 1);

average_LST = squeeze(average_LST);

resampled_LST = average_LST(:,1:5);

DEMData=[DEMData;DEM(:)];
LSTData=[LSTData;resampled_LST(:)];

end

nan_idx = isnan(LSTData);

DEMData(nan_idx) = [];
LSTData(nan_idx) = [];

LSTData= LSTData-273;

%%

% Perform least squares fit (linear fit in this case)
degree = 1;  % Degree of the polynomial (1 for linear fit)
coefficients = polyfit(DEMData, LSTData, degree);

hold on

% Create a scatter plot
scatter(DEMData, LSTData);


% Plot the least squares fit line
fitLine = polyval(coefficients, DEMData);
plot(DEMData, fitLine, 'r-', 'LineWidth', 2);

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

% fig_filename = ([strrep(variableNames{k},'_',' '),' TempvsElev.png']);
% saveas(gcf, fig_filename);
% close

