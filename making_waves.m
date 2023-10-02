%% This Script uses create_surf_gif function to create a gif file to show a 
% time series of how the data changes

clear

load("testing.mat")

clear("lat")
clear("lon")
% add path for the create_aoi_coords function
addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'

% Get a list of variable names in the workspace
variableNames = who;

% Loop through the variable names
for i = 1:numel(variableNames)
    % Get the current variable name from the list
    currentVarName = variableNames{i};
    
    % Use evalin to retrieve the variable from the workspace
    currentVarValue = evalin('base', currentVarName);
    
    % Call the function with the retrieved variable as an argument
    create_surf_gif(currentVarValue, currentVarName);   

end

