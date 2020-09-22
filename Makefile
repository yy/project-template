.PHONY: test create_env build_env 

test:
	pytest

create_env:
	conda create -n $(shell basename $(CURDIR)) -c bioconda -c conda-forge python=3.7 ipykernel snakemake

build_env:
	conda env create -f environment.yml
