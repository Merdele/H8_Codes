%% Function to create a matrix for Pcolor plot
% Created by Denny on 6 Feb 2024
% YYYYMM,Day input based on the script in gettingpcolormateix
% E.g. 
% 
% day = DD{i};
% 
% data_07 = pcolormatrix_function('tbb_07',YYYYMM,day);
% Created by Denny on 6 Feb 2024

function Output = pcolormatrix_function(VarName,YYYYMM,day)

dataDAY = [];

% Get the current variable name from the list
        
        % Use evalin to retrieve the variable from the workspace
        VarValue = evalin('base', VarName);
    
        myStruct = VarValue;

        hours = {'1800','1810','1820','1830','1840','1850',...
       '1900','1910','1920','1930','1940','1950',...
        '2000','2010','2020','2030','2040','2050',...
        '2100','2110','2120','2130','2140','2150',...
        '2200'};

            for j = 1:length(hours)

                % add in a line if field name == XXXX exists --- 
                % else - BT data = 0

                hour_to_index = hours{j};

                containsName = (['NC_H09_',YYYYMM,day,'_',hour_to_index]);
               
                % this section accounts for missing data and puts 0 in its
                % place

                try
    
                BTdata = myStruct.(containsName)(4,4);

                %Marapi(-0.391642,100.457107,0.04,0.02); (4,4)
                %Sinabung(3.170479,98.391995,0.07,0.02); (5,5)
                %Taal(14.010038,120.997882,0.07,0.02)
                
                dataDAY = [dataDAY;BTdata];
    
                catch
                
                dataDAY =[dataDAY;NaN];
                
                end

            end

            Output = dataDAY;

            

end