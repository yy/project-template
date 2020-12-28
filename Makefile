PROJ_NAME=PROJ_NAME

.PHONY: all dryrun test create_conda_env build_conda_env report create_env create_ipykernel


all:
	snakemake --cores all -r -p 

dryrun:
	snakemake -n -r -p

dag.svg: workflow/Snakefile
	snakemake --dag | dot -Tsvg > dag.svg

test:
	pytest

create_conda_env:
	conda create -n $(PROJ_NAME) -c bioconda -c conda-forge python=3.8 snakemake jupyterlab pandas nb_conda black isort flake8 pytest neovim snakefmt

export_conda_env:
	conda env export > environment.yml

build_conda_env:
	conda env create -f environment.yml

create_env:
	python3 -m venv $(PROJ_NAME)-env

create_ipykernel:
	python3 -m ipykernel install --user --name=$(PROJ_NAME)
