#!/bin/bash

# script to create conda environment
conda create --name conda_env_holeybirds

# command to activate the conda environment
conda activate conda_env_holeybirds

# install the geemap package and the earthengine-api package if necessary
conda install -c conda-forge geemap
conda install -c conda-forge earthengine-api
conda install --channel conda-forge geopandas

# from the conda terminal install the ipython kernel to use with notebooks
python -m ipykernel install

# record python/conda environment
conda list -e > python_requirements.txt
