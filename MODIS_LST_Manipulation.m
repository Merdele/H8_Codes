%%

%% This section loads the data
clear

% ------------------------Config to change-------------
Volcano = 'Marapi';
YYYYMM = '202311';
DD = '03';
DayNight = 'Day';

% CHANGE COORDINATES FOR DIFFERENT VOLCANOES
[lat_min, lat_max, lon_min,lon_max] = ...
    create_aoi_coords_function(-0.391642,100.457107,0.04,0.02);

%Marapi(-0.391642,100.457107,0.04,0.02)
%Sinabung(3.170479,98.391995,0.07,0.02);
%Taal(14.010038,120.997882,0.07,0.02)

% add path for the create_aoi_coords function
addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'

FILE_NAME = 'MOD11_L2.A2023305.0325.061.2023307190626.hdf';

info = hdfinfo(FILE_NAME);

lst = double(hdfread(FILE_NAME,'LST','Fields','ImageData'))*0.02;

lat = hdfread(FILE_NAME,'Latitude','Fields','ImageData');

lon = hdfread(FILE_NAME,'Longitude','Fields','ImageData');

%% This section resamples the latlon data to match the size of the LST data

% Assuming your data is named lat, lon, and lstData
% lat and lon are 406x271 matrices, and lstData is a 2030x1354 matrix

% Create a grid for the higher resolution LST data
[lonGrid, latGrid] = meshgrid(linspace(min(lon(:)), max(lon(:)), size(lst, 2)), ...
                              linspace(min(lat(:)), max(lat(:)), size(lst, 1)));

lat_resized = flipud(latGrid(:,1));
lon_resized = lonGrid(1,:);


% Finding the indexes of the latitude and longitude at the corners of
% the AOI from the .nc file
% the reason >= and <= is used here is due to floating point rounding errors
lat_condition = (lat_resized >= lat_min - 0.01) & ...
    (lat_resized <= lat_max + 0.01);
    lon_condition = (lon_resized >= lon_min - 0.01) & ...
    (lon_resized <= lon_max + 0.01);

% finding the position of the minimum and maximum latlon value
lat_min_index = find(lat_condition,1,'last');
lat_max_index = find(lat_condition,1,'first');
lon_min_index = find(lon_condition,1,'first');
lon_max_index = find(lon_condition,1,'last');


lat_aoi = lat_resized(lat_condition);
lon_aoi = lon_resized(lon_condition);
lst_aoi = lst(lat_condition,lon_condition);

%% This section saves the data

DDD = str2double(FILE_NAME(15:17));
YYYY= str2double(FILE_NAME(11:14));

dateObj = datetime(YYYY, 1, 1) + caldays(DDD - 1);

% Extract month and day
MM = month(dateObj);
DD = day(dateObj);

formattedDD = sprintf('%02d', DD);

YYYYMM = [FILE_NAME(11:14),num2str(MM)];


Output_Folder = ['/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/MODIS_Processed_Data/',...
Volcano,'_',YYYYMM,'/',Volcano,'_',YYYYMM,formattedDD,'_',DayNight,'/'];

%%
mkdir(Output_Folder)

matfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'.mat'];

% specify which variables to be saved depending on what is to be read.
save([Output_Folder,matfilename],"lat","lon","tbb_07","tbb_08","tbb_09"...
    ,"tbb_10","tbb_11","tbb_12","tbb_13","tbb_14","tbb_15","tbb_16","SAZ",...
    "SOA","SAA","SOZ");









