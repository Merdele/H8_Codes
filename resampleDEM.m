%% Resample DEM script
% DEM was cropped in qGIS
% holes in the DEM were interpolated 

clear

addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'

Data_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/DEM/Marapi/';

DEMFileName = 's01_e100_3arc_v2_gdalfilled.tif';

DEMfiletoread = ([Data_Folder,DEMFileName]);

if exist (DEMfiletoread, 'file') == 0
    error ('File does not exist!')
end

cd(Data_Folder)
%%

[original_dem,R] = readgeoraster(DEMfiletoread,"OutputType","double");

% original_dem = double(imread('n03_e098_1arc_v3_cropped_gdalfill.tif'));

%[original_dem,R] = readgeoraster('n03_e098_1arc_v3_cropped_gdalfill.tif');


% CHANGE COORDINATES FOR DIFFERENT VOLCANOES
[lat_min, lat_max, lon_min,lon_max] = ...
    create_aoi_coords_function(-0.391642,100.457107,0.04,0.02);

%%

% Define the new geographic bounding box for resampling in terms of latitude and longitude
new_lat_limits = [lat_min, lat_max];  % Replace with your desired latitude limits
new_lon_limits = [lon_min, lon_max];  % Replace with your desired longitude limits

% Calculate the new raster reference object based on the new bounding box
% new_R = maprefcells('LatitudeLimits', new_lat_limits, 'LongitudeLimits', ...
%     new_lon_limits, 'RasterSize', size(original_dem));



% Crop the original DEM to the area of interest
[cropped_dem,cropped_R] = geocrop(original_dem, R, new_lat_limits, new_lon_limits);

% Resize the cropped DEM
[resized_dem,resized_R] = georesize(cropped_dem,cropped_R,1/24.2);

%%
figure
geoshow(original_dem,R,'DisplayType','texturemap')

figure
geoshow(cropped_dem,cropped_R,'DisplayType','texturemap')

figure
geoshow(resized_dem,resized_R,'DisplayType','texturemap')
%geoshow(all_median.tbb_07_NC_H08_20190609_14,resized_R,'DisplayType','texturemap')

%% Save the cropped and resampled DEM to a new GeoTIFF file
geotiffwrite('cropped_dem.tif', cropped_dem, cropped_R);

geotiffwrite('resampled_dem.tif', resized_dem, resized_R);
