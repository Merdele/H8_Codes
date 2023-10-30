function [results] = performKStest_function(dataStruct)
    % Get a list of field names in the struct
    fieldNames = fieldnames(dataStruct);

    % Define the reference dataset (e.g., the dataset you want to compare against)
    %referenceData = dataStruct.(fieldNames{1})(:);

    % Initialize a structure array to store the results
    numFields = numel(fieldNames);
    results = struct('FieldName', cell(1, numFields - 1), 'Test', []);

    % emptyMatrix = zeros(numel(fieldNames)-1, 2);
    % 
    % % Define the column names
    % columnNames = {'ReferenceData', 'Result'};
    % 
    % % Create a table with labeled columns
    % results = array2table(emptyMatrix, 'VariableNames', columnNames);

    % Loop through the fields and perform KS tests
    for i = 1:numel(fieldNames)-1

        % Define the reference dataset (e.g., the dataset you want to compare against)
        mean_referenceData = mean(dataStruct.(fieldNames{i})(:));
        sd_referenceData = std(dataStruct.(fieldNames{i})(:));
        referenceData = (dataStruct.(fieldNames{i})(:) ...
            - mean_referenceData)/ sd_referenceData;
            

        % Get the data for the current field
        % (:) changes the netcdf data into a vector to allow kstest
        mean_currentData = mean(dataStruct.(fieldNames{i+1})(:));
        sd_currentData = std(dataStruct.(fieldNames{i+1})(:));
        currentData = (dataStruct.(fieldNames{i+1})(:) ...
            - mean_currentData)/ sd_currentData;

        % Perform the KS test to compare the current data to the reference data
        % can modify to test with other distributions
        % currently will test every pairs of 10min interval
        [h, p, kstat] = kstest2(referenceData, currentData);

        % % Display the results
        % fprintf('KS Test between Field %s & %s:\n', fieldNames{i},...
        %     fieldNames{i+1} );
        % fprintf('KS Test Statistic: %.4f\n', kstat);
        % fprintf('P-value: %.4f\n', p);

        % Store the field name and test result in the structure array
        results(i).FieldName = fieldNames{i};
        results(i).Test = h;
        results(i).PValue = p;
        results(i).Kstat = kstat;
        
        % if h == 1
        %     fprintf('The null hypothesis is rejected; the two datasets have different distributions.\n');
        % else
        %     fprintf('The null hypothesis is not rejected; the two datasets have similar distributions.\n');
        % end
        % 
        % % Add a separator line between tests
        % fprintf('---------------------------------------------\n');
    end
end