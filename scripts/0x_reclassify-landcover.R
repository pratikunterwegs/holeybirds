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

# make map
lc_map =
  tm_shape(lc_reclass)+
  tm_raster(
    style = "cat",
    palette = c(scico::scico(5, palette = "hawaii")[seq(4)], "lightblue"),
    labels = c("LC 1: Settlements", "LC 2: Disturbed",
               "LC 3: Natural", "LC 4: Agriculture", "LC 5: Water"),
    title = "Reclassified landcover, Hula Valley"
  )

# save map
tmap_save(
  lc_map,
  filename = "figures/fig_lc_hula_reclass.png"
)

## Extract training data

# first get raster extent and convert to sf extent
lc_extent = extent(lc_reclass)
lc_samples = st_bbox(lc_extent) %>%
  st_as_sfc() %>%
  st_sample(size = 3000)

# save bounding box of points
hula_extent = lc_samples %>%
  st_bbox() %>%
  st_as_sfc() %>%
  `st_crs<-`(2039) %>%
  st_transform(4326)

st_write(
  hula_extent,
  dsn = "data/spatial/hula_extent",
  layer = "hula_bbox",
  driver = "ESRI Shapefile",
  append = F
)

# extract landcover
lc_vals = raster::extract(
  lc_reclass, as(lc_samples, "Spatial")
) %>%
  tibble() %>%
  rename(landcover = ".") %>%
  mutate(
    landcover = as.integer(landcover)
  )

# make sf dataframe
lc_training_data = st_as_sf(
  x = lc_vals,
  geometry = lc_samples
)

# remove NAs
lc_training_data = drop_na(lc_training_data)

# transform CRS to WGS84
lc_training_data = lc_training_data %>%
  `st_crs<-`(2039) %>%
  st_transform(4326)

# save as shapefile (because GEE requires)
st_write(
  lc_training_data,
  dsn = "data/spatial/lc_training_data",
  layer = "lc_training_points",
  driver = "ESRI Shapefile",
  append = FALSE
)
