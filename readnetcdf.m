%% Read and specify netcdf Data and Location and Saves into a .mat file
% Himawari-8/9 Data, Downloaded from Jaxa SFPT
% Reads netcdf file. Specify Data Folder
% Some netcdf files might not work and an error will be displayed
% Created by Denny 


%% This Section creates the coordinates for the area of interest to be looked at
% it then loads the data using a dir() to get the names of all the netcdf
% files in the Data Folder
clear
                
% add path for the create_aoi_coords function
addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'

%% This Section is for automatically reading all .nc files based on the folders
% inside the FullFile

FullFile = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Raw_Data';

D = dir(fullfile(FullFile,'Sinabung*_Night'));

for z = 28%1:21

YYYYMM =D(z).name(10:15);

DD=D(z).name(16:17);

%% ------------------------Config to change-------------
Volcano = 'Sinabung';
DayNight = 'Night';


% CHANGE COORDINATES FOR DIFFERENT VOLCANOES
[lat_min, lat_max, lon_min,lon_max] = ...
    create_aoi_coords_function(3.170479,98.391995,0.07,0.02);



%Marapi(-0.391642,100.457107,0.04,0.02)
%Sinabung(3.170479,98.391995,0.07,0.02);
%Taal(14.010038,120.997882,0.07,0.02)


%% ----------------------------------------------------

Data_Folder = ...
['/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Raw_Data/',...
Volcano,'_',YYYYMM,DD,'_',DayNight];


% Data_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Raw_Data/Sinabung_2019';

Output_Folder = ['/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Processed_Data/',...
Volcano,'_',YYYYMM,'/',Volcano,'_',YYYYMM,DD,'_',DayNight,'/'];

% Output_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/LST_Inversion/Taal/Himawari/';

% Output_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Processed_Data/Sinabung_2019/';

mkdir(Output_Folder)

cd(Data_Folder)


% this creates a struct that contains the details of the files .nc files in
% the working directory. 
S = dir(fullfile(Data_Folder,'NC*.nc'));


%% This Section Loops and saves the data in a .mat file
% TO CHECK WHAT DATA CAN BE LOADED RUN
% ncdisp(NCFILENAME.nc) in the command window


% loops to read and load the netcdf data
for i = 1:length(S)
    try
    % creates the string of the .nc file to be read
    inFile=[S(i).folder,'/',S(i).name];

    % Indexes out the date and time contained within the string for naming
    % purposes
    time_of_data_collection = (S(i).name(1:20));

    % Saving latitude, longtitude, tbb into structs, categorised by fields
    % labelled as the file name(i.e. time of data collection)
    fulllat.(time_of_data_collection(1,:))= ...
        ncread(inFile,'latitude');
    fulllon.(time_of_data_collection(1,:))= ...
        ncread(inFile,'longitude');

    % Finding the indexes of the latitude and longitude at the corners of
    % the AOI from the .nc file
    % the reason >= and <= is used here is due to floating point rounding errors
    lat_condition = (fulllat.(time_of_data_collection(1,:)) >= lat_min - 0.01) & ...
        (fulllat.(time_of_data_collection(1,:)) <= lat_max + 0.01);

    lat_min_index = find(lat_condition,1,'last');
    lat_max_index = find(lat_condition,1,'first');

    lon_condition = (fulllon.(time_of_data_collection(1,:)) >= lon_min - 0.01) & ...
        (fulllon.(time_of_data_collection(1,:)) <= lon_max + 0.01);

    lon_min_index = find(lon_condition,1,'first');
    lon_max_index = find(lon_condition,1,'last');

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
    SAZ.(time_of_data_collection(1,:))=ncread(inFile,'SAZ',start,count);
    SAA.(time_of_data_collection(1,:))=ncread(inFile,'SAA',start,count);
    SOZ.(time_of_data_collection(1,:))=ncread(inFile,'SOZ',start,count);
    SOA.(time_of_data_collection(1,:))=ncread(inFile,'SOA',start,count);
    % OTHER PARAMETERS THAT YOU CAN CHOOSE TO LOAD
    % TO CHECK WHAT DATA CAN BE LOADED RUN
    % ncdisp(NCFILENAME.nc) in the command window
    %
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

HHMM = time_of_data_collection(17:20);

matfilename = [Volcano,'_',YYYYMM,DD,'_',HHMM,'_',DayNight,'.mat'];

matfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'.mat'];

% specify which variables to be saved depending on what is to be read.
save([Output_Folder,matfilename],"lat","lon","tbb_07","tbb_08","tbb_09"...
    ,"tbb_10","tbb_11","tbb_12","tbb_13","tbb_14","tbb_15","tbb_16","SAZ",...
    "SOA","SAA","SOZ");

% clear("lat","lon","tbb_07","tbb_08","tbb_09"...
%     ,"tbb_10","tbb_11","tbb_12","tbb_13","tbb_14","tbb_15","tbb_16","SAZ",...
%     "SOA","SAA","SOZ")



end

