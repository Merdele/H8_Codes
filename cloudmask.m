%% This script takes the uses the cloud information and masks out the clouds in 
% tbb data. 


addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'
Data_Folder = ...
'/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Processed_Data/Sinabung_201906/';

%------------------------Config to change-------------
Volcano = 'Sinabung';
YYYYMM = '201906';
DD = '09';
DayNight = 'Night';

%------------------------------------------------------
matdataname = [Volcano,'_',YYYYMM,DD,'_',DayNight,'.mat'];
matcloudname = [Volcano,'_',YYYYMM,DD,'_cloud.mat'];

% if file does not exist, script stopsw
if exist(matdataname,'file') == 0 || exist(matcloudname,'file') == 0
    error('File Does Not Exist')
end

load ([Data_Folder,matdataname])
load ([Data_Folder,matcloudname])

%% This section indexes out the pixels that have clouds

fieldName = fieldnames(tbb_07);

NonZeroIDX = CLYTPE.(fieldName{1});

