function [results] = performKStest_function(dataStruct)
    % Get a list of field names in the struct
    fieldNames = fieldnames(dataStruct);

    % Define the reference dataset (e.g., the dataset you want to compare against)
    referenceData = dataStruct.(fieldNames{1})(:);

    % Initialize a structure array to store the results
    numFields = numel(fieldNames);
    results = struct('FieldName', cell(1, numFields - 1), 'Test', []);

    % Loop through the fields and perform KS tests
    for i = 1:numel(fieldNames)

        % Get the data for the current field
        % (:) changes the netcdf data into a vector to allow kstest
        currentData = dataStruct.(fieldNames{i})(:);

        % Perform the KS test to compare the current data to the reference data
        % can modify to test with other distributions
        % currently will test first data with itself
        [h, p, kstat] = kstest2(referenceData, currentData);

        % Display the results
        fprintf('KS Test for Field %s:\n', fieldNames{i});
        fprintf('KS Test Statistic: %.4f\n', kstat);
        fprintf('P-value: %.4f\n', p);

        % Store the field name and test result in the structure array
        results(i).FieldName = fieldNames{i};
        results(i).Test = h;

        if h == 1
            fprintf('The null hypothesis is rejected; the two datasets have different distributions.\n');
        else
            fprintf('The null hypothesis is not rejected; the two datasets have similar distributions.\n');
        end

        % Add a separator line between tests
        fprintf('---------------------------------------------\n');
    end
end