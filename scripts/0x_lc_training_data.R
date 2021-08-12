library(raster)
library(tmap)
library(sf)

#### Training Data from HaMaraag LC ####

# get landcover
lc <- raster("data/rasters/raster_hula_lc.tif")

# reclassify
lc_vals <- unique(raster::values(lc))
new_lc_vals <- floor(lc_vals / 10)

reclass_matrix <- cbind(
  lc_vals,
  new_lc_vals
)

lc_reclass <- raster::reclassify(
  lc,
  rcl = reclass_matrix
)

# save
writeRaster(
  lc_reclass,
  filename = "data/rasters/raster_hula_lc_reclass.tif"
)

# make map
lc_map <-
  tm_shape(lc_reclass) +
  tm_raster(
    style = "cat",
    palette = c(scico::scico(5, palette = "hawaii")[seq(4)], "lightblue"),
    labels = c(
      "LC 1: Settlements", "LC 2: Disturbed",
      "LC 3: Natural", "LC 4: Agriculture", "LC 5: Water"
    ),
    title = "Reclassified landcover, Hula Valley"
  )

# first get raster extent and convert to sf extent
lc_extent <- extent(lc_reclass)
lc_samples <- st_bbox(lc_extent) %>%
  st_as_sfc() %>%
  st_sample(size = 3000)

# save bounding box of points
hula_extent <- lc_samples %>%
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
lc_vals <- raster::extract(
  lc_reclass, as(lc_samples, "Spatial")
) %>%
  tibble() %>%
  rename(landcover = ".") %>%
  mutate(
    landcover = as.integer(landcover)
  )

# make sf dataframe
lc_training_data <- st_as_sf(
  x = lc_vals,
  geometry = lc_samples
)

# remove NAs
lc_training_data <- drop_na(lc_training_data)

# transform CRS to WGS84
lc_training_data <- lc_training_data %>%
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

# save map
tmap_save(
  lc_map,
  filename = "figures/fig_lc_hula_reclass.png"
)

#### Training Data from Vectorised LC ####

# get hula landcover types for retraining
hula_lc_vector <- st_read(
  dsn = "data/spatial/hula_lc_vector"
)

tm_shape(hula_lc_vector) +
  tm_polygons(col = "Name")

## sample across LC
lc_samples_vector <- st_sample(
  hula_lc_vector,
  size = 10000, type = "hexagonal"
)

# first get intersection of points with polygon
row_id <- st_covered_by(lc_samples_vector, hula_lc_vector) |>
  sapply(first)

# make df with LC type
lc_training_data_vector <- tibble(
  landcover = hula_lc_vector$Name[row_id]
)

# make sf
lc_training_data_vector <- st_sf(
  lc_training_data_vector,
  geometry = lc_samples_vector
)

# rename cols
lc_training_data_vector <- mutate(
  lc_training_data_vector,
  land_cover_class = landcover,
  landcover = as.numeric(as.factor(landcover)) - 1
)

lc_training_data_vector <- st_transform(
  lc_training_data_vector,
  4326
)

# save as shapefile for GEE
st_write(
  lc_training_data_vector,
  dsn = "data/spatial/lc_training_data_vector",
  layer = "lc_training_data_vector",
  driver = "ESRI Shapefile",
  append = FALSE
)
