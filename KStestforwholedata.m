%% This Script performs the KS test for a whole day's worth of Data
% between two consecutive days worth of data that was downloaded. To check
% what timing of data has been downloaded, open the tbb_13_15 files

clear

% add path for the create_aoi_coords function
addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'
Data_Folder = ...
'/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Processed_Data/';

%------------------------Config to change-------------
Volcano = 'Sinabung';
YYYYMM = '201906';
DD = {'02','03','04'};
DayNight = 'Night';

mkdir([Data_Folder,'/',Volcano,'_',YYYYMM,'/NIGHT_KSTEST'])
cd([Data_Folder,'/',Volcano,'_',YYYYMM,'/NIGHT_KSTEST'])

%------------------------------------------------------
for k = 1:length(DD)-1

beforeFoldername = [Volcano,'_',YYYYMM,'/',Volcano,'_',YYYYMM,DD{k},'_',DayNight];
afterFoldername = [Volcano,'_',YYYYMM,'/',Volcano,'_',YYYYMM,DD{k+1},'_',DayNight];
beforeMatfilename = [Volcano,'_',YYYYMM,DD{k},'_',DayNight,'.mat'];
afterMatfilename = [Volcano,'_',YYYYMM,DD{k+1},'_',DayNight,'.mat'];

% beforeFoldername = [Volcano,'_202311/',Volcano,'_20231130_',DayNight];
% afterFoldername = [Volcano,'_202312/',Volcano,'_20231201_',DayNight];
% beforeMatfilename = [Volcano,'_20231130_',DayNight,'.mat'];
% afterMatfilename = [Volcano,'_20231201_',DayNight,'.mat'];

% % check if file exists
% if exist ([Data_Folder,foldername,'/',matfilename], 'file') == 0
%     error ('File does not exist!')
% end

load([Data_Folder,beforeFoldername,'/',beforeMatfilename])

clear("lat")
clear("lon")

% mkdir([Data_Folder,foldername,'/KSTestBTD'])
% cd([Data_Folder,foldername,'/KSTestBTD'])

%%

% tbb_13_14_before = tbb_13_14;
% tbb_13_15_before = tbb_13_15;
% tbb_14_15_before = tbb_14_15;
% tbb_7_13_before = tbb_7_13;
% 
% clear("tbb_7_13","tbb_14_15","tbb_13_15","tbb_13_14")
% 
% load([Data_Folder,afterFoldername,'/',afterMatfilename])
% 
% tbb_13_14_after = tbb_13_14;
% tbb_13_15_after = tbb_13_15;
% tbb_14_15_after = tbb_14_15;
% tbb_7_13_after = tbb_7_13;
% 
% 
% before_variableNames = {'tbb_13_15_before','tbb_7_13_before',...
%     'tbb_13_14_before','tbb_14_15_before'};
% 
% after_variableNames = {'tbb_13_15_after','tbb_7_13_after',...
%     'tbb_13_14_after','tbb_14_15_after'};

tbb_07_before = tbb_07;
tbb_08_before = tbb_08;
tbb_09_before = tbb_09;
tbb_10_before = tbb_10;
tbb_11_before = tbb_11;
tbb_12_before = tbb_12;
tbb_13_before = tbb_13;
tbb_14_before = tbb_14;
tbb_15_before = tbb_15;
tbb_16_before = tbb_16;

clear("tbb_07","tbb_08","tbb_09","tbb_10","tbb_11","tbb_12","tbb_13",...
    "tbb_14","tbb_15","tbb_16")

load([Data_Folder,afterFoldername,'/',afterMatfilename])

tbb_07_after = tbb_07;
tbb_08_after = tbb_08;
tbb_09_after = tbb_09;
tbb_10_after = tbb_10;
tbb_11_after = tbb_11;
tbb_12_after = tbb_12;
tbb_13_after = tbb_13;
tbb_14_after = tbb_14;
tbb_15_after = tbb_15;
tbb_16_after = tbb_16;


% before_variableNames = {'tbb_07_before','tbb_08_before','tbb_09_before',...
%     'tbb_10_before','tbb_11_before','tbb_12_before','tbb_13_before',...
%     'tbb_14_before','tbb_15_before','tbb_16_before'};
% 
% after_variableNames = {'tbb_07_after','tbb_08_after','tbb_09_after',...
%     'tbb_10_after','tbb_11_after','tbb_12_after','tbb_13_after',...
%     'tbb_14_after','tbb_15_after','tbb_16_after'};
% 
% variableNames = {'tbb_07','tbb_08','tbb_09',...
%     'tbb_10','tbb_11','tbb_12','tbb_13',...
%     'tbb_14','tbb_15','tbb_16'};

before_variableNames = {'tbb_07_before'};

after_variableNames = {'tbb_07_after'};

variableNames = {'tbb_07'};



for i = 1:length(before_variableNames)
    
    % Get the current variable name from the list
    beforeVarName = before_variableNames{i};
    
    % Use evalin to retrieve the variable from the workspace
    beforeVarValue = evalin('base', beforeVarName);

    beforeStruct = beforeVarValue;

        % Get the current variable name from the list
    afterVarName = after_variableNames{i};
    
    % Use evalin to retrieve the variable from the workspace
    afterVarValue = evalin('base', afterVarName);

    afterStruct = afterVarValue;

    beforefieldName = fieldnames(beforeStruct);

    afterfieldName = fieldnames(afterStruct);

    beforeCat = [];
    afterCat = [];

    for j = 1:length(beforefieldName)

    beforeCat = [beforeCat;beforeStruct.(beforefieldName{j})(:)];

    end

    for j = 1:length(afterfieldName)
    
    afterCat = [afterCat;afterStruct.(afterfieldName{j})(:)];

    end

    referenceData = beforeCat(:) - 273;
    currentData = afterCat(:) - 273;

     % Perform the KS test to compare the current data to the reference data
        % can modify to test with other distributions
        % currently will test every pairs of 10min interval
        [h, p, kstat] = kstest2(referenceData, currentData);

        % % Display the results
        % fprintf('KS Test between Field %s & %s:\n', fieldNames{i},...
        %     fieldNames{i+1} );
        % fprintf('KS Test Statistic: %.4f\n', kstat);
        % fprintf('P-value: %.4f\n', p);

        % % Store the field name and test result in the structure array
        % results(i).FieldName = fieldNames{i};
        % results(i).Test = h;
        % results(i).PValue = p;
        % results(i).Kstat = kstat;

        % Create a plot to visualize the cumulative distribution functions of the two data sets
        [ecdf1, x1] = ecdf(referenceData);
        [ecdf2, x2] = ecdf(currentData);
        
        figure;
        plot(x1, ecdf1, 'b', 'LineWidth', 2);
        hold on;
        plot(x2, ecdf2, 'r', 'LineWidth', 2);
        legend('Day Before', 'Day After','Location','best');
        xlabel('Brightness Temperature (Celsius)');
        ylabel('CDF Value');
        old_title = sprintf('%s_KS-Test between %s and %s',variableNames{i},...
            ([Volcano,'_',YYYYMM,DD{k}]),...
            ([Volcano,'_',YYYYMM,DD{k+1}]));
            %     old_title = sprintf('%s_KS-Test between %s and %s',variableNames{i},...
            % ([Volcano,'_20231130']),...
            % ([Volcano,'_20231201']));
        new_title = strrep(old_title,'_',' ');
        title([new_title,'. N=',num2str(length(currentData))])

        % Save the figure as an image file (e.g., PNG)
        % fig_filename = ([new_title,'.png']);
        % saveas(gcf, fig_filename);
        % 
        % close


end

end