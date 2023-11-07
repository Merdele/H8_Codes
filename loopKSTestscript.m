%% This Script uses create_surf_gif function to create a gif file to show a 
% time series of how the data changes
% 1.5th step ( to visualise data )
% uses create_surf_gif function
% created by Denny. Last updated 3 October 2023.

clear

% add path for the create_aoi_coords function
addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'
Data_Folder = ...
'/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Raw_Data/';

%------------------------Config to change-------------
Volcano = 'Sinabung';
YYYYMM = '201906';
DD = '09';
DayNight = 'Night';

%------------------------------------------------------
foldername = [Volcano,'_',YYYYMM,DD,'_',DayNight];
matfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'.mat'];

cd([Data_Folder,foldername])

% check if file exists
if exist ([Data_Folder,foldername,'/',matfilename], 'file') 
    load (matfilename)
else
    error ('File does not exist!')
end

clear("lat")
clear("lon")
%%

% Get a list of variable names in the workspace
variableNames = who;

% Loop through the variable names
for i = 1:numel(variableNames)
    try
    % Get the current variable name from the list
    currentVarName = variableNames{i};
    
    % Use evalin to retrieve the variable from the workspace
    currentVarValue = evalin('base', currentVarName);
    
    % Call the create_surf_gif function with the retrieved variable as an argument
    %create_surf_gif(currentVarValue, currentVarName);

    % call histoplot function
    %histoplot(currentVarValue,1)

    KSTestResults.(variableNames{i}) = ...
        performKStest_function(currentVarValue); % [variableNames{2},'_KSTest']

    end

end


ksfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'KSTest.mat'];

% specify which variables to be saved depending on what is to be read.
save(ksfilename,"KSTestResults")
