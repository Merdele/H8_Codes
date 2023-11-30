%% BTD Calculator function

function [output] = BTD_calculator_function(tbb1,tbb2)

fieldName = fieldnames(tbb1);

output = struct();

for i = 1:length(fieldName)

    output.(fieldName{i})=tbb1.(fieldName{i})-tbb2.(fieldName{i});

end