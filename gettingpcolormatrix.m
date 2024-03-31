%% This script creates matrixes for the different Brightness Temperature Data
% where each column represents data from a day and each row represents data
% collected at each timing
% Created by Denny on 6 Feb 2024


clear
                
% add path for the create_aoi_coords function
addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'

%---------Config to change--------
% Change the details for the specific event - the file directory will be
% saved according to the following variables
Volcano = 'Sinabung';
YYYYMM = '201905';
DD = {'12',...
    '13','14','15','16','17','18','19','20','21','22','23','24','25',...
     '26','27','28','29','30'};
% 
% {'01','02','03','04','05','06','07','08','09','10','11','12',...
%     '13','14','15','16','17','18','19','20','21','22','23','24','25',...
%     '26','27','28','29','30','31'};

% Marapi UTC +7

% only important for when downloading Day time and Night time acquisitions
% separately 
DayNight = 'Night';

%%

Matfile_Data_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Processed_Data/';

tbb_07_pcolor = []; 
tbb_08_pcolor = []; 
tbb_09_pcolor = []; 
tbb_10_pcolor = []; 
tbb_11_pcolor = []; 
tbb_12_pcolor = []; 
tbb_13_pcolor = []; 
tbb_14_pcolor = []; 
tbb_15_pcolor = []; 
tbb_16_pcolor = []; 


for i = 1:length(DD)


foldername = [Volcano,'_',YYYYMM,'/',Volcano,'_',YYYYMM,DD{i},'_',DayNight];
matfilename = [Volcano,'_',YYYYMM,DD{i},'_',DayNight,'.mat'];
%matfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'_Median.mat'];
%stackfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'_Stacked.mat'];

matfiletoread = ([Matfile_Data_Folder,'/',foldername,'/',matfilename]);
%stackfiletoread = ([Matfile_Data_Folder,'/',foldername,'/',stackfilename]);

load(matfiletoread)
%load(stackfiletoread)



cd([Matfile_Data_Folder,foldername])

yearmonth=YYYYMM;
day = DD{i};

data_07 = pcolormatrix_function('tbb_07',yearmonth,day);
data_08 = pcolormatrix_function('tbb_08',yearmonth,day);
data_09 = pcolormatrix_function('tbb_09',yearmonth,day);
data_10 = pcolormatrix_function('tbb_10',yearmonth,day);
data_11 = pcolormatrix_function('tbb_11',yearmonth,day);
data_12 = pcolormatrix_function('tbb_12',yearmonth,day);
data_13 = pcolormatrix_function('tbb_13',yearmonth,day);
data_14 = pcolormatrix_function('tbb_14',yearmonth,day);
data_15 = pcolormatrix_function('tbb_15',yearmonth,day);
data_16 = pcolormatrix_function('tbb_16',yearmonth,day);

tbb_07_pcolor = [tbb_07_pcolor,data_07];
tbb_08_pcolor = [tbb_08_pcolor,data_08];
tbb_09_pcolor = [tbb_09_pcolor,data_09];
tbb_10_pcolor = [tbb_10_pcolor,data_10];
tbb_11_pcolor = [tbb_11_pcolor,data_11];
tbb_12_pcolor = [tbb_12_pcolor,data_12];
tbb_13_pcolor = [tbb_13_pcolor,data_13];
tbb_14_pcolor = [tbb_14_pcolor,data_14];
tbb_15_pcolor = [tbb_15_pcolor,data_15];
tbb_16_pcolor = [tbb_16_pcolor,data_16];

data_07 = [];
data_08 = [];
data_09 = [];
data_10 = [];
data_11 = [];
data_12 = [];
data_13 = [];
data_14 = [];
data_15 = [];
data_16 = [];


end

%%
YYYYMM = '202312';
DD = {'01','02'};

for i = 1:length(DD)


foldername = [Volcano,'_',YYYYMM,'/',Volcano,'_',YYYYMM,DD{i},'_',DayNight];
matfilename = [Volcano,'_',YYYYMM,DD{i},'_',DayNight,'.mat'];
%matfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'_Median.mat'];
%stackfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'_Stacked.mat'];

matfiletoread = ([Matfile_Data_Folder,'/',foldername,'/',matfilename]);
%stackfiletoread = ([Matfile_Data_Folder,'/',foldername,'/',stackfilename]);

load(matfiletoread)
%load(stackfiletoread)



cd([Matfile_Data_Folder,foldername])

yearmonth=YYYYMM;
day = DD{i};

data_07 = pcolormatrix_function('tbb_07',yearmonth,day);
data_08 = pcolormatrix_function('tbb_08',yearmonth,day);
data_09 = pcolormatrix_function('tbb_09',yearmonth,day);
data_10 = pcolormatrix_function('tbb_10',yearmonth,day);
data_11 = pcolormatrix_function('tbb_11',yearmonth,day);
data_12 = pcolormatrix_function('tbb_12',yearmonth,day);
data_13 = pcolormatrix_function('tbb_13',yearmonth,day);
data_14 = pcolormatrix_function('tbb_14',yearmonth,day);
data_15 = pcolormatrix_function('tbb_15',yearmonth,day);
data_16 = pcolormatrix_function('tbb_16',yearmonth,day);

tbb_07_pcolor = [tbb_07_pcolor,data_07];
tbb_08_pcolor = [tbb_08_pcolor,data_08];
tbb_09_pcolor = [tbb_09_pcolor,data_09];
tbb_10_pcolor = [tbb_10_pcolor,data_10];
tbb_11_pcolor = [tbb_11_pcolor,data_11];
tbb_12_pcolor = [tbb_12_pcolor,data_12];
tbb_13_pcolor = [tbb_13_pcolor,data_13];
tbb_14_pcolor = [tbb_14_pcolor,data_14];
tbb_15_pcolor = [tbb_15_pcolor,data_15];
tbb_16_pcolor = [tbb_16_pcolor,data_16];

data_07 = [];
data_08 = [];
data_09 = [];
data_10 = [];
data_11 = [];
data_12 = [];
data_13 = [];
data_14 = [];
data_15 = [];
data_16 = [];


end


%%
% Output_Folder = ([Matfile_Data_Folder,Volcano,'_',YYYYMM]);
Output_Folder = ([Matfile_Data_Folder,'/',Volcano,'_',YYYYMM]);
matfilename = [Volcano,'_',YYYYMM,'_',DayNight,'_Pcolors.mat'];

% specify which variables to be saved depending on what is to be read.
save([Output_Folder,'/',matfilename],"tbb_16_pcolor","tbb_15_pcolor",...
    "tbb_14_pcolor","tbb_13_pcolor","tbb_12_pcolor","tbb_11_pcolor",...
    "tbb_10_pcolor","tbb_09_pcolor","tbb_08_pcolor","tbb_07_pcolor")