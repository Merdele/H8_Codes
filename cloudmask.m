%% This script takes the uses the cloud information and masks out the clouds in 
% tbb data. 


addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'
Data_Folder = ...
'/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Processed_Data/';

%------------------------Config to change-------------
Volcano = 'Sinabung';
YYYYMM = '201906';
DD = '09';
DayNight = 'Night';

%------------------------------------------------------
foldername = [Volcano,'_',YYYYMM,DD,'_',DayNight];
matfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'.mat'];

% if file does not exist, script stops
if exist(matfilename,'file') == 0
    error('File Does Not Exist')
end


