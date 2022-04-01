# script to get NDVI in 2016 from Google Earth Engine
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

# read in landcover shapefile
landcover_shp = gpd.read_file("../data/spatial/hula_lc_vector/HulaValley.shp")
# check crs
landcover_shp.crs

# make buffer of 500m
landcover_buffer = landcover_shp.buffer(distance=500)

# get extent of the buffer file
extent = landcover_buffer.total_bounds
extent = box(*extent)
extent = gpd.GeoSeries(extent)

# make geodataframe and set correct crs
extent = gpd.GeoDataFrame.from_features(extent)
extent.crs = landcover_shp.crs
# check crs again
extent.crs

# now transform to EPSG 4326, which is WG884
extent = extent.to_crs(epsg=4326)
extent.crs

# make a folder
os.makedirs("../data/spatial/extent")
# save as shapefile to read for GEE
extent.to_file("../data/spatial/extent/extent.shp")

# first read in shapefile of landcover classes
extent_file = "../data/spatial/extent/extent.shp"
# transfer to GEE using GMAP
extent_ee = geemap.shp_to_ee(extent_file)

# show on map if possible
Map = geemap.Map()
Map.addLayer(extent_ee, {}, 'extent')
Map ## uncomment to see map

# define start and end date june and dec 2016
start_date = '2016-06-01'
end_date = '2016-10-01'

# get sentinel data for the time range 2016
sentinel = ee.ImageCollection("COPERNICUS/S2")
sentinel_bounds = sentinel.filterBounds(extent_ee)
sentinel_2016 = sentinel_bounds.filterDate(start_date, end_date)


# adding a NDVI band
def add_ndvi(image):
    ndvi = image.normalizedDifference(['B8', 'B4']).rename('ndvi')
    return image.addBands([ndvi])


# map metrics over sentinel
sentinel_ndvi = sentinel_2016.map(add_ndvi)

# get median values
ndvi_median = sentinel_ndvi.select('ndvi').median()

# clip to geometry
ndvi_clip = ndvi_median.clip(extent_ee)

# export ndvi data as an image locally
out_dir = "../data/rasters/"
filename = os.path.join(out_dir, 'raster_hula_clip_wgs84.tif')

geemap.ee_export_image(
    ndvi_clip, filename=filename, scale=10, region=extent_ee.geometry(),
    file_per_band=False
)
