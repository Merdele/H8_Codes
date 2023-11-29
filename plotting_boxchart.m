%% Boxplots
% current version of the code plots all the data in the tbb_07 etc as one
% whole boxchart.

clear

addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'

%------------------------Config to change-------------

Volcano = 'Sinabung';
YYYYMM = '201906';
DD = '09';
DayNight = 'Night';

%------------------------------------------------------

%DEM_Data_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/DEM/Sinabung/';

Matfile_Data_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Processed_Data/';

%DEMFileName = 'resampled_dem.tif';

foldername = [Volcano,'_',YYYYMM,'/',Volcano,'_',YYYYMM,DD,'_',DayNight];
matfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'.mat'];
%matfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'_Median.mat'];
%stackfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'_Stacked.mat'];



%DEMfiletoread = ([DEM_Data_Folder,DEMFileName]);
matfiletoread = ([Matfile_Data_Folder,'/',foldername,'/',matfilename]);
%stackfiletoread = ([Matfile_Data_Folder,'/',foldername,'/',stackfilename]);

%[DEM,R] = readgeoraster(DEMfiletoread,"OutputType","double");
load(matfiletoread)
%load(stackfiletoread)

%mkdir([Matfile_Data_Folder,foldername,'/Boxcharthours'])
cd([Matfile_Data_Folder,foldername,'/Boxcharthours'])

%%

variableNames = {'tbb_07','tbb_08','tbb_09','tbb_10','tbb_11','tbb_12',...
    'tbb_13','tbb_14','tbb_15','tbb_16'};

hours = {'14','15','16','17','18','19','20','21','22','23'};
%%
for k = 1%:length(variableNames)

currentVarName = variableNames{k};

currentVarValue = evalin('base', currentVarName);

myStruct = currentVarValue;

tbb_fieldName = fieldnames(myStruct);

for L = 1:length(hours)

hour_to_index = hours{L};

    % creates the character array that i want to to compare from each field
    % the hour will be the identifier
    containsName = (['NC_H08_',YYYYMM,DD,'_',hour_to_index]);
   
    % uses contain to get the logical index of where the 
    hour_idx = contains(tbb_fieldName,containsName);

    % indexes the fieldnames that is specified by the hour
    fieldName = tbb_fieldName(hour_idx);

NWData = [];
NData = [];
NEData = [];
WData = [];
EData = [];
SWData = [];
SData = [];
SEData = [];

NWPositions = [5,4;4,3;3,2;2,1];

NEPositions = [5,4;4,5;3,6;2,7];

SWPositions = [5,4;6,3;7,2;8,1];

SEPositions = [5,4;6,5;7,6;8,7];

%%
    for i = 1:length(fieldName)
    
        NW = myStruct.(fieldName{i})...
            (sub2ind(size(myStruct.(fieldName{i})), ...
            NWPositions(:, 1),NWPositions(:, 2)));
        NWData= [NWData; NW'];
    
        N = flip(myStruct.(fieldName{i})(2:5,4));
        NData = [NData;N'];
    
        NE = myStruct.(fieldName{i})...
            (sub2ind(size(myStruct.(fieldName{i})), ...
            NEPositions(:, 1),NEPositions(:, 2)));
        NEData= [NEData; NE'];
    
        W = flip(myStruct.(fieldName{i})(5,1:4));
        WData = [WData;W];
    
        E = myStruct.(fieldName{i})(5,4:7);
        EData = [EData;E];
    
        SW = myStruct.(fieldName{i})...
            (sub2ind(size(myStruct.(fieldName{i})), ...
            SWPositions(:, 1),SWPositions(:, 2)));
        SWData= [SWData; SW'];
    
        S = myStruct.(fieldName{i})(5:8,4);
        SData = [SData;S'];
    
        SE = myStruct.(fieldName{i})...
            (sub2ind(size(myStruct.(fieldName{i})), ...
            SEPositions(:, 1),SEPositions(:, 2)));
        SEData= [SEData; SE'];
    
    end



%%
figure('WindowState','maximized')
tiledlayout(3,3)
subplot_positions = [1 2 3 4 6 7 8 9];

nexttile(subplot_positions(1))
boxchart(NWData)
title([strrep(variableNames{k},'_',' '),' NW'])


nexttile(subplot_positions(2))
boxchart(NData)
title([strrep(variableNames{k},'_',' '),' N'])


nexttile(subplot_positions(3))
boxchart(NEData)
title([strrep(variableNames{k},'_',' '),' NE'])

nexttile(subplot_positions(4))
boxchart(WData)
title([strrep(variableNames{k},'_',' '),' W'])


nexttile(subplot_positions(5))
boxchart(EData)
title([strrep(variableNames{k},'_',' '),' E'])

nexttile(subplot_positions(6))
boxchart(SWData)
title([strrep(variableNames{k},'_',' '),' SW'])


nexttile(subplot_positions(7))
boxchart(SData)
title([strrep(variableNames{k},'_',' '),' S'])

nexttile(subplot_positions(8))
boxchart(SEData)
title([strrep(variableNames{k},'_',' '),' SE'])

fig_filename = ([strrep(variableNames{k},'_',' '),' ',hours{L},'H boxcharts.png']);
saveas(gcf, fig_filename);
close

%clear("NWData","NData","NEData","WData","EData","SWData","SData","SEData")

end

end