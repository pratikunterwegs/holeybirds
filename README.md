
# Source code for _Direct effects of flight feather molt on bird movement and habitat selection_

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
<!-- [![DOI:10.1101/2020.12.15.422876](https://img.shields.io/badge/bioRxiv-doi.org/10.1101/2020.12.15.422876-<COLOR>?style=flat-square)](https://www.biorxiv.org/content/10.1101/2020.12.15.422876v3) -->
<!-- [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4287462.svg)](https://doi.org/10.5281/zenodo.4287462) -->

This is the source code for a manuscript that investigates the habitat use and movement strategies of four resident sub-tropical bird species during wing-moult, the process of replacing damaged flight feathers.

## Contact and Attribution

Please contact Pratik Gupte, Yosef Kiat, or Ran Nathan (PI) for questions about the project.

```md
Name: Pratik Rajan Gupte
Email: pratikgupte16@gmail.com OR p.r.gupte@rug.nl
ORCID: https://orcid.org/0000-0001-5294-7819

Name: Yosef Kiat
Email: yosef.kiat@gmail.com

Name: Ran Nathan
Email: r.nathan@huji.ac.il
```

Cite this repository archived on Zenodo as:

## Project Data

The data used for this the manuscript are available on Zenodo/Dryad/other.

Please cite the project data as:

---

## Notes on reproducibility

- The project uses both R and Python code. R is used for most biologically relevant analyses, while Python is used to handle large raster data.

- R package versions are logged using the _renv_ package management paradigm, in the `renv.lock` file. Opening an R session in this directory, or opening the `holeybirds.Rproj` project in RStudio, will automatically prompt restoration of the _renv_ environment. This means downloading and installing specific versions of the packages we used - this may take some time.

  To do this manually, run `renv::retore()` from an R terminal.

- Python 3 package versions are logged using the _conda_ package manager, in the `python_requirements.txt` file. This can be recreated by installing _Anaconda_ or _Miniconda_ and running `conda create --name YOUR_ENV_NAME --file python_requirements.txt` from the shell (not from the Python console). This installs all packages with the versions we used - this may take some time.

## Workflow

In brief, the analysis workflow is to run the files in the `scripts/` folder in numbered order. These create the intermediate outputs (summary data files), and also produce the main text figures.

### Prepare environmental layers

The code to prepare environmental layers from raw remote sensing data to raster layers that can be used in the analyses is written in Python. This is because (1) we use the Python API for Google Earth Engine, and (2) Python's `rioxarray` package allows quick raster downsampling of the canopy height model.

- `scripts/00_get-sentinel-ndvi.py` Get vegetation productivity in the study area (NDVI; June - October 2016) using the Python API for Google Earth Engine.

- `scripts/00_resample-chm.py` Downsample the manually acquired canopy height model from 50cm resolution to 1m resolution.

### Analysis Source Code

The source code for the analyses reported here can be found in the directory `scripts/` as literate programming `Rmd` files, and are explained briefly here:

- `scripts/01_prepare-by-id.Rmd` Separate the raw tracking data, provided as SQL databases, into csv files with one file per individual. Get basic metrics such as total tracking duration for each individual, and link these summary statistics to individuals' daily estimated wing gap index.

- `scripts/02_preprocess-data.Rmd` Reproducible data pre-processing for tracking data. Pre-processing steps and outcomes for each individual (e.g. data remaining after cleaning), are written to `data/log_preprocessing.log`.

- `scripts/03_swallow_movement.Rmd` Quantify the daily distance moved by barn swallows from pre-processed tracking data, and fit a GAM for distance per hour of tracking to wing gap index, and plots this data as main text **Figure 2**.

- `scripts/04_residence-patch.Rmd` Segment-cluster the pre-processed tracking data of white-spectacled bulbuls, house sparrows, and clamorous reed warblers, into residence patches following Gupte et al. (2022) (https://besjournals.onlinelibrary.wiley.com/doi/10.1111/1365-2656.13610).

- `scripts/05_patch_metrics.Rmd` Get environmental covariates - NDVI and visibility index - at the residence patches of bulbuls, sparrows, and reed warblers, and link individual wing gap index data with the patch data (i.e., space-use). Quantify movements between patches per hours of tracking, and fit a GAM of between patch movements in relation to wing gap index. Plot distance moved between patches in relation to wing gap index as main text **Figure 1**.

- `scripts/06_prep-patches-ssf.Rmd` For every individual's daily patch-switch sequence, create a single `amt` _steps_ object. Sample 9 alternative patch centroids for every between patch movement, and sample 15 locations around this centroid. Get the environmental covariates - NDVI and visibility - at each real and alternative patch, and prepare the data for a quasi-step selection analysis.

- `scripts/07_real-alt-patches-vis.Rmd` Model the effect of wing gap index on the visibility of patches actually used by birds using a GAM. Implement a quasi-step selection analysis to compare, for each species, and for each of three moult statuses, the species-level preference for sheltered habitats and vegetation productivity using a logistic regression. Plot the visibility of real and alternative patches in relation to wing gap index as main text **Figure 3**.

- `scripts/spm_01_wing_gap_change.Rmd` Plot the forecasted, per-individual change in wing gap index over the days since measurement. Creates supplementary material **Figure S1**.

- `scripts/spm_02_landscape.Rmd` Plot the landcover classification of the landscape, the NDVI, and the visibility index, as supplementary material **Figure S2**. Model the relationship between vegetation productivity (NDVI) and visibility using a GAM, with landcover class-specific fits. Plot the model fits as supplementary material **Figure S3**.

---

### Figures

Contains the main text and supplementary material figures.

---

## Other Directories

- `bash/` Some useful shell scripts for output rendering.

- `renv/` Contains instructions to reproduce the project's R package environment, including version data, for better reproducibility. R package versions are stored in `./renv.lock`. The structure of the `renv` files is automatically created using the `renv` package (see https://rstudio.github.io/renv/articles/renv.html).
