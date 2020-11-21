PROJ_NAME=PROJ_NAME

.PHONY: all test create_conda_env build_conda_env report create_env create_ipykernel


all:
	snakemake --cores all

report:
	snakemake --report report.html

test:
	pytest

create_conda_env:
	conda create -n $(PROJ_NAME) -c bioconda -c conda-forge python=3.8 snakemake jupyterlab pandas nb_conda black isort flake8 pytest neovim

export_conda_env:
	conda env export > environment.yml

build_conda_env:
	conda env create -f environment.yml

create_env:
	virtualenv $(PROJ_NAME)_env

create_ipykernel:
	python -m ipykernel install --user --name=$(PROJ_NAME)
