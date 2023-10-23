%% This plots netcdf on figure Map
% 1.5th step ( to visualise data )
% Trying to get it to work using function instead but having difficulties
% created by Denny on 3rd October 2023.

%%
clear

% add path for the create_aoi_coords function
addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'

load("Sinabung_20190609_Night.mat")

% hardcoded to list out the names of variables I want to plot.
varnames={'tbb_07','tbb_08','tbb_09','tbb_10','tbb_11','tbb_12','tbb_13',...
    'tbb_14','tbb_15','tbb_16'};

for k = 1:length(varnames)

currentVarValue = evalin('base', varnames{k});
myStruct = currentVarValue;
fieldNames = fieldnames(myStruct);
frames = cell(1, numel(fieldNames)); % for gif

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

    title(['NetCDF Data on Map ',fieldName]);
    xlabel('Longitude');
    ylabel('Latitude');

    % Capture the frame
    frames{i} = getframe(gcf);

    end



    % Create the GIF
    for i = 1:numel(frames)
    % Create a GIF from captured frames
    gifFileName = sprintf('Map_plots_for_%s.gif',varnames{k});
    
    % Set the delay between frames (in seconds)
    frameDelay = 0.5; % Adjust as needed
    
        im = frame2im(frames{i});
        [A, map] = rgb2ind(im, 256);
        if i == 1
            imwrite(A, map, gifFileName, 'gif', 'Loopcount', inf, ...
                'DelayTime', frameDelay);
        else
            imwrite(A, map, gifFileName, 'gif', 'WriteMode', 'append', ...
                'DelayTime', frameDelay);
        end
    end

end


