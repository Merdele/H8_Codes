%% This function creates a square area of interest using a point coordinate
% as an input. Inputs are the lat and lon coordinates in DECIMAL DEGREES
% and half the square size (i.e if want 2 units big, specify 1 unit
% The output will be four coordinates that create a square area of interest

% E.g. [lat_min, lat_max, lon_min,lon_max] = ...
%   create_aoi_coords(-7.540718,110.445723,1,0.05)

% Expected Output
% lat_min = -8.5500
% lat_max = -6.5000
% lon_min = 109.4000
% lon_max = 111.4500

%% Function starts here.

function [lat_min, lat_max, lon_min,lon_max] = ...
    create_aoi_coords_function(lat_point,lon_point,squareSize,roundingFactor)

% Calculate the coordinates of the four points forming the square
lat_min = lat_point - squareSize;
lat_max = lat_point + squareSize;
lon_min = lon_point - squareSize;
lon_max = lon_point + squareSize;

% Rounds down for minimum using floor
% Rounds up for maximum using ceil
lat_min = roundingFactor * floor(lat_min / roundingFactor);
lat_max = roundingFactor * ceil(lat_max / roundingFactor);
lon_min = roundingFactor * floor(lon_min / roundingFactor);
lon_max = roundingFactor * ceil(lon_max / roundingFactor);
end

