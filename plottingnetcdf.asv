%% This plots netcdf on Map

%%
clear

% add path for the create_aoi_coords function
addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'


%% This Script uses create_surf_gif function to create a gif file to show a 
% time series of how the data changes

clear

load("testing.mat")

% clear("lat")
% clear("lon")
% % add path for the create_aoi_coords function
% addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'
% 
% % Get a list of variable names in the workspace
% variableNames = who;
% 
% % Loop through the variable names
% for i = 1:numel(variableNames)
%     % Get the current variable name from the list
%     currentVarName = variableNames{i};
% 
%     % Use evalin to retrieve the variable from the workspace
%     currentVarValue = evalin('base', currentVarName);
% 
%     % Call the function with the retrieved variable as an argument
%     create_surf_gif(currentVarValue, currentVarName);   
% 
% end



% Get the field names from the struct
% Get the field names from the struct
VarNames = {'tbb_07','tbb_08','tbb_09','tbb_10','tbb_11','tbb_12','tbb_13',...
    'tbb_14','tbb_15','tbb_16',};

    fieldNames = fieldnames(VarNames{1});

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

    end
%%

clear

load("testing.mat")

plot_cdf_function(tbb_07)

