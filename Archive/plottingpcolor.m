%% This script plots a pcolour plot of BT data from 1am-5am over a few days


clear
                
% add path for the create_aoi_coords function
addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'

%---------Config to change--------
% Change the details for the specific event - the file directory will be
% saved according to the following variables
Volcano = 'Marapi';
YYYYMM = '202311';
DD = {'18','19','20','21','22','23','24','25',...
    '26','27','28','29','30'};
% 
% {'01','02','03','04','05','06','07','08','09','10','11','12',...
%     '13','14','15','16','17','18','19','20','21','22','23','24','25',...
%     '26','27','28','29','30','31'};

% Marapi UTC +7

% only important for when downloading Day time and Night time acquisitions
% separately 
DayNight = 'Night';

Matfile_Data_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Processed_Data/';

dataDAY = [];


tbb07_pcolor = []; 
tbb08_pcolor = []; 
tbb09_pcolor = []; 
tbb10_pcolor = []; 
tbb11_pcolor = []; 
tbb12_pcolor = []; 
tbb13_pcolor = []; 
tbb14_pcolor = []; 
tbb15_pcolor = []; 
tbb16_pcolor = []; 

for i = 1:length(DD)

foldername = [Volcano,'_',YYYYMM,'/',Volcano,'_',YYYYMM,DD{i},'_',DayNight];
matfilename = [Volcano,'_',YYYYMM,DD{i},'_',DayNight,'.mat'];
%matfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'_Median.mat'];
%stackfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'_Stacked.mat'];

matfiletoread = ([Matfile_Data_Folder,'/',foldername,'/',matfilename]);
%stackfiletoread = ([Matfile_Data_Folder,'/',foldername,'/',stackfilename]);

load(matfiletoread)
%load(stackfiletoread)

cd([Matfile_Data_Folder,foldername])

variableNames = {'tbb_07','tbb_08','tbb_09','tbb_10','tbb_11','tbb_12',...
    'tbb_13','tbb_14','tbb_15','tbb_16',};

    for k = 3%1:length(variableNames)

        % Get the current variable name from the list
        VarName = variableNames{k};
        
        % Use evalin to retrieve the variable from the workspace
        VarValue = evalin('base', VarName);
    
        myStruct = VarValue;
    
        fieldname= fieldnames(myStruct);

        hours = {'1800','1810','1820','1830','1840','1850',...
       '1900','1910','1920','1930','1940','1950',...
        '2000','2010','2020','2030','2040','2050',...
        '2100','2110','2120','2130','2140','2150',...
        '2200'};

            for j = 1:length(hours)

                % add in a line if field name == XXXX exists --- 
                % else - BT data = 0

                hour_to_index = hours{j};

                containsName = (['NC_H09_',YYYYMM,DD{i},'_',hour_to_index]);
               
                % this section accounts for missing data and puts 0 in its
                % place

                try
    
                BTdata = myStruct.(containsName)(3,3);
                
                dataDAY = [dataDAY;BTdata];
    
                catch
                
                dataDAY =[dataDAY;0];
                
                end

            end

        tbb07_pcolor = [tbb07_pcolor,dataDAY];

        pclrplot.(variableNames{k}) = tbb07_pcolor;

        % tbb09_pcolor = [tbb09_pcolor,dataDAY];
        % 
        % tbb10_pcolor = [tbb10_pcolor,dataDAY];
        % 
        % tbb11_pcolor = [tbb11_pcolor,dataDAY];
        % 
        % tbb12_pcolor = [tbb12_pcolor,dataDAY];
        % 
        % tbb13_pcolor = [tbb13_pcolor,dataDAY];
        % 
        % tbb14_pcolor = [tbb14_pcolor,dataDAY];
        % 
        % tbb15_pcolor = [tbb15_pcolor,dataDAY];
        % 
        % tbb16_pcolor = [tbb16_pcolor,dataDAY];

        dataDAY = [];

    end

end
%---------------------------------

