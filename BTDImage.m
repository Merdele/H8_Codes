%% The script plots the BTD

%% This section loads the data

clear

addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'

%------------------------Config to change-------------

Volcano = 'Marapi';
YYYYMM = '202312';
DD = '03';
DayNight = 'Day';

%------------------------------------------------------

Matfile_Data_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Processed_Data/';


%%

% creating filenames
foldername = [Volcano,'_',YYYYMM,'/',Volcano,'_',YYYYMM,DD,'_',DayNight];
btdfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'_BTD.mat'];

btdfiletoread = ([Matfile_Data_Folder,'/',foldername,'/',btdfilename]);

load(btdfiletoread)

mkdir([Matfile_Data_Folder,foldername,'/BTDImage'])
cd([Matfile_Data_Folder,foldername,'/BTDImage'])


%%
myStruct = BTD_14_15;

fieldname = fieldnames(myStruct);

for i = 1:length(fieldname)

figure

image(myStruct.(fieldname{i}),'CDataMapping','scaled')
colorbar
title(['BTD between tbb14 and tbb15 ' ...
    '',strrep(fieldname{i},'_',' ')]);

fig_filename = (['BTD_14_15_',fieldname{i},'.png']);
saveas(gcf, fig_filename);
close

end

%%
x = [];

for i = 1:length(fieldname)

x = [x;myStruct.(fieldname{i})];

end

x=x(:);

scatter(1:length(x),x)
