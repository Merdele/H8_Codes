%% This script performs Inversion for H8 Data on MODIS LST Data
%
%
% Created by Denny on 13 Feb 2024. 

%% First step is to make the data overlap based on their Lat and Lon.

load('Marapi_20231110_0300_Day_H8.mat')

H8_lat = lat;
H8_lon = lon;

load('Marapi_20231110_0300_Day_Modis.mat')

MODIS_lat = lat;
MODIS_lon = lon;

clear('lat','lon')




%% Inversion 