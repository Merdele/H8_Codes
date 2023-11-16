%% Resample DEM script
% DEM was cropped in qGIS
% holes in the DEM were interpolated 

[original_dem,R] = readgeoraster('n03_e098_1arc_v3_cropped_gdalfill.tif',"OutputType","double");

% original_dem = double(imread('n03_e098_1arc_v3_cropped_gdalfill.tif'));

%[original_dem,R] = readgeoraster('n03_e098_1arc_v3_cropped_gdalfill.tif');


% CHANGE COORDINATES FOR DIFFERENT VOLCANOES
[lat_min, lat_max, lon_min,lon_max] = ...
    create_aoi_coords_function(3.17,98.392,0.5,0.5);

%%

% Define the new geographic bounding box for resampling in terms of latitude and longitude
new_lat_limits = [lat_min, lat_max];  % Replace with your desired latitude limits
new_lon_limits = [lon_min, lon_max];  % Replace with your desired longitude limits

% Calculate the new raster reference object based on the new bounding box
new_R = maprasterref('LatitudeLimits', new_lat_limits, 'LongitudeLimits', new_lon_limits, ...
    'RasterSize', size(original_dem));

% Crop the original DEM to the area of interest
cropped_dem = mapcrop(original_dem, R, new_lat_limits, new_lon_limits);

% Define the new size for the resampled DEM
new_size = [75, 75];  % Replace with your desired dimensions

% Resample the cropped DEM to the desired size
resampled_dem = imresize(cropped_dem, new_size);

% Display the resampled DEM
figure;
mapshow(resampled_dem, new_R);
title('Resampled DEM');

% Optionally, save the resampled DEM to a new GeoTIFF file
geotiffwrite('resampled_dem.tif', resampled_dem, new_R);