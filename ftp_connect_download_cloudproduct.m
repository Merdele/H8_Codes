%% This script downloads Himawari 8/9 Data from their given FTP server
% you will have to sign up and for their services where they will give you
% a Username and Password in order to access their FTP
% JAXA Website to get your FTP Credentials
% https://www.eorc.jaxa.jp/ptree/faq.html#0103
% created by Denny on 23 Oct 2023.


%% Change Directory of FTP and destination directory
% downloads the .nc files

%---------Config to change--------
Volcano = 'Sinabung';
YYYYMM = '201906';
DD = {'01','02','04','05','06','07','08','09'};


for k = 1:length(DD)

% for IR data
destination_folder = ...
['/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Cloud_Product/',...
Volcano,'_',YYYYMM,DD{k},];


mkdir (destination_folder)
cd (destination_folder)

%---------------------------------

%%


% Define FTP server information (replace with your server details)
ftpServer = 'ftp.ptree.jaxa.jp';
ftpUser = 'CH0002NY_e.ntu.edu.sg';
ftpPassword = 'SP+wari8';

% Connect to the FTP server
ftpObj = ftp(ftpServer, ftpUser, ftpPassword);


HH = {'09','10','11','12','13','14','15','16','17','18','19','20','21'...
    '22',};

for j = 1:length(HH)
% cd to desired path in the ftp
cd(ftpObj, ['/pub/himawari/L2/CLP/010/',YYYYMM,'/',DD{k},'/',HH{j}]);


% hardcoded the times of which will allow me to download the files
% nighttime = {'1400','1410','1420','1430','1440','1450',...
%     '1500','1510','1520','1530','1540','1550',...
%     '1600','1610','1620','1630','1640','1650',...
%     '1700','1710','1720','1730','1740','1750',...
%     '1800','1810','1820','1830','1840','1850',...
%     '1900','1910','1920','1930','1940','1950',...
%     '2000','2010','2020','2030','2040','2050',...
%     '2100','2110','2120','2130','2140','2150',...
%     '2200','2210','2220','2230','2240','2250','2300'};

mm = {'00','10','20','30','40','50'};

for i = 1:length(mm)
    try
        % Note some files will be NC_H09 instead for Himawari-9 Data
    files_to_download_date = ['NC_H08_',YYYYMM,DD{k},'_']; %'NC_H08_20190604_';  
    files_to_download_time = [HH{j},mm{i}];
    files_to_download_end = '_L2CLP010_FLDK.02401_02401.nc';
    filename=[files_to_download_date,files_to_download_time,files_to_download_end];
    
    mget(ftpObj,filename,destination_folder);

    catch
        fprintf('Error reading file %s\n', filename);
        continue;
    end

end

end

end

fprintf('Download Complete\n')
