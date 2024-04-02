%% This script plots the coefficients from the temperature against elevation

%% This section loads the data

clear

addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'

%------------------------Config to change-------------

Volcano = 'Sinabung';
YYYYMM = '201906';
DayNight = 'Night';

Himawari_Data_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Processed_Data/';

foldername = [Volcano,'_',YYYYMM];

coefficientsfilename = ([Volcano,'_',YYYYMM,'_',DayNight,'_coefficients.mat']);

coefficientsfiletoread = ([Himawari_Data_Folder,'/',foldername,...
    '/',coefficientsfilename]);

load(coefficientsfiletoread)

Output_Folder = [Himawari_Data_Folder,foldername,'/Gradients/'];
mkdir(Output_Folder)
cd (Output_Folder)
%% This section plots the data

variableNames = {'tbb_07','tbb_08','tbb_09','tbb_10','tbb_11','tbb_12',...
    'tbb_13','tbb_14','tbb_15','tbb_16'};

for i = 1:length(variableNames)

variablaNames_idx = isequal(cumulative_coefficients{:,2},variableNames{i});

% Extract the second column of the cell array
secondColumn = cumulative_coefficients(:, 2);

singleString = variableNames{i};

% Compare each element of the second column with the single string
gradients_IDX = cellfun(@(x) strcmp(x, singleString), secondColumn);

gradients_to_plot = cumulative_coefficients(gradients_IDX,3);

gradients_to_plot_double = cellfun(@double, gradients_to_plot);

plot(1:numel(gradients_to_plot_double),gradients_to_plot_double)

averageGradient = mean(gradients_to_plot_double);

hold on; % To overlay the line on the same plot

% Plot a horizontal line representing the average
xLimits = xlim; % Get the x-axis limits
plot(xLimits, [averageGradient, averageGradient], 'r--'); % Plot a red dashed line

% Annotate the average value on the plot
text(xLimits(2), averageGradient + 0.02*range(ylim), sprintf('Average: %.4f', averageGradient), ...
    'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle');

ylabel('Gradients');
title(['Gradients for ',Volcano,' ',strrep(variableNames{i},'_',' ')])%,...
    %' more than 0']);

fig_filename = (['Gradients for ',Volcano,' ',variableNames{i},'.png']);

saveas(gcf, [Output_Folder,fig_filename]);
close

end
