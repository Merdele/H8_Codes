%% This script creates a pcolor plot using the matrixes consolidated in 
% gettingpcolormatrix script

%clear
                
% add path for the create_aoi_coords function
addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'

%---------Config to change--------
% Change the details for the specific event - the file directory will be
% saved according to the following variables
Volcano = 'Marapi';
YYYYMM = '202311';
Data_YYYYMM = '202312';
DD = {'01','02','03','04','05','06','07','08','09','10','11','12',...
    '13','14','15','16','17','18','19','20','21','22','23','24','25',...
    '26','27','28','29','30','01','02','03'};

% Volcano = 'Sinabung';
% YYYYMM = '201905';
% Data_YYYYMM = '201906';
% DD = {'12',...
%     '13','14','15','16','17','18','19','20','21','22','23','24','25',...
%     '26','27','28','29','30','31','01','02','03','04','05','06','07','08','09'};
% add one more day
% 
% DD = {'01','02','03','04','05','06','07','08','09','10','11','12',...
%     '13','14','15','16','17','18','19','20','21','22','23','24','25',...
%     '26','27','28','29','30','01','02','03'};
% add one more day

% {'01','02','03','04','05','06','07','08','09','10','11','12',...
%     '13','14','15','16','17','18','19','20','21','22','23','24','25',...
%     '26','27','28','29','30','31'};

% Marapi UTC +7

% only important for when downloading Day time and Night time acquisitions
% separately 
DayNight = 'Night';

%% This section loads the data

Matfile_Data_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Processed_Data/';
Folder_Name = ([Volcano,'_',Data_YYYYMM]);
MatFile_Name = ([Volcano,'_',Data_YYYYMM,'_',DayNight,'_BTD_Pcolors.mat']);

File_To_Load = ([Matfile_Data_Folder,Folder_Name,'/',MatFile_Name]);

load(File_To_Load)

%% This section plots the pcolor matrix

% time = {'1800','1810','1820','1830','1840','1850',...
%      '1900','1910','1920','1930','1940','1950',...
%      '2000','2010','2020','2030','2040','2050',...
%      '2100','2110','2120','2130','2140','2150',...
%      '2200'};


% startDate = datetime([YYYYMM(1:4),'-',YYYYMM(5:6),'-',DD{1}]);
startDate = datetime('2023-11-01');
dates = startDate + days(0:length(DD)-1);

% VariableNames = {'tbb_07_pcolor','tbb_08_pcolor','tbb_09_pcolor','tbb_10_pcolor',...
%     'tbb_11_pcolor','tbb_12_pcolor','tbb_13_pcolor','tbb_14_pcolor',...
%     'tbb_15_pcolor','tbb_16_pcolor'};

VariableNames = {'BTD_7_14_pcolour'};

% VariableNames = {'BTD_7_13_pcolour','BTD_7_14_pcolour','BTD_7_15_pcolour',...
%     'BTD_13_14_pcolour','BTD_13_15_pcolour','BTD_14_15_pcolour',};

for i = 1:length(VariableNames)

    VarName = VariableNames{i};

    VarValue = evalin('base', VarName);
   
    myMatrix =  flipud(VarValue);
    
    numDays = length(DD);
    timeIntervals = size(myMatrix,1);  % 5 hours with data every 10 minutes
    
    %%
    %Generate time vector from 1am to 5am 
    startTime = datetime([YYYYMM(1:4),'-',YYYYMM(5:6),'-',DD{1}]) + hours(1);  % Start time at 1am
    endTime = datetime([YYYYMM(1:4),'-',YYYYMM(5:6),'-',DD{1}]) + hours(5);    % End time at 5am
    timeVector = linspace(startTime, endTime, timeIntervals)';

    % Plotting
    figure%('WindowState','maximized')

    % dates should have the same number of columns as myMatrix
    % timevector should have the same number of columns as myMatrix
    pcolor(dates,datetime(timeVector), myMatrix);

    % Set the color scheme
    colormap(magma()); % You can replace 'jet' with any other colormap name
    %shading flat;
   
    % Customize the plot
    % title([strrep(VarName,'_',' '), ' for Mt ',Volcano]);
    title('BTD between Band 7 and 14','FontSize', 14, 'FontName', 'Arial')
    xlabel('Date','FontSize', 14, 'FontName', 'Arial');
    ylabel('Time','FontSize', 14, 'FontName', 'Arial');
    colorbar;
    ylabel(colorbar,'Celsius','FontSize', 14, 'FontName', 'Arial')

    fig_filename = ([VarName,'_for_Mt_',Volcano,'.png']);
    saveas(gcf, fig_filename);
    %close

end
