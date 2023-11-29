%% Read and specify netcdf Data and Location and Saves into a .mat file
% First Step
% Himawari-9 Data, Downloaded from Jaxa SFPT
% Reads netcdf file. Specify Data Folder
% Some netcdf files might not work and an error will be displayed
% Created by Denny on 21 September 2023, Updated on 22 September 2023
% next step to get the latitude and longitudes i want. 

%% This Section creates the coordinates for the area of interest to be looked at
% it then loads the data using a dir() to get the names of all the netcdf
% files in the Data Folder
clear

% add path for the create_aoi_coords function
addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'

%% ------------------------Config to change-------------
Volcano = 'Sinabung';
YYYYMM = '201906';
DD = '09';
DayNight = 'Night';
%AOI='Small';

% CHANGE COORDINATES FOR DIFFERENT VOLCANOES
[lat_min, lat_max, lon_min,lon_max] = ...
    create_aoi_coords_function(3.170479,98.391995,0.07,0.02);

%% ----------------------------------------------------

Data_Folder = ...
['/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Raw_Data/',...
Volcano,'_',YYYYMM,DD,'_',DayNight];

Output_Folder = ['/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Processed_Data/',...
Volcano,'_',YYYYMM,'/',Volcano,'_',YYYYMM,DD,'_',DayNight,'/'];

mkdir(Output_Folder)

cd(Data_Folder)

% specifies the data folder
%Data_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Raw_Data/Sinabung_20190604_Night';
S = dir(fullfile(Data_Folder,'NC*.nc'));


%% This Section Loops and saves the data in a .mat file

% ncdisp to see information
% loops to read and load the netcdf data
for i = 1:length(S)
    try
    inFile=[S(i).folder,'/',S(i).name];
    time_of_data_collection = (S(i).name(1:20));

    % Saving latitude, longtitude, tbb into structs, categorised by fields
    % labelled as the file name(i.e. time of data collection)
    fulllat.(time_of_data_collection(1,:))= ...
        ncread(inFile,'latitude');
    fulllon.(time_of_data_collection(1,:))= ...
        ncread(inFile,'longitude');

    % Finding the indexes of the latitude and longitude at the corners of
    % the AOI from the .nc file
   
    lat_condition = (fulllat.(time_of_data_collection(1,:)) >= lat_min - 0.01) & ...
        (fulllat.(time_of_data_collection(1,:)) <= lat_max + 0.01);

    lat_min_index = find(lat_condition,1,'last');
    lat_max_index = find(lat_condition,1,'first');

    lon_condition = (fulllon.(time_of_data_collection(1,:)) >= lon_min - 0.01) & ...
        (fulllon.(time_of_data_collection(1,:)) <= lon_max + 0.01);

    lon_min_index = find(lat_condition,1,'first');
    lon_max_index = find(lat_condition,1,'last');

    % creating the starting index and number of cells to be read
    start = [lat_max_index lon_min_index];
    count = [lat_min_index-lat_max_index lon_max_index-lon_min_index];
    
    % indexing only the data within the AOI 
    % only one value for lat and lon because they are a X x 1 vector
    lat.(time_of_data_collection(1,:))= ...
        ncread(inFile,'latitude',lat_max_index,lat_min_index-lat_max_index);
    lon.(time_of_data_collection(1,:))= ...
        ncread(inFile,'longitude',lon_min_index,lon_max_index-lon_min_index);

    %fulltbb_07.(time_of_data_collection(1,:))=ncread(inFile,'tbb_07');
    tbb_07.(time_of_data_collection(1,:))=ncread(inFile,'tbb_07',start,count);
    tbb_08.(time_of_data_collection(1,:))=ncread(inFile,'tbb_08',start,count);
    tbb_09.(time_of_data_collection(1,:))=ncread(inFile,'tbb_09',start,count);
    tbb_10.(time_of_data_collection(1,:))=ncread(inFile,'tbb_10',start,count);
    tbb_11.(time_of_data_collection(1,:))=ncread(inFile,'tbb_11',start,count);
    tbb_12.(time_of_data_collection(1,:))=ncread(inFile,'tbb_10',start,count);
    tbb_13.(time_of_data_collection(1,:))=ncread(inFile,'tbb_11',start,count);
    tbb_14.(time_of_data_collection(1,:))=ncread(inFile,'tbb_14',start,count);
    tbb_15.(time_of_data_collection(1,:))=ncread(inFile,'tbb_15',start,count);
    tbb_16.(time_of_data_collection(1,:))=ncread(inFile,'tbb_16',start,count);

    % OTHER PARAMETERS THAT YOU CAN CHOOSE TO LOAD
    % band_id.(time_of_data_collection(1,:))=ncread(inFile,'band_id');
    % start_time.(time_of_data_collection(1,:))=ncread(inFile,'start_time');
    % end_time.(time_of_data_collection(1,:))=ncread(inFile,'end_time');
    % geom_para.(time_of_data_collection(1,:))=ncread(inFile,...
    %     'geometry_parameters');
    % alb_01.(time_of_data_collection(1,:))=ncread(inFile,'albedo_01');
    % alb_02.(time_of_data_collection(1,:))=ncread(inFile,'albedo_02');
    % alb_04.(time_of_data_collection(1,:))=ncread(inFile,'albedo_04');
    % alb_05.(time_of_data_collection(1,:))=ncread(inFile,'albedo_05');
    % alb_06.(time_of_data_collection(1,:))=ncread(inFile,'albedo_06');
    % hour.(time_of_data_collection(1,:))=ncread(inFile,'Hour');

    catch
        fprintf('Error reading file %s\n', S(i).name);
        continue;
    end

end

%%

matfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'.mat'];

% specify which variables to be saved depending on what is to be read.
save([Output_Folder,matfilename],"lat","lon","tbb_07","tbb_08","tbb_09"...
    ,"tbb_10","tbb_11","tbb_12","tbb_13","tbb_14","tbb_15","tbb_16")


