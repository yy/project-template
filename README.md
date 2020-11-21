# Project template

A simple template for research project repos. Also check out [data science and
reproducible science cookie
cutters](https://github.com/audreyr/cookiecutter#data-science).

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

1. `libs` for librares for the project.
1. `data` for raw & derived datasets. 
1. `exps` for (timestamped) experiment notebooks.
1. `paper` for manuscripts.
1. `workflow` for workflow scripts.
1. `.gitignore` for temporary and binary files to be ignored by git (LaTeX, Python, Jupyter, data files, etc.)

## Using Python virtual environment

Change the `PROJ_NAME` variable in `Makefile` to your project name. 

### with virtualenv

Running the following will create a virtual environment inside `PROJNAME_env` directory:

```
make create_env
```

You can activate the virtual environment by running 

```
source PROJNAME_env/bin/activate
```

and deactivate by 

```
deactivate
```

After activating the virtual environment, you can run 

```
make create_ipykernel
```

to create the `ipykernel` for Jupyter. Use `pip` to install packages. For the
project package, use `pip install -e` command to install it as an "editable"
package that does not require reinstallation after changes. 


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

Use `conda install` to install packages.  For the project package, use `pip
install -e` command to install it as an "editable" package that does not
require reinstallation after changes. 

Thanks to `nb_conda` package, you don't need to individually install
`ipykernel` for Jupyter. 

