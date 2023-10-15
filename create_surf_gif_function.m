%% Function to create gif of Surf Plots
% credit to ChatGPT
% edited by Denny

function create_surf_gif_function (myStruct,gifname)

% Get the field names from the struct
fieldNames = fieldnames(myStruct);

% Initialize a cell array to store the frames
frames = cell(1, numel(fieldNames));

% Loop through the fields and capture frames
for i = 1:numel(fieldNames)
    fieldName = fieldNames{i};
    
    % Create a new figure for each field
    figure;

    
    
    % Create a surf plot for the data in the current field
    surf(myStruct.(fieldName));
    
    % Customize plot properties (title, labels, etc.) as needed
    title(['Surf Plot for ' fieldName]);
    xlabel('X-axis');
    ylabel('Y-axis');
    zlabel('Z-axis');
    
    % Capture the frame
    frames{i} = getframe(gcf);
end

% Create a GIF from captured frames
gifFileName = sprintf('surf_plots_for_%s.gif',gifname);

% Set the delay between frames (in seconds)
frameDelay = 0.5; % Adjust as needed

% Create the GIF
for i = 1:numel(frames)
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