# script to get long term NDVI 2010 - 2020 from LANDSAT-7 using Google Earth Engine
import os
import geopandas as gpd

# try loading geemap and ee
try:
    import geemap
except ImportError:
    print('geemap package not installed. Installing ...')

# Checks whether this notebook is running on Google Colab
try:
    import geemap.eefolium as geemap
except:
    import geemap

# Authenticates and initializes Earth Engine
import ee

try:
    ee.Initialize()
except Exception as e:
    ee.Authenticate()
    ee.Initialize()

# check where we are
os.getcwd()

# read in extent shapefile
extent_file = "data/spatial/extent/extent.shp"
# transfer to GEE using GMAP
extent_ee = geemap.shp_to_ee(extent_file)

# landcover file
landcover_ee = geemap.shp_to_ee("data/spatial/hula_lc_vector/HulaValley.shp")

# show on map if possible (only works in interactive notebooks)
Map = geemap.Map()
Map.addLayer(extent_ee, {}, 'extent')
# Map ## uncomment to see map

# define start and end date as 2010 and 2020 for decadal data
start_date = '2010-01-01'
end_date = '2020-01-01'

# get LANDSAT-7 for the time range 2010-2020
landsat_ndvi = ee.ImageCollection("LANDSAT/LE07/C01/T1_8DAY_NDVI")  # prepared by Google
landsat_bounds = landsat_ndvi.filterBounds(extent_ee)
landsat_longterm = landsat_bounds.filterDate(start_date, end_date)
# convert collection to single image with one band per snapshot
landsat_longterm = landsat_longterm.toBands()

# export ndvi data as an image locally
out_dir = "data/rasters/ndvi_long_term"
if not os.path.exists(out_dir):
    os.makedirs(out_dir)
filename_mean = os.path.join(out_dir, "ndvi_week_mean_" + date + ".csv")
filename_sd = os.path.join(out_dir, "ndvi_week_sd_" + date + ".csv")

# get zonal statistics, mean and standard deviation
geemap.zonal_statistics(
    landsat_longterm,
    landcover_ee,
    filename_mean,
    statistics_type='MEAN',
    scale=30,
    decimal_places=2,
)

geemap.zonal_statistics(
    landsat_longterm,
    landcover_ee,
    filename_sd,
    statistics_type='STD',
    scale=30,
    decimal_places=2,
)
    