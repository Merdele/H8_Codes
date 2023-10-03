%% This plots netcdf on Map

%%
clear

% add path for the create_aoi_coords function
addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'

load("testing.mat")

myStruct = tbb_07;
fieldNames = fieldnames(myStruct);
frames = cell(1, numel(fieldNames));

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
gifFileName = sprintf('Map_plots_for_%s.gif',"tbb_07");

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
