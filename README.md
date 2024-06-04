# Project template

A simple template for research project repos. You can also use [data science and reproducible science cookie cutters](https://github.com/audreyr/cookiecutter#data-science).

## Installation

Run the following

```
./install.sh PATH_TO_YOUR_PROJECT_REPO
```

For instance, 

```
./install.sh ../my_project/
```

This script creates the following folders and files. 

1. `data` for raw & derived datasets. 
1. `libs` for librares for the project.
1. `models` for trained models.
1. `notebooks` for (timestamped) experiment notebooks.
1. `paper` for manuscripts.
1. `results` for results (figures, tables, etc.)
1. `workflow` for workflow files and scripts.
1. `.gitignore` for temporary and binary files to be ignored by git (LaTeX, Python, Jupyter, data files, etc.)

## Using Python virtual environment

Change the `PROJ_NAME` variable in `Makefile` to your project name. 
Then create a virtual environment either with Python's vanilla `virtualenv` module or with [Anaconda](https://www.anaconda.com/).
You can also use tools like `poetry`. 

`.envrc` allows automatic activation of virtual environment. See [direnv](https://yyiki.org/search/Software/direnv). 

### with `uv`

Create a virtual environment in the current directory (inside `.venv`). 

```sh
uv venv
source .venv/bin/activate
```

Create a `requirements.in` file that lists high-level package requirements. For instance, 

```sh
pandas
matplotlib
jupyter

# local libraries
-e ./libs/xxxx
```

Install them directly or create a lock file first (note that this lock file is platform-specific and may not translate into other systems) and then install it. 

```sh
uv pip install -r requirements.in
```

```sh
uv pip compile requirements.in -o requirements.txt
uv pip install -r requirements.txt
```


### Anaconda

First create a virtual environment for the project.

```
make create_conda_env
```

and activate it with

```
conda activate PROJNAME
```

or deactivate it with

```
conda deactivate
```

Use `conda install` to install packages. Thanks to `nb_conda` package, you
don't need to individually install `ipykernel` for Jupyter. 

## Using a project package 

For the project package, use `pip install -e` command to install it as an
_"editable"_ package that does not require reinstallation after changes. 

