# Project template

A simple template for research project repos. Also check out [data science and
reproducible science cookie
cutters](https://github.com/audreyr/cookiecutter#data-science).

## Installation

Run the following

    ./install.sh YOUR_PROJECT_REPO_FOLDER

This script creates

1. a `libs` folder for a software library for the project.
1. a `data` folder for datasets and scripts for downloading datasets.
1. a `exps` folder for timestamped experiments.
1. a `paper` folder for manuscripts.
1. a `workflow` folder for workflow scripts.
1. a `.gitignore` file that lists temporary and binary files to ignore (LaTeX, Python, Jupyter, data files, etc. )

## Set up

### Anaconda

First create a virtual environment for the project.

    conda create -n project_env_name
    conda activate project_env_name

Install `ipykernel` for Jupyter.

    conda install ipykernel

Create a kernel for the virtual environment that you can use in Jupyter lab/notebook.

    python -m ipykernel --user --name project_env_kernel_name
