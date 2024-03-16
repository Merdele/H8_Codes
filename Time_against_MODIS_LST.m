%% This Script plots the MODIS LST as a function of time

clear

addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'

Volcano = 'Marapi';

MODIS_Data_Folder =  '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/LST_Inversion/MODIS/';

modis_filename_struct = (dir(fullfile(MODIS_Data_Folder,[Volcano,'*'])));

start_loop = 1;

data=[];
dates=[];

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

resampled_LST_row = resampled_LST(:);

resampled_LST_row = resampled_LST_row - 273;

data=[data,resampled_LST_row];

dates=[dates;datetime(str2double(modis_filename_struct(i).name(8:15)),'ConvertFrom', 'yyyymmdd')];

end

%%
num_pixels = numel(resampled_LST);

% Plotting
figure;
hold on;
for i = 1:num_pixels
    plot(dates, data(i,:), 'LineWidth', 1.5);
end

%%
% Add labels for each line
% for i = 1:num_pixels
%     label = sprintf('Pixel %d', i);
%     text(num_days, data(end, i), label, 'FontSize', 8, 'VerticalAlignment', 'middle');
% end

hold off;

% Labels and Title
xlabel('Time');
ylabel('Land Surface Temperature (Celsius)');
title('MODIS Land Surface Temperature Pixels at Mount Marapi over Time');

% Legend (optional)
% legend('Location', 'best'); % You can add legend if needed

% Adjust plot appearance if necessary
grid on;
box on;

fig_filename = 'MODIS_Land_Surface_Temperature_Over_Time.png';
saveas(gcf, fig_filename);
close
