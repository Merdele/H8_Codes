%% Read and specify netcdf Data and Location and Saves into a .mat file
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

[lat_min, lat_max, lon_min,lon_max] = ...
    create_aoi_coords(-7.540718,110.445723,0.5,0.5);

% specifies the data folder
Data_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Raw_Data/Merapi_20230311';
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

% specify which variables to be saved depending on what is to be read.
save("testing.mat","lat","lon","tbb_07","tbb_08","tbb_09"...
    ,"tbb_10","tbb_11","tbb_12","tbb_13","tbb_14","tbb_15","tbb_16")

%%
% figure
% surf(tbb_07.NC_H09_20230720_0010)
% title('band 7')
% figure
% surf(tbb_14.NC_H09_20230720_0010)
% title('band 14')
% figure
% surf(tbb_15.NC_H09_20230720_0010)
% title('band 15')
%% 

% format bank
% 
% roundingFactor = 0.05;
% 
% %lat.(time_of_data_collection(1,:))
% ans=roundingFactor * ...
%             round(lat.(time_of_data_collection(1,:)) / roundingFactor);
% 

