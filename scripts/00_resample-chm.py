# script to get NDVI in 2016 from Google Earth Engine
import os
from rasterio.crs import CRS
import rioxarray as rxr
import matplotlib.pyplot as plt

# check where we are
os.getcwd()

# set raster filename
filename = "data/rasters/dsm/DSM_2018_050m.tif"

## read raster and transform to israeli grid
chm_2039 = rxr.open_rasterio(filename=filename).squeeze()
chm_2039.plot.imshow(cmap='viridis')
plt.show()

# check crs
chm_2039.rio.crs

# set CRS to recognisable value
chm_2039 = chm_2039.rio.write_crs(2039)
# check crs
chm_2039.rio.crs

## downsample to 1m from 50cm resolution
# downsample to 1m resolution
chm_2039_01m = chm_2039.rio.reproject(chm_2039.rio.crs, resolution=1.0/1.0)
# save as raster
chm_2039_01m.rio.to_raster("data/rasters/dsm/raster_chm_2039_01m.tif")
