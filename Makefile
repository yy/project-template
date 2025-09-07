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
