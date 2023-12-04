function [results] = performKStest_function(dataStruct,name)
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
        % mean_referenceData = mean(dataStruct.(fieldNames{i})(:));
        % sd_referenceData = std(dataStruct.(fieldNames{i})(:));
        % referenceData = (dataStruct.(fieldNames{i})(:) ...
        %     - mean_referenceData)/ sd_referenceData;

        referenceData = (dataStruct.(fieldNames{i})(:));
            

        % Get the data for the current field
        % (:) changes the netcdf data into a vector to allow kstest
        % mean_currentData = mean(dataStruct.(fieldNames{i+1})(:));
        % sd_currentData = std(dataStruct.(fieldNames{i+1})(:));
        % currentData = (dataStruct.(fieldNames{i+1})(:) ...
        %     - mean_currentData)/ sd_currentData;

        currentData = (dataStruct.(fieldNames{i+1})(:));

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

        % Create a plot to visualize the cumulative distribution functions of the two data sets
        [ecdf1, x1] = ecdf(referenceData);
        [ecdf2, x2] = ecdf(currentData);
        
        figure;
        plot(x1, ecdf1, 'b', 'LineWidth', 2);
        hold on;
        plot(x2, ecdf2, 'r', 'LineWidth', 2);
        legend('First Data', 'Second Data','Location','best');
        xlabel('X-axis Label');
        ylabel('CDF Value');
        old_title = sprintf('%s_KS-Test between %s and %s',...
            name,fieldNames{i},fieldNames{i+1});
        new_title = strrep(old_title,'_',' ');
        title(new_title)
        % title(sprintf('%s_KS-Test between %s and %s',...
        %     name,fieldNames{i},fieldNames{i+1}));

        % Save the figure as an image file (e.g., PNG)
        % fig_filename = sprintf('%s_ks_test_between %s and %s.png',...
        %     name,fieldNames{i},fieldNames{i+1});
        fig_filename = ([new_title,'.png']);
        saveas(gcf, fig_filename);

        close
                
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