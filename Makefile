.PHONY: all dryrun test lint format

all:
	snakemake --cores all -r -p

dryrun:
	snakemake -n -r -p

dag.svg: workflow/Snakefile
	snakemake --dag | dot -Tsvg > dag.svg

test:
	uv run pytest

lint:
	uv run ruff check .

format:
	uv run ruff format .
