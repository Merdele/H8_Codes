%% This script extracts the raw data from the MODIS HDF file and resamples the 
% latlon information of the MODIS data to match the size of the Himawari-8
% data
% The area of interest is saved in a matfile.
% created by Denny on 2 Feb 2024.

% add path for the create_aoi_coords function
addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'

%% This section loads the data
clear

% ------------------------Config to change-------------
Volcano = 'Marapi';
DayNight = 'Day';

% CHANGE COORDINATES FOR DIFFERENT VOLCANOES
[lat_min, lat_max, lon_min,lon_max] = ...
    create_aoi_coords_function(-0.391642,100.457107,0.04,0.02);

%Marapi(-0.391642,100.457107,0.04,0.02)
%Sinabung(3.170479,98.391995,0.07,0.02);
%Taal(14.010038,120.997882,0.07,0.02)



Data_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/MODIS_Raw_Data/Marapi_2022-2023/';

cd(Data_Folder)

Output_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/LST_Inversion/MODIS/';

mkdir(Output_Folder)

% this creates a struct that contains the details of the files .nc files in
% the working directory. 
S = dir(fullfile(Data_Folder,'MOD11_L2*.hdf'));

%% This section reads the data 

for i = 1:length(S)
FILE_NAME = S(i).name;
file_to_read = ([Data_Folder,FILE_NAME]);

%info = hdfinfo(file_to_read);
% Inside info, will tell you what are the variable names that can be read. 
% info > Vgroups > Vgroups > SDS

try

lst_original = double(hdfread(file_to_read,'LST','Fields','ImageData'))*0.02;

lat_original = hdfread(file_to_read,'Latitude','Fields','ImageData');

lon_original = hdfread(file_to_read,'Longitude','Fields','ImageData');

%% This section resamples the latlon data to match the size of the LST data

% Assuming your data is named lat, lon, and lstData
% lat and lon are 406x271 matrices, and lstData is a 2030x1354 matrix

% Create a grid for the higher resolution LST data
[lonGrid, latGrid] = meshgrid(linspace(min(lon_original(:)), max(lon_original(:)), size(lst_original, 2)), ...
                              linspace(min(lat_original(:)), max(lat_original(:)), size(lst_original, 1)));

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

lat = lat_resized(lat_condition);
lon = lon_resized(lon_condition);
LST = lst_original(lat_condition,lon_condition);



%% This section saves the data

if any(LST(:) ~=0)

DDD = str2double(FILE_NAME(15:17));
YYYY = str2double(FILE_NAME(11:14));
HHMM = FILE_NAME(19:22);

dateObj = datetime(YYYY, 1, 1) + caldays(DDD - 1);

% Extract month and day
unformattedMM = month(dateObj);
unformattedDD = day(dateObj);

% reformats DD to have a leading 0 in the case where the day is a single
% digit
DD = sprintf('%02d', unformattedDD);
MM = sprintf('%02d', unformattedMM);

YYYYMM = [FILE_NAME(11:14),num2str(MM)];

% Output_Folder = ['/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/MODIS_Processed_Data/test/',...
% Volcano,'_',YYYYMM,'/',Volcano,'_',YYYYMM,DD,'_',DayNight,'/'];

% Output_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/LST_Inversion/MODIS/';
% 
% mkdir(Output_Folder)
cd(Output_Folder)

matfilename = [Volcano,'_',YYYYMM,DD,'_',HHMM,'_',DayNight,'.mat'];

% specify which variables to be saved depending on what is to be read.
save([Output_Folder,matfilename],"lat","lon","LST");

% catch
% 
%         fprintf('Error reading file %s\n', FILE_NAME);
% end

end

end

end



