%% Function to create a matrix for Pcolor plot


function Output = pcolormatrix_function(VarName,i)

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

            Output = dataDay;



end