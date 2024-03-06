%%
Volcano = 'Marapi';

MODIS_Data_Folder =  '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/LST_Inversion/MODIS';

modis_filename_struct = (dir(fullfile(MODIS_Data_Folder,[Volcano,'*'])));

start_loop = 2;

for i = start_loop%:length(modis_filename_struct)
load([modis_filename_struct(i).name])

MODIS_lat = lat;
MODIS_lon = lon;

clear('lat','lon')

LST = LST(1:10,:);

LST(LST == 0) = NaN;

test = reshape(LST, [2, size(LST, 1)/2, size(LST, 2)]);

average_LST = nanmean(test, 1);

average_LST = squeeze(average_LST);

resampled_LST = average_LST(:,1:5);

end