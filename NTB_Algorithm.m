%% Testing the Non-Linear Three Band

%% This section loads the data

clear

addpath '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Codes'

%------------------------Config to change-------------

Volcano = 'Sinabung';
YYYYMM = '201906';
DD = '09';
DayNight = 'Night';

%------------------------------------------------------

Matfile_Data_Folder = '/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Processed_Data/';

%%

%foldername = [Volcano,'_',YYYYMM,'/',Volcano,'_',YYYYMM,DD,'_',DayNight];
foldername = 'Sinabung_2019'; %for Sinabung same time of day
tbbfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'.mat'];


tbbfiletoread = ([Matfile_Data_Folder,'/',foldername,'/',tbbfilename]);

load(tbbfiletoread)


%mkdir([Matfile_Data_Folder,foldername,'/','NTB_Night'])
cd([Matfile_Data_Folder,foldername])

%% Defining equation variables 

Coefficients_table = readtable("/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/NTB_Coefficients.xlsx");

coefficient.Zenith = table2array(Coefficients_table(:,1));
coefficient.a0 = table2array(Coefficients_table(:,2));
coefficient.a1 = table2array(Coefficients_table(:,3));
coefficient.a2 = table2array(Coefficients_table(:,4));
coefficient.a3 = table2array(Coefficients_table(:,5));
coefficient.a4 = table2array(Coefficients_table(:,6));
coefficient.a5 = table2array(Coefficients_table(:,7));
coefficient.a6 = table2array(Coefficients_table(:,8));
coefficient.a7 = table2array(Coefficients_table(:,9));
coefficient.a8 = table2array(Coefficients_table(:,10));
coefficient.a9 = table2array(Coefficients_table(:,11));

% For Sinabung, it has a VZA/SOZ 

% specify the Solar Zenith Angle (SOZ) and the respective coefficients
zenith_angle = 60;
coefficient_row_index = find(coefficient.Zenith == zenith_angle);

a0 = coefficient.a0(coefficient_row_index);
a1 = coefficient.a1(coefficient_row_index);
a2 = coefficient.a2(coefficient_row_index);
a3 = coefficient.a3(coefficient_row_index);
a4 = coefficient.a4(coefficient_row_index);
a5 = coefficient.a5(coefficient_row_index);
a6 = coefficient.a6(coefficient_row_index);
a7 = coefficient.a7(coefficient_row_index);
a8 = coefficient.a8(coefficient_row_index);
a9 = coefficient.a9(coefficient_row_index);

Ei = 0.95;

Ej = 0.95;

Ek = 0.95;

variableNames = {'tbb_13'};

% for k = 1:length(variableNames)
k = 1;

currentVarName = variableNames{k};

currentVarValue = evalin('base', currentVarName);

myStruct = currentVarValue;

fieldName = fieldnames(myStruct);

%% This section combines the data in the structs into a single variable.
% the combined data can be controlled for now by looking at the the
% fieldName 


for i = 1:length(fieldName)

Ti = tbb_13.(fieldName{i});

Tj = tbb_14.(fieldName{i});

Tk = tbb_15.(fieldName{i});

first_term = (a1 + a2*((1-Ei)/Ei))*Ti;
second_term = (a3+ a4*((1-Ej)/Ej))*Tj;
third_term = (a5+ a6*((1-Ek)/Ek))*Tk;

fourth_term = a7*((Ti-Tj)^2);
fifth_term = a8*((Ti-Tk)^2);
sixth_term = a9*((Tj-Tk)^2);


NTB.(fieldName{i}) = a0 + first_term + second_term + third_term +fourth_term +...
    fifth_term + sixth_term;


end

%%

NTBfilename = [Volcano,'_',YYYYMM,DD,'_',DayNight,'_NTB.mat'];

save([Matfile_Data_Folder,'/',foldername,'/',NTBfilename],'NTB')

