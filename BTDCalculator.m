%% This script calculates the brightness temperature difference of the 
% bands of Himawari-8 Data. 
% Band 13 minus Band 15 (10.4 um - 12.4um)

clear

addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'

%------------------------Config to change-------------

Volcano = 'Sinabung';
YYYYMM = '201906';
DD = '09';
DayNight = 'Night';

%------------------------------------------------------

Matfile_Data_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Processed_Data/';

foldername = [Volcano,'_',YYYYMM,'/',Volcano,'_',YYYYMM,DD,'_',DayNight];
matfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'.mat'];
%matfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'_Median.mat'];
%stackfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'_Stacked.mat'];

matfiletoread = ([Matfile_Data_Folder,'/',foldername,'/',matfilename]);
%stackfiletoread = ([Matfile_Data_Folder,'/',foldername,'/',stackfilename]);

load(matfiletoread)
%load(stackfiletoread)

cd([Matfile_Data_Folder,foldername])

%%

tbb_13_15 = BTD_calculator_function(tbb_13,tbb_15);

tbb_7_13 = BTD_calculator_function(tbb_07,tbb_13);


%% creating median file name. 
BTDfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'_BTD.mat'];


% specify which variables to be saved depending on what is to be read.
save([Matfile_Data_Folder,'/',foldername,'/',BTDfilename],'tbb_13_15',...
    'tbb_7_13')