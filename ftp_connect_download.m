%% This script downloads Himawari 8/9 Data from their given FTP server
% you will have to sign up and for their services where they will give you
% a Username and Password in order to access their FTP
% JAXA Website to get your FTP Credentials
% https://www.eorc.jaxa.jp/ptree/faq.html#0103
% created by Denny on 23 Oct 2023.


%% Change Directory of FTP and destination directory
% downloads the .nc files

%---------Config to change--------
% Change the details for the specific event - the file directory will be
% saved according to the following variables
Volcano = 'Marapi';
YYYYMM = '202208';
DD = {'08'};

% {'01','02','03','04','05','06','07','08','09','10','11','12',...
%     '13','14','15','16','17','18','19','20','21','22','23','24','25',...
%     '26','27','28','29','30','31'};

% Marapi UTC +7

% only important for when downloading Day time and Night time acquisitions
% separately 
DayNight = 'Day';


% destination_folder = ...
% (['/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Raw_Data/',...
% Volcano,'_',YYYYMM,DD{j},'_',DayNight]);

%destination_folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Raw_Data/Sinabung_2019';

% 
% mkdir (destination_folder)
% cd (destination_folder)

%---------------------------------

%%


% Define FTP server information
ftpServer = 'ftp.ptree.jaxa.jp';
ftpUser = 'CH0002NY_e.ntu.edu.sg';
ftpPassword = 'SP+wari8';

% Connect to the FTP server
ftpObj = ftp(ftpServer, ftpUser, ftpPassword);

for j = 1:length(DD)

destination_folder = ...
(['/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Raw_Data/',...
Volcano,'_',YYYYMM,DD{j},'_',DayNight]);

%destination_folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Raw_Data/Sinabung_2019';


mkdir (destination_folder)
cd (destination_folder)    

% cd to desired path in the ftp
cd(ftpObj, ['/jma/netcdf/',YYYYMM,'/',DD{j}]);


% hardcoded the times of which will allow me to download the files
% times are in UTC
time = {'0310','0320'};
     
% Marapi - UTC+7

    % {'0000','0010','0020','0030','0040','0050',...
    %  '0100','0110','0120','0130','0140','0150',...
    %  '0200','0210','0220','0230','0240','0250',...
    %  '0300','0310','0320','0330','0340','0350',...
    %  '0400','0410','0420','0430','0440','0450',...
    %  '0500','0510','0520','0530','0540','0550',...
    %  '0600','0610','0620','0630','0640','0650',...
    %  '0700','0710','0720','0730','0740','0750'...
    %  '0800','0810','0820','0830','0840','0850',...
    %  '0900','0910','0920','0930','0940','0950',...
    %  '1000','1010','1020','1030','1040','1050',...
    %  '1100','1110','1120','1130','1140','1150',...
    %  '1200','1210','1220','1230','1240','1250',...
    %  '1300','1310','1320','1330','1340','1350',...
    %  '1400','1410','1420','1430','1440','1450',...
    %  '1500','1510','1520','1530','1540','1550',...
    %  '1600','1610','1620','1630','1640','1650',...
    %  '1700','1710','1720','1730','1740','1750',...
    %  '1800','1810','1820','1830','1840','1850',...
    %  '1900','1910','1920','1930','1940','1950',...
    %  '2000','2010','2020','2030','2040','2050',...
    %  '2100','2110','2120','2130','2140','2150',...
    %  '2200','2210','2220','2230','2240','2250',...
    %  '2300','2310','2320','2330','2340','2350'};


for i = 1:length(time)
    try
        % Note some files will be NC_H09 instead for Himawari-9 Data
    files_to_download_date = ['NC_H08_',YYYYMM,DD{j},'_']; %'NC_H08_20190604_';  
    files_to_download_time = time{i};
    files_to_download_end = '_R21_FLDK.06001_06001.nc';
    filename=[files_to_download_date,files_to_download_time,files_to_download_end];
    
    mget(ftpObj,filename,destination_folder);

    catch
        fprintf('Error reading file %s\n', filename);
        continue;
    end

end

end



fprintf('Download Complete\n')
