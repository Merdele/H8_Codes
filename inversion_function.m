%% Inversion function

function [beta] = inversion_function(data,myStruct1,myStruct2,myStruct3)

D = data(:);

find(D==NaN;)

T_i = myStruct1(:);

T_j = myStruct2(:);

T_k = myStruct3(:);

% Set up the design matrix X
X = [ones(length(T_i),1), T_i, T_j, T_k];

% Compute the least squares solution
beta = (X' * X)' * X' * D;

end