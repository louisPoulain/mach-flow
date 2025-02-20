#!/bin/bash

# RUN FROM PROJECT DIRECTORY! 

#####################################################
# Environment setup for conda environment $ENVNAME  #
#####################################################

ENVNAME="machflow"

# Go to base conda environment
eval "$(conda shell.bash hook)"
source /usr/local/Miniconda3/etc/profile.d/conda.sh
conda activate base \
    || { echo '>>> Activating base failed.'; exit 1; }

# Check if the environment exists
if ! conda info --envs | grep -q "$ENVNAME"; then
    echo ">>> Environment '$ENVNAME' does not exist. Skipping removal."
else
    # Remove the environment if it exists
    conda remove --yes --name $ENVNAME --all || { echo '>>> Removing environment failed.'; exit 1; }
fi

# Create environment
conda create --yes --name $ENVNAME python=3.10 \
    pytorch torchvision torchaudio lightning \
    numpy scikit-learn optuna optuna-integration \
    pandas xarray dask netcdf4 zarr geopandas \
    matplotlib seaborn cartopy plotly contextily \
    jupyterlab nodejs pymysql \
    pvlib-python \
    imagemagick \
    -c pytorch -c nvidia \
    || { echo '>>> Creating environment failed.'; exit 1; }

# Activate environment
conda activate $ENVNAME \
    || { echo '>>> Activating environment failed.'; exit 1; }

# Install pip packages
pip install torch_geometric dask-labextension pyreadr tensorboard flake8 kaleido \
    'jsonargparse[signatures]>=4.18.0' omegaconf jupyterlab-optuna \
    || { echo '>>> Installing pip packages failed.'; exit 1; }

# Add mach-flow in editable mode
pip install -e .
