%% Function to plot netcdf data that has been read and saved in .mat files after
% running readnetcdf.mat
% created by Denny on 3rd October 2023.

function plot_cdf_function(myStruct)
    % Get the field names from the struct
    fieldNames = fieldnames(myStruct);

    % Loop through the fields and capture frames
    for i = 1:numel(fieldNames)
    fieldName = fieldNames{i};
    
    % Create a meshgrid of latitude and longitude values
    [lon_grid, lat_grid] = meshgrid(lon.(fieldName), lat.(fieldName));
    data = myStruct.(fieldName);

    figure;
    pcolor(lon_grid, lat_grid, data);
    shading flat;  % Ensure flat shading for pseudocolor plot
    colormap('jet');  % Set colormap (adjust as needed)
    colorbar;  % Add a colorbar
    title('NetCDF Data on Map');
    xlabel('Longitude');
    ylabel('Latitude');

    % % Create the pseudocolor plot
    % figure;
    % worldmap;  % Display a world map
    % geoshow(lat_grid, lon_grid, data, 'DisplayType', 'texturemap');
    % colorbar;
    % title(['NetCDF Data (' varName ') on Geographic Map']);
    end
end

