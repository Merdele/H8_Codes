%% K Fold Cross Validation

clear

Data_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/LST_Inversion/';
File_to_Load = 'Results_of_Inversion.mat';
load([Data_Folder,File_to_Load])

tbl = table(cumulative_T_i,cumulative_T_j,cumulative_T_k,cumulative_LST,'VariableNames',...
    {'Predictor1','Predictor2','Predictor3','Response'});

%%

lm = fitlm(tbl, 'Response ~ Predictor1 + Predictor2 + Predictor3');

disp(lm)

coefficients = lm.Coefficients;
disp(coefficients);

%%

% Define the number of folds (k)
k = 5; % You can choose any suitable value for k

% Define cross-validation options
cv = cvpartition(size(tbl, 1), 'KFold', k);

% Perform k-fold cross-validation
mse = zeros(k, 1);
for i = 1:k
    % Create training and test sets for the current fold
    train_idx = training(cv, i);
    test_idx = test(cv, i);
    train_tbl = tbl(train_idx, :);
    test_tbl = tbl(test_idx, :);
    
    % Fit a linear model using the training set
    lm = fitlm(train_tbl, 'Response ~ Predictor1 + Predictor2 + ...');
    
    % Predict the response for the test set
    y_pred = predict(lm, test_tbl);
    
    % Calculate the mean squared error (MSE) for the current fold
    mse(i) = mean((test_tbl.Response - y_pred).^2);
end

% Calculate the average MSE across all folds
avg_mse = mean(mse);

disp(['Average MSE: ', num2str(avg_mse)]);

