%% This function resamples a X by X data into a Y by Y data
% it takes structs as an input

function resampledStruct = resample_data_function(inputStruct, newSize)
    % Initialize the result struct
    resampledStruct = struct();

    % Loop through all fields in the input struct
    fieldNames = fieldnames(inputStruct);
    for i = 1:numel(fieldNames)
        fieldName = fieldNames{i};
        originalData = inputStruct.(fieldName);
        
        % Create X and Y coordinates for the new grid
        [xq, yq] = meshgrid(linspace(1, size(originalData, 1), newSize), ...
            linspace(1, size(originalData, 2), newSize));
        
        % Create X and Y coordinates for the original data
        [xx, yy] = meshgrid(1:size(originalData, 1), 1:size(originalData, 2));
        
        % Perform bilinear interpolation to resample the data
        resampledData = interp2(xx, yy, originalData, xq, yq, 'nearest');
        
        % Assign the resampled data to the result struct
        resampledStruct.(fieldName) = resampledData;
    end
end