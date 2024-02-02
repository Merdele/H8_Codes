%% BTD Calculator function

function [output] = BTD_ratio_function(tbb1,tbb2)

fieldName = fieldnames(tbb1);

output = struct();

for i = 1:length(fieldName)

    output.(fieldName{i})=tbb1.(fieldName{i})/tbb2.(fieldName{i});

end