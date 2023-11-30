#!/bin/bash

# RUN FROM PROJECT DIRECTORY! 

#####################################################
# Environment setup for conda environment $ENVNAME  #
#####################################################

ENVNAME="machflow"

# Go to base conda environment
eval "$(conda shell.bash hook)"
source $CONDA_PREFIX/etc/profile.d/mamba.sh
mamba activate base \
    || { echo '>>> Activating base failed.'; exit 1; }

# Remove environment if exists
mamba remove --yes --name $ENVNAME --all \
    || { echo '>>> Removing environment failed.'; exit 1; }

# Create environment
mamba create --yes --name $ENVNAME python=3.10 \
    pytorch==2.0.1 torchvision==0.15.2 torchaudio==2.0.2 pytorch-cuda=11.7 pytorch-lightning \
    numpy scikit-learn optuna \
    pandas xarray dask netcdf4 zarr \
    matplotlib seaborn cartopy plotly \
    jupyterlab nodejs pymysql \
    pvlib-python \
    -c pytorch -c nvidia \
    || { echo '>>> Creating environment failed.'; exit 1; }

# Activate environment
mamba activate $ENVNAME \
    || { echo '>>> Activating environment failed.'; exit 1; }

# Install pip packages
pip install torch_geometric dask-labextension pyreadr tensorboard flake8 'jsonargparse[signatures]>=4.18.0' \
    kaleido jupyterlab-optuna \
    || { echo '>>> Installing pip packages failed.'; exit 1; }

# Add mach-flow in editable mode
pip install -e .
