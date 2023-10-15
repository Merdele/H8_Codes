%% Statistical Testing 

%%

clear

% add path for the create_aoi_coords function
addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'

load("testing.mat")

clear("lat")
clear("lon")

% Load your 1x1 struct (replace with your data loading code)
dataStruct = load('your_data.mat'); % Replace with your data file

% Get a list of field names in the struct
fieldNames = fieldnames(dataStruct);

% Define the reference dataset (e.g., the dataset you want to compare against)
referenceData = dataStruct.(fieldNames{1});

% Loop through the fields and perform KS tests
for i = 2:numel(fieldNames)
    % Get the data for the current field
    currentData = dataStruct.(fieldNames{i});
    
    % Perform the KS test to compare the current data to the reference data
    [h, p, kstat] = kstest2(referenceData, currentData);
    
    % Display the results
    fprintf('KS Test for Field %s:\n', fieldNames{i});
    fprintf('KS Test Statistic: %.4f\n', kstat);
    fprintf('P-value: %.4f\n', p);
    
    if h == 1
        fprintf('The null hypothesis is rejected; the two datasets have different distributions.\n');
    else
        fprintf('The null hypothesis is not rejected; the two datasets have similar distributions.\n');
    end
    
    % Add a separator line between tests
    fprintf('---------------------------------------------\n');
end



%%


figure;
histogram(tbb_07.NC_H09_20230720_0000, 'Normalization', 'pdf', 'BinWidth', 0.1); 
title('Probability Distribution of NetCDF Data');
xlabel('Data Values');
ylabel('Probability Density');

figure;
histogram(tbb_07.NC_H09_20230720_0030, 'Normalization', 'pdf', 'BinWidth', 0.1); 
title('Probability Distribution of NetCDF Data');
xlabel('Data Values');
ylabel('Probability Density');

figure;
histogram(tbb_07.NC_H09_20230720_0100, 'Normalization', 'pdf', 'BinWidth', 0.1); 
title('Probability Distribution of NetCDF Data');
xlabel('Data Values');
ylabel('Probability Density');

figure;
histogram(tbb_07.NC_H09_20230720_0130, 'Normalization', 'pdf', 'BinWidth', 0.1); 
title('Probability Distribution of NetCDF Data');
xlabel('Data Values');
ylabel('Probability Density');

figure;
histogram(tbb_07.NC_H09_20230720_0200, 'Normalization', 'pdf', 'BinWidth', 0.1); 
title('Probability Distribution of NetCDF Data');
xlabel('Data Values');
ylabel('Probability Density');

figure;
histogram(tbb_07.NC_H09_20230720_0230, 'Normalization', 'pdf', 'BinWidth', 0.1); 
title('Probability Distribution of NetCDF Data');
xlabel('Data Values');
ylabel('Probability Density');

figure;
histogram(tbb_07.NC_H09_20230720_0300, 'Normalization', 'pdf', 'BinWidth', 0.1); 
title('Probability Distribution of NetCDF Data');
xlabel('Data Values');
ylabel('Probability Density');


%%
% Perform the KS test against a normal distribution
%[h, p, kstat, critval] = kstest(tbb_07.NC_H09_20230720_0000, 'CDF', 'norm');

%[h, p, kstat] = kstest2(tbb_07.NC_H09_20230720_0000(:),tbb_07.NC_H09_20230720_0030(:));

[h, p, kstat] = kstest2(tbb_07.NC_H09_20230720_0000(:),tbb_07.NC_H09_20230720_0330(:));

% [h, p, kstat] = kstest2(tbb_07.NC_H09_20230720_0000(:),tbb_07.NC_H09_20230720_0030(:));

% cdfplot(x)
% hold on
% x_values = linspace(min(x),max(x));
% plot(x_values,normcdf(x_values,0,1),'r-')
% legend('Empirical CDF','Standard Normal CDF','Location','best')



