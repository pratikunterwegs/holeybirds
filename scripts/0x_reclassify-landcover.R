library(raster)
library(tmap)

# get landcover
lc = raster("data/rasters/raster_hula_lc.tif")

# reclassify
lc_vals = unique(raster::values(lc))
new_lc_vals = floor(lc_vals / 10)

reclass_matrix = cbind(
  lc_vals,
  new_lc_vals
)

lc_reclass = raster::reclassify(
  lc,
  rcl = reclass_matrix
)

# save
writeRaster(
  lc_reclass,
  filename = "data/rasters/raster_hula_lc_reclass.tif"
)

tm_shape(lc_reclass)+
  tm_raster(style = "cat", palette = viridis::turbo(5))
