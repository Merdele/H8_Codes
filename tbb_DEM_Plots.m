%% Plotting tbb data against DEM

%% Load the data

clear

addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'

%------------------------Config to change-------------

Volcano = 'Sinabung';
YYYYMM = '201906';
DD = '09';
DayNight = 'Night';

%------------------------------------------------------

DEM_Data_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/DEM/Sinabung/';

Matfile_Data_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Processed_Data/';

DEMFileName = 'resampled_dem.tif';

foldername = [Volcano,'_',YYYYMM,'/',Volcano,'_',YYYYMM,DD,'_',DayNight];
matfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'_Median.mat'];
%stackfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'_Stacked.mat'];



DEMfiletoread = ([DEM_Data_Folder,DEMFileName]);
matfiletoread = ([Matfile_Data_Folder,'/',foldername,'/',matfilename]);
%stackfiletoread = ([Matfile_Data_Folder,'/',foldername,'/',stackfilename]);

[DEM,R] = readgeoraster(DEMfiletoread,"OutputType","double");
load(matfiletoread)
%load(stackfiletoread)

%mkdir([Matfile_Data_Folder,foldername,'/','DEMvsTBB'])
cd([Matfile_Data_Folder,foldername,'/DEMvsTBB'])

%% This Section plots the data in boxcharts
% Indexes in the section are hardcoded based on a 8x8 matrix. If the size
% of the matrix changes, will require hardcoding to change the indexing



NWPositions = [5,4;4,3;3,2;2,1];
DEMindex.NW = DEM(sub2ind(size(DEM), NWPositions(:, 1)...
    , NWPositions(:, 2)));

DEMindex.N = flip(DEM(2:5,4));

NEPositions = [5,4;4,5;3,6;2,7];
DEMindex.NE=DEM(sub2ind(size(DEM), NEPositions(:, 1)...
    , NEPositions(:, 2)));

DEMindex.W = flip(DEM(5,1:4));

DEMindex.E = DEM(5,4:7);

SWPositions = [5,4;6,3;7,2;8,1];
DEMindex.SW = DEM(sub2ind(size(DEM), SWPositions(:, 1),...
    SWPositions(:, 2)));

DEMindex.S = DEM(5:8,4);

SEPositions = [5,4;6,5;7,6;8,7];
    DEMindex.SE = DEM(sub2ind(size(DEM), ...
        SEPositions(:, 1), SEPositions(:, 2)));

DATASTRUCT = all_median;


fieldName = fieldnames(DATASTRUCT);

%%

for i = 1%:length(fieldName)

    
    DATA.NW = DATASTRUCT.(fieldName{i})(sub2ind(size(DATASTRUCT.(fieldName{i}))...
    , NWPositions(:, 1),NWPositions(:, 2)));
    
    DATA.N = DATASTRUCT.(fieldName{i})(2:5,4);

    DATA.NE = DATASTRUCT.(fieldName{i})(sub2ind(size(DATASTRUCT.(fieldName{i}))...
    , NEPositions(:, 1),NEPositions(:, 2)));
    
    DATA.W = DATASTRUCT.(fieldName{i})(5,1:4);

    DATA.E = DATASTRUCT.(fieldName{i})(5,4:7);

    DATA.SW = DATASTRUCT.(fieldName{i})(sub2ind(size(DATASTRUCT.(fieldName{i}))...
    , SWPositions(:, 1),SWPositions(:, 2)));
   
    DATA.S = DATASTRUCT.(fieldName{i})(5:8,4);
    
    DATA.SE = DATASTRUCT.(fieldName{i})(sub2ind(size(DATASTRUCT.(fieldName{i}))...
    , SWPositions(:, 1),SWPositions(:, 2)));


    tiledlayout(3,3)

    % Define the subplot positions
    subplot_positions = [1 2 3 4 6 7 8 9];
    
    plotfieldName = fieldnames(DEMindex);
    
    
    
    % Create subplots
    for k = 1:8
    
        nexttile(subplot_positions(k))
        
        %subplot(3, 3, subplot_positions(k));
        %plot(DEMindex.(plotfieldName{k}),'r-')
        hold on
        plot(DATA.(plotfieldName{k}),'b-')
        title([plotfieldName{k}]);
        hold off
        
    end
    
    legend('Data','Location','bestoutside','orientation','vertical')
    sgtitle(strrep(fieldName{i},'_',' '))
    fig_filename = ([strrep(fieldName{i},'_',' '),' DEMvsTBB.png']);
    saveas(gcf, fig_filename);
    %close

    clear("DATA")

    
end


%% This Section plots the normalized data
% 
% normalizeddem = (DEM-mean(DEM,"all"))/std(DEM,0,"all");
% 
% NWPositions = [2,1;3,2;4,3;5,4];
% DEMindex.NW = normalizeddem(sub2ind(size(normalizeddem), NWPositions(:, 1)...
%     , NWPositions(:, 2)));
% 
% DEMindex.N = normalizeddem(2:5,4);
% 
% NEPositions = [2,7;3,6;4,5;5,4];
% DEMindex.NE=normalizeddem(sub2ind(size(normalizeddem), NEPositions(:, 1)...
%     , NEPositions(:, 2)));
% 
% DEMindex.W = normalizeddem(5,1:4);
% 
% DEMindex.E = normalizeddem(5,4:7);
% 
% SWPositions = [5,4;6,3;7,2;8,1];
% DEMindex.SW = normalizeddem(sub2ind(size(normalizeddem), SWPositions(:, 1),...
%     SWPositions(:, 2)));
% 
% DEMindex.S = normalizeddem(5:8,4);
% 
% SEPositions = [5,4;6,5;7,6;8,7];
%     DEMindex.SE = normalizeddem(sub2ind(size(normalizeddem), ...
%         SEPositions(:, 1), SEPositions(:, 2)));
% 
% 
% fieldName = fieldnames(all_median);
% 
% for i = 1:length(fieldName)
% 
%     data_mean_value = mean(all_median.(fieldName{i}),'all');
%     data_sd_value = std(all_median.(fieldName{i}),0,'all');
% 
%     normalized.(fieldName{i}) = (all_median.(fieldName{i})-data_mean_value)...
%         /data_sd_value ;
% 
% 
%     DATA.NW = normalized.(fieldName{i})(sub2ind(size(normalized.(fieldName{i}))...
%     , NWPositions(:, 1),NWPositions(:, 2)));
% 
%     DATA.N = normalized.(fieldName{i})(2:5,4);
% 
%     DATA.NE = normalized.(fieldName{i})(sub2ind(size(normalized.(fieldName{i}))...
%     , NEPositions(:, 1),NEPositions(:, 2)));
% 
%     DATA.W = normalized.(fieldName{i})(5,1:4);
% 
%     DATA.E = normalized.(fieldName{i})(5,4:7);
% 
%     DATA.SW = normalized.(fieldName{i})(sub2ind(size(normalized.(fieldName{i}))...
%     , SWPositions(:, 1),SWPositions(:, 2)));
% 
%     DATA.S = normalized.(fieldName{i})(5:8,4);
% 
%     DATA.SE = normalized.(fieldName{i})(sub2ind(size(normalized.(fieldName{i}))...
%     , SWPositions(:, 1),SWPositions(:, 2)));
% 
% 
%     tiledlayout(3,3)
% 
%     % Define the subplot positions
%     subplot_positions = [1 2 3 4 6 7 8 9];
% 
%     plotfieldName = fieldnames(DEMindex);
% 
% 
% 
%     % Create subplots
%     for k = 1:8
% 
%         nexttile(subplot_positions(k))
% 
%         %subplot(3, 3, subplot_positions(k));
%         plot(DEMindex.(plotfieldName{k}),'r-')
%         hold on
%         plot(DATA.(plotfieldName{k}),'b-')
%         title([plotfieldName{k}]);
%         hold off
% 
%     end
% 
%     legend('DEM','Data','Location','bestoutside','orientation','vertical')
%     sgtitle(strrep(fieldName{i},'_',' '))
%     fig_filename = ([strrep(fieldName{i},'_',' '),' DEMvsTBB.png']);
%     saveas(gcf, fig_filename);
%     close
% 
%     clear("DATA")
% 
% 
% end

%%
% %%
% NEPositions = [2,7;3,6;4,5;5,4];
% DEMindex.NE=DEM(sub2ind(size(DEM), NEPositions(:, 1), NEPositions(:, 2)));
% DATA.NE = all_median.(fieldName{i})(sub2ind(size(all_median.(fieldName{i}))...
%     , NEPositions(:, 1),NEPositions(:, 2)));
% 
% DEMindex.N = DEM(2:5,4);
% DATA.N = all_median.(fieldName{i})(2:5,4);
% 
% NWPositions = [2,1;3,2;4,3;5,4];
% DEMindex.NW = DEM(sub2ind(size(DEM), NWPositions(:, 1), NWPositions(:, 2)));
% DATA.NW = all_median.(fieldName{i})(sub2ind(size(all_median.(fieldName{i}))...
%     , NWPositions(:, 1),NWPositions(:, 2)));
% 
% 
% DEMindex.W = DEM(5,1:4);
% DATA.W = all_median.(fieldName{i})(5,1:4);
% 
% SWPositions = [5,4;6,3;7,2;8,1];
% DEMindex.SW = DEM(sub2ind(size(DEM), SWPositions(:, 1), SWPositions(:, 2)));
% DATA.SW = all_median.(fieldName{i})(sub2ind(size(all_median.(fieldName{i}))...
%     , SWPositions(:, 1),SWPositions(:, 2)));
% 
% DEMindex.S = DEM(5:8,4);
% DATA.S = all_median.(fieldName{i})(5:8,4);
% 
% SEPositions = [5,4;6,5;7,6;8,7];
% DEMindex.SE = DEM(sub2ind(size(DEM), SEPositions(:, 1), SEPositions(:, 2)));
% DATA.SE = all_median.(fieldName{i})(sub2ind(size(all_median.(fieldName{i}))...
%     , SWPositions(:, 1),SWPositions(:, 2)));
% 
% DEMindex.E = DEM(5,4:7);
% DATA.E = all_median.(fieldName{i})(5,4:7);

% %%
% 
% NWPositions = [2,1;3,2;4,3;5,4];
% DEMindex.NW = normalizeddem(sub2ind(size(normalizeddem), NWPositions(:, 1), NWPositions(:, 2)));
% DATA.NW = normalized.(fieldName{i})(sub2ind(size(normalized.(fieldName{i}))...
%     , NWPositions(:, 1),NWPositions(:, 2)));
% 
% DEMindex.N = normalizeddem(2:5,4);
% DATA.N = normalized.(fieldName{i})(2:5,4);
% 
% 
% NEPositions = [2,7;3,6;4,5;5,4];
% DEMindex.NE=normalizeddem(sub2ind(size(normalizeddem), NEPositions(:, 1), NEPositions(:, 2)));
% DATA.NE = normalized.(fieldName{i})(sub2ind(size(normalized.(fieldName{i}))...
%     , NEPositions(:, 1),NEPositions(:, 2)));
% 
% DEMindex.W = normalizeddem(5,1:4);
% DATA.W = normalized.(fieldName{i})(5,1:4);
% 
% DEMindex.E = normalizeddem(5,4:7);
% DATA.E = normalized.(fieldName{i})(5,4:7);
% 
% SWPositions = [5,4;6,3;7,2;8,1];
% DEMindex.SW = normalizeddem(sub2ind(size(normalizeddem), SWPositions(:, 1), SWPositions(:, 2)));
% DATA.SW = normalized.(fieldName{i})(sub2ind(size(normalized.(fieldName{i}))...
%     , SWPositions(:, 1),SWPositions(:, 2)));
% 
% DEMindex.S = normalizeddem(5:8,4);
% DATA.S = normalized.(fieldName{i})(5:8,4);
% 
% SEPositions = [5,4;6,5;7,6;8,7];
% DEMindex.SE = normalizeddem(sub2ind(size(normalizeddem), SEPositions(:, 1), SEPositions(:, 2)));
% DATA.SE = normalized.(fieldName{i})(sub2ind(size(normalized.(fieldName{i}))...
%     , SWPositions(:, 1),SWPositions(:, 2)));
% 
% %%
% 
% 
% tiledlayout(3,3)
% 
% % Define the subplot positions
% subplot_positions = [1 2 3 4 6 7 8 9];
% 
% plotfieldName = fieldnames(DEMindex);
% 
% 
% 
% % Create subplots
% for k = 1:8
% 
%     nexttile(subplot_positions(k))
% 
%     %subplot(3, 3, subplot_positions(k));
%     plot(DEMindex.(plotfieldName{k}),'r-')
%     hold on
%     plot(DATA.(plotfieldName{k}),'b-')
%     title([plotfieldName{k}]);
%     hold off
% 
% 
% 
% end
% 
% legend('DEM','Data','Location','bestoutside','orientation','vertical')
% sgtitle(strrep(fieldName{i},'_',' '))
% fig_filename = ([strrep(fieldName{i},'_',' '),' DEMvsTBB.png']);
% saveas(gcf, fig_filename);
% close
