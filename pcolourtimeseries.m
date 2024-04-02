%% Pcolour timeseries

Volcano = 'Sinabung';
Data_YYYYMM = '201906';
% Marapi UTC +7

% only important for when downloading Day time and Night time acquisitions
% separately 
DayNight = 'Night';

Matfile_Data_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Processed_Data/';
Folder_Name = ([Volcano,'_',Data_YYYYMM]);
MatFile_Name = ([Volcano,'_',Data_YYYYMM,'_',DayNight,'_Pcolors.mat']);

File_To_Load = ([Matfile_Data_Folder,Folder_Name,'/',MatFile_Name]);

load(File_To_Load)

reshaped_matrix = tbb_07_pcolor(:);

% Define start date and time parameters
start_date = datetime(2019, 5, 12, 1, 0, 0); % Start date and time
interval = 10; % Time interval in minutes

% Calculate the number of intervals
num_intervals = size(reshaped_matrix, 1);

% Calculate total time span in minutes
total_minutes = num_intervals * interval;

% Create time vector
time = start_date + minutes(0:interval:(total_minutes - interval));

% Plot the column matrix over time
plot(time, reshaped_matrix);
xlabel('Time');
ylabel('Value');
title('Column Matrix Over Time');

