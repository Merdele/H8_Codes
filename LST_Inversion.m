%% This script performs Inversion for H8 Data on MODIS LST Data
% The firstly the files are loaded and rearranged into N x 1 columns to
% allow for Inversion
% Inversion is then carried out
% Created by Denny on 13 Feb 2024. 

%% This section loads the MODIS files
clear
                
% add path for the create_aoi_coords function
addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'

volcano_name = 'Taal'; %change this to volcano of interest

switch volcano_name
    
    case 'Marapi'
        Volcano_lat = -0.391642;
        Volcano_lon = 100.457107;

    case 'Sinabung'
        Volcano_lat = 3.170479;
        Volcano_lon = 98.391995;

    case 'Taal'
        Volcano_lat = 14.010038;
        Volcano_lon = 120.997882;

end

%Marapi(-0.391642,100.457107,0.04,0.02)
%Sinabung(3.170479,98.391995,0.07,0.02);
%Taal(14.010038,120.997882,0.07,0.02)

modis_data_folder = (['/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/LST_Inversion/'...
    ,volcano_name,'/MODIS']);

cd(modis_data_folder)

modis_filename_struct = (dir(fullfile(modis_data_folder,[volcano_name,'*'])));

cumulative_LST = [];

start_loop = 1;

for i = start_loop:length(modis_filename_struct)

    load([modis_filename_struct(i).name])

    MODIS_lat = lat;
    MODIS_lon = lon;

    clear('lat','lon')


    switch volcano_name
        case 'Marapi'
    LST = LST(1:10,:);

    LST(LST == 0) = NaN;
    
    test = reshape(LST, [2, size(LST, 1)/2, size(LST, 2)]);

    average_LST = nanmean(test, 1);

    average_LST = squeeze(average_LST);

    resampled_LST = average_LST(:,1:5);

    resampled_LST_column = resampled_LST(:);

    nan_idx = find(resampled_LST_column == 0);

    resampled_LST_column(nan_idx) = [];

    cumulative_LST = [cumulative_LST;resampled_LST_column];

        case {'Sinabung','Taal'}
    LST = LST(1:15,:);

    LST(LST == 0) = NaN;
    
        % Keep the first row
    average_row_LST = LST(1, :);
    
    % Calculate the average of every two of the remaining rows
    for j = 2:2:size(LST, 1) - 1
        average_row_LST = [average_row_LST; mean(LST(j:j+1, :), 1)];
    end


    average_row_LST = average_row_LST(:,1:9);

        % Calculate the average of every overlapping two columns
    average_LST = zeros(size(average_row_LST, 1), size(average_row_LST, 2) - 1);

    for h = 1:size(average_row_LST, 2) - 1
        average_LST(:, h) = (average_row_LST(:, h) + average_row_LST(:, h + 1)) / 2;
    end

    resampled_LST_column = average_LST(:);

    cumulative_LST = [cumulative_LST;resampled_LST_column];


    end
end

%% This step reads the himawari data

himawari_data_folder = (['/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/LST_Inversion/'...
    ,volcano_name,'/Himawari']);

cd (himawari_data_folder)

himawari_filename_struct = (dir(fullfile(himawari_data_folder,[volcano_name,'*'])));

cumulative_T_i = [];
cumulative_T_j = [];
cumulative_T_k = [];

for k = start_loop:length(himawari_filename_struct)

load(himawari_filename_struct(k).name)


    Himawari_lat = lat;
    Himawari_lon = lon;
    
    clear('lat','lon')

fieldname = fieldnames(tbb_07);

    if length(fieldname) == 1

        T_i = tbb_13.(fieldname{1})(:);
    
        T_j = tbb_14.(fieldname{1})(:);
        
        T_k = tbb_15.(fieldname{1})(:);

    else
    
            tbb_13_a = tbb_13.(fieldname{1})(:);
            
            tbb_14_a = tbb_14.(fieldname{1})(:);
            
            tbb_15_a = tbb_15.(fieldname{1})(:);

            tbb_13_b = tbb_13.(fieldname{2})(:);
            
            tbb_14_b = tbb_14.(fieldname{2})(:);
            
            tbb_15_b = tbb_15.(fieldname{2})(:);

            T_i = (tbb_13_a + tbb_13_b) / 2;

            T_j = (tbb_14_a + tbb_14_b) / 2;

            T_k = (tbb_14_a + tbb_15_b) / 2;
   
    end

    cumulative_T_i = [cumulative_T_i;T_i];
    cumulative_T_j = [cumulative_T_j;T_j];
    cumulative_T_k = [cumulative_T_k;T_k];
    
end

%% This section cleans the data

% removes the indexes for all variables where NaN is for LST
nan_idx = isnan(cumulative_LST);

cumulative_LST(nan_idx) = [];
cumulative_T_i(nan_idx) = [];
cumulative_T_j(nan_idx) = [];
cumulative_T_k(nan_idx) = [];

%% removes indexes for all variables where BT for Ti,j,k are below 240
less_than_variable = 290;
cumulative_T_i_lessthan_idx = find(cumulative_T_i < less_than_variable);

cumulative_LST(cumulative_T_i_lessthan_idx) = [];
cumulative_T_i(cumulative_T_i_lessthan_idx) = [];
cumulative_T_j(cumulative_T_i_lessthan_idx) = [];
cumulative_T_k(cumulative_T_i_lessthan_idx) = [];

cumulative_T_j_lessthan_idx = find(cumulative_T_j < less_than_variable);

cumulative_LST(cumulative_T_j_lessthan_idx) = [];
cumulative_T_i(cumulative_T_j_lessthan_idx) = [];
cumulative_T_j(cumulative_T_j_lessthan_idx) = [];
cumulative_T_k(cumulative_T_j_lessthan_idx) = [];

cumulative_T_k_lessthan_idx = find(cumulative_T_k < less_than_variable);

cumulative_LST(cumulative_T_k_lessthan_idx) = [];
cumulative_T_i(cumulative_T_k_lessthan_idx) = [];
cumulative_T_j(cumulative_T_k_lessthan_idx) = [];
cumulative_T_k(cumulative_T_k_lessthan_idx) = [];

cumulative_LST = cumulative_LST - 273;
cumulative_T_i = cumulative_T_i - 273;
cumulative_T_j = cumulative_T_j - 273;
cumulative_T_k = cumulative_T_k - 273;


%% This section performs the inversion

% Set up the design matrix X
X = [ones(length(cumulative_T_i),1), cumulative_T_i, cumulative_T_j, cumulative_T_k];

% Compute the least squares solution
mEst = (X' * X)' * X' * cumulative_LST;


%% K fold cross validation

% Assuming your data are stored in variables data1, data2, data3, and data4

% Concatenate the data into a single matrix
data = [cumulative_LST, cumulative_T_i, cumulative_T_j, cumulative_T_k];

R = corrplot(data,'varNames',{'LST','tbb13','tbb14','tbb15'});

%%
matfilename = (['Results_of_Inversion_',volcano_name,'.mat']);

Output_Folder = (['/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/LST_Inversion/'...
    volcano_name,'/']);

% specify which variables to be saved depending on what is to be read.
save([Output_Folder,matfilename],'mEst','cumulative_LST','cumulative_T_i',...
    'cumulative_T_j','cumulative_T_k');

