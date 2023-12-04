%% Statistical Testing 

%%

clear

% add path for the create_aoi_coords function
addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'

load("testing.mat")

clear("lat")
clear("lon")

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



