%% Further Processes the tbb Data
% takes the median across one hour, average across one hour

clear

%------------------------Config to change-------------
Volcano = 'Sinabung';
YYYYMM = '201906';
DD = '09';
DayNight = 'Night';

%------------------------Config to change-------------


filetoLoad = ([Volcano,'_',YYYYMM,DD,'_',DayNight,'.mat']);

load(filetoLoad)

variableNames = who;

for p = 8:length(variableNames)

% indexes out the variableName (which will be the tbb)
% 8 is hardcoded for the length of the variablename. HAVE TO CHANGE IT if
% the number of variables in the workspace increases. Will try to think of
% a different way to do this. 
currentVarName = variableNames{p};

% Takes the variable name and evaluates it as a variable
currentVarValue = evalin('base', currentVarName);

% saves the variable as the struct
myStruct = currentVarValue;

% creates a cell of the fieldnames within the struct
fieldName = fieldnames(myStruct);

% takes the first fieldname(which corresponds to the hour, 00 mins to start
% the stacking of tha data
stackedmatrix = myStruct.(fieldName{1});

% hardcoded the hours that I want the data to stack.
% 14 meaning the data collected within between 1400 and 1459 will be
% stacked together
hours = {'14','15','16','17','18','19','20','21','22','23'};

for i = 1:length(hours)

    hour_to_index = hours{i};

    % creates the character array that i want to to compare from each field
    % the hour will be the identifier
    containsName = (['NC_H08_',YYYYMM,DD,'_',hour_to_index]);
   
    % uses contain to get the logical index of where the 
    hour_idx = contains(fieldName,containsName);

    % indexes the fieldnames that is specified by the hour
    hour_fieldname = fieldName(hour_idx);

        % try for situtations where the tbb data does not have the hours,
        % it will not stop the code.
        try

        % saves the first time of the hour to start the stacking process
        stackedmatrix = myStruct.(hour_fieldname{1});

        for j = 2:length(hour_fieldname)

        % loops for the number of data collected within an hour and stacks
        % it in the stackedmatrix
        stackedmatrix = cat(3,stackedmatrix,myStruct.(hour_fieldname{j}));

        end

        % creating new field names, differentiated by the hour, to save out
        %put as structs
        newfieldname = ([currentVarName,sprintf('_NC_H08_20190609_%s',hours{i})]);

        % calculates the median for each hour 
        all_median.(newfieldname) = median(stackedmatrix,3);

        % clears stackedmatrix for the next loop for the next hour.
        clear('stackedmatrix')

        catch

        fprintf('%s, Hour %s not median\n',currentVarName,hours{i})

        end

end 

end

% creating median file name. 
medianfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'_Median.mat'];

% specify which variables to be saved depending on what is to be read.
save(medianfilename,"all_median")


%%
%tbb_07_medianMatrix. = median(stackedmatrix,3);
% tbb_07_median.(sprintf('NC_H08_20190609_%s',hours{i}))= ...
%     median(stackedmatrix,3);
% T = table(tbb_07,tbb_08,tbb_09,tbb_10,tbb_11,tbb_12,tbb_13,tbb_14,tbb_15,tbb_16)