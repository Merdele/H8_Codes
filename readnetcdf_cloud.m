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

%------------------------Config to change-------------
Volcano = 'Sinabung';
YYYYMM = '201906';
DD = '09';

% CHANGE COORDINATES FOR DIFFERENT VOLCANOES
[lat_min, lat_max, lon_min,lon_max] = ...
    create_aoi_coords_function(3.17,98.392,0.5,0.5);

% ----------------------------------------------------

Data_Folder = ...
['/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Cloud_product/',...
Volcano,'_',YYYYMM,DD];

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
    lat_min_index = find(fulllat.(time_of_data_collection(1,:)) == lat_min);
    lat_max_index = find(fulllat.(time_of_data_collection(1,:)) == lat_max);
    lon_min_index = find(fulllon.(time_of_data_collection(1,:)) == lon_min);
    lon_max_index = find(fulllon.(time_of_data_collection(1,:)) == lon_max);

    % creating the starting index and number of cells to be read
    start = [lat_max_index lon_min_index];
    count = [lat_min_index-lat_max_index lon_max_index-lon_min_index];
    
    % indexing only the data within the AOI 
    % only one value for lat and lon because they are a X x 1 vector
    cloudlat.(time_of_data_collection(1,:))= ...
        ncread(inFile,'latitude',lat_max_index,lat_min_index-lat_max_index);
    cloudlon.(time_of_data_collection(1,:))= ...
        ncread(inFile,'longitude',lon_min_index,lon_max_index-lon_min_index);


    %fulltbb_07.(time_of_data_collection(1,:))=ncread(inFile,'tbb_07');
    CLTYPE.(time_of_data_collection(1,:))=ncread(inFile,'CLTYPE',start,count);

    

    catch
        fprintf('Error reading file %s\n', S(i).name);
        continue;
    end

end


%%
CLTYPE = resample_data_function(CLTYPE,75);

matfilename = [Volcano,'_',YYYYMM,DD,'_cloud','.mat'];

% specify which variables to be saved depending on what is to be read.
save(matfilename,"cloudlat","cloudlon","CLTYPE")


