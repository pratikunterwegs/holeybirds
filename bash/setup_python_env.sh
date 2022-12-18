#!/bin/bash

# script to create conda environment
conda create -p ./envs

# command to activate the conda environment
conda activate ./envs

# install the geemap package and the earthengine-api package if necessary
conda install -c conda-forge geemap
conda install -c conda-forge earthengine-api
conda install --channel conda-forge geopandas
conda install -c conda-forge rasterio
conda install -c conda-forge rioxarray

# from the conda terminal install the ipython kernel to use with notebooks
python -m ipykernel install

# record python/conda environment
conda list --explicit > python_requirements.txt

# TO RESTORE THE CONDA ENVIRONMENT
conda create --name conda_env_holeybirds --file python_requirements.txt
conda install --name conda_env_holeybirds --file python_requirements.txt
