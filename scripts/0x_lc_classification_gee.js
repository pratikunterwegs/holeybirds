// THIS SECTION COPIED FROM https://developers.google.com/earth-engine/tutorials/community/classify-maizeland-ng
var hula = ee.FeatureCollection("users/pratik_unterwegs/hula_bbox"),
    sentinel2 = ee.ImageCollection("COPERNICUS/S2"),
    table = ee.FeatureCollection("users/pratik_unterwegs/lc_training_data_vector");
    
// Import S2 TOA reflectance and corresponding cloud probability collections.
var s2 = ee.ImageCollection('COPERNICUS/S2');
var s2c = ee.ImageCollection('COPERNICUS/S2_CLOUD_PROBABILITY');

// Define dates over which to create a composite.
var start = ee.Date('2016-06-01');
var end = ee.Date('2016-09-30');

// Define a collection filtering function.
function filterBoundsDate(imgCol, aoi, start, end) {
  return imgCol.filterBounds(aoi).filterDate(start, end);
}

// Filter the collection by AOI and date.
s2 = filterBoundsDate(s2, hula, start, end);
s2c = filterBoundsDate(s2c, hula, start, end);

// Define a function to join the two collections on their 'system:index'
// property. The 'propName' parameter is the name of the property that
// references the joined image.
function indexJoin(colA, colB, propName) {
  var joined = ee.ImageCollection(ee.Join.saveFirst(propName).apply({
    primary: colA,
    secondary: colB,
    condition: ee.Filter.equals(
        {leftField: 'system:index', rightField: 'system:index'})
  }));
  // Merge the bands of the joined image.
  return joined.map(function(image) {
    return image.addBands(ee.Image(image.get(propName)));
  });
}

// Define a function to create a cloud masking function.
function buildMaskFunction(cloudProb) {
  return function(img) {
    // Define clouds as pixels having greater than the given cloud probability.
    var cloud = img.select('probability').gt(ee.Image(cloudProb));

    // Apply the cloud mask to the image and return it.
    return img.updateMask(cloud.not());
  };
}

// Join the cloud probability collection to the TOA reflectance collection.
var withCloudProbability = indexJoin(s2, s2c, 'cloud_probability');

// Map the cloud masking function over the joined collection, select only the
// reflectance bands.
var maskClouds = buildMaskFunction(50);
var s2Masked = ee.ImageCollection(withCloudProbability.map(maskClouds))
                   .select(ee.List.sequence(0, 12));

// Calculate the median of overlapping pixels per band.
var median = s2Masked.median();

// Calculate the difference between each image and the median.
var difFromMedian = s2Masked.map(function(img) {
  var dif = ee.Image(img).subtract(median).pow(ee.Image.constant(2));
  return dif.reduce(ee.Reducer.sum()).addBands(img).copyProperties(img, [
    'system:time_start'
  ]);
});

// Generate a composite image by selecting the pixel that is closest to the
// median.
var bandNames = difFromMedian.first().bandNames();
var bandPositions = ee.List.sequence(1, bandNames.length().subtract(1));
var mosaic = difFromMedian.reduce(ee.Reducer.min(bandNames.length()))
                 .select(bandPositions, bandNames.slice(1))
                 .clipToCollection(hula);

// Display the mosaic.
Map.addLayer(
    mosaic.clipToCollection(hula), {bands: ['B11', 'B8', 'B3'], min: 225, max: 4000}, 'S2 mosaic');

/// SELECT BANDS FOR SENTINEL DATA
// Specify and select bands that will be used in the classification.
var bands = [
  'B1',// 'B2', 'B3', 
  'B4', 
  //'B5', 'B6', 'B7', 
  'B8', 
  //'B8A', 'B9', 'B10', 
  'B11' //'B12'
];
var imageCl = mosaic.select(bands);

/// OVERLAY GROUND TRUTHED POINTS
// Load training points. The numeric property 'class' stores known labels.
var points = ee.FeatureCollection("users/pratik_unterwegs/lc_training_data_vector");

// convert to 0-N-1
// var points = points.remap([1, 2, 3, 4, 5], [0, 1, 2, 3, 4], "landcover")

// This property stores the land cover labels as consecutive
// integers starting from zero.
var label = 'landcvr';

// Overlay the training points on the imagery to get a training sample; include
// the crop classification property ('class') in the sample feature collection.
var training = imageCl
                   .sampleRegions({
                     collection: points,
                     properties: [label],
                     scale: 10,
                     tileScale: 8
                   })
                   .filter(ee.Filter.neq(
                       'B1', null)); // Remove null pixels
                       
/// RANDOM FOREST CLASSIFIER
// Train a random forest classifier with default parameters.
var trainedRf = ee.Classifier.smileRandomForest({numberOfTrees: 10}).train({
  features: training,
  classProperty: label,
  inputProperties: bands
});

// do the classification
var classifiedRf = imageCl.select(bands).classify(trainedRf);

// clip to HULA BOUNDS
var classified_hula = classifiedRf.clipToCollection(hula)

// Define visualization parameters for classification display.
var classVis = {min: 0, max: 5, palette: ["#8C0172","#964D3E","#9B951B","#6BD48C",'#f2c649', 'lightblue']};//, '484848']};

// var classVis = {min: 0, max: 4, palette: ["#8C0172","#964D3E","#9B951B","#6BD48C",'lightblue']};

Map.addLayer(points, {}, 'training_data');

// SEE CLASSIFICATION
Map.addLayer(
    classified_hula, classVis, 'Classes (RF)');

// EXPORT DATA
// export to google drive
Export.image.toDrive({
  image: classified_hula,
  description: 'hula_vector_classified_sentinel',
  scale: 10,
  region: hula.geometry()});
