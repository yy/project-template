PROJ_NAME=PROJ_NAME

.PHONY: all dryrun test

all:
	snakemake --cores all -r -p

dryrun:
	snakemake -n -r -p

dag.svg: workflow/Snakefile
	snakemake --dag | dot -Tsvg > dag.svg

test:
	uv run pytest
