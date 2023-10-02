# Calling libraries
import warnings
warnings.simplefilter("ignore", UserWarning)

#from datetime import datetime
#from datetime import timedelta
from datetime import datetime, timedelta

import numpy as np
import os, shutil

from satpy import Scene, find_files_and_readers
from satpy.resample import get_area_def

from pyresample import geometry
from pyresample.utils import get_area_def

from pyproj import Proj, transform

import matplotlib.pyplot as plt

dirName = "/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_DataH8/202308/02"
dirName1 = "/Users/denny/OneDrive - Nanyang Technological University/Y4/FYP/H8_Output"

#Downloading the DAT files downloaded from the Cloud
for dd in [2]: # Day
    for hh in range(0,5,1): # Hour
        for mm in range(00,60,10): # Minute
            if (hh == 2 and mm == 40): pass # If file is not here
            else:
                # Reading and loading corresponding files (B13 = infrared)
                files = find_files_and_readers(start_time=datetime(2023, 8, dd, hh, mm),
                                                end_time=datetime(2023, 8, dd, hh, mm),
                                                base_dir=dirName,
                                                reader='ahi_hsd')
                scn = Scene(sensor='ahi', filenames=files)  
                rgbname = 'B13'
                scn.load([rgbname])

                start_time = scn.start_time + timedelta(minutes=5,seconds=-15)

                # Defining resampled area of Krakatau (ID, projection for area_extent, size in Pixels, projection type, description)

                area_id = 'Krakatau'

                # Converting Latitude and Longitude to X,Y coordinate by a lambert azimuthal equal area (LAEA)
                inProj = Proj("epsg:4326")
                outProj = Proj('+proj=laea +lat_0=-6 +lon_0=105.5 +ellps=WGS84') # lat and lon are the middle of the map
                lon_left,lat_left = 105, -6.5
                lon_right, lat_right = 106, -5.5
                x_left,y_left = transform(inProj,outProj,lon_left,lat_left,always_xy=True)
                x_right,y_right = transform(inProj,outProj,lon_right, lat_right,always_xy=True)

                area_extent = (x_left,y_left, x_right,y_right)

                # how many rows and columns in pixels assuming 1 pixel is 1000 km (intermediate resolution)
                px = 1000
                x_size = int((x_right-x_left)/px)
                y_size = int((y_right-y_left)/px)

                # Lambert azimuthal equal area LAEA from a custom local projection (lon_0 and lat_0 = center of study area)
                projection = '+proj=laea +lat_0=-6 +lon_0=105.5 +ellps=WGS84'

                description = "Krakatau"
                proj_id = 'laea_105.5_-6'

                # Resampling satellite data to the area of interest
                areadef = get_area_def(area_id, description, proj_id, projection, x_size, y_size, area_extent)
                local_scene = scn.resample(areadef)
                
                # Retrieve Brightness temperature
                val = local_scene['B13']
                brightTemp = val.values
                
                nbrow = len(brightTemp)     #y size
                nbcol = len(brightTemp[0])  #x size
                
                # Saving data
                SaveName = dirName1
                try:
                    # create target directory
                    os.mkdir(SaveName)
                    print("Directory " , SaveName ,  " Created \n")
                except FileExistsError:
                    print("Directory " , SaveName ,  " already exits \n")
                    
                np.savetxt(SaveName + 'Temp_{datetime}.txt'.format(datetime=scn.start_time.strftime('%Y%m%d%H%M')),brightTemp,delimiter=',')

                print('OK {datetime}'.format(datetime=scn.start_time.strftime('%Y%m%d%H%M')))

v = val.x.data
x_size = len(v)
xproj = np.ones((1,x_size))
xproj[0,:]=v

v = val.y.data
y_size = len(v)
yproj = np.ones((y_size,1))
yproj[:,0]=v

xproj_mat = np.repeat(xproj,y_size,0)
yproj_mat = np.repeat(yproj,x_size,1)

lon_mat,lat_mat = transform(outProj,inProj,xproj_mat,yproj_mat)

np.savetxt(SaveName + 'Lat.txt',lat_mat,delimiter=',')
np.savetxt(SaveName + 'Lon.txt',lon_mat,delimiter=',')

