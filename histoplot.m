%% Function to plot histograms for netcdf data

function histoplot(myStruct,binwidth)

% Get the field names from the struct
fieldNames = fieldnames(myStruct);

    for i = 1:numel(fieldNames)
        fieldName = fieldNames{i};
    
    figure;
    histogram(myStruct.(fieldName), 'Normalization', 'pdf', ...
        'BinWidth', binwidth); 
    title(sprintf('Probability Distribution of %s',fieldName))
    xlabel('Data Values');
    ylabel('Probability Density');
    
    end

end