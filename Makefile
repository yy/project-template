.PHONY: all dryrun paper monitor test lint format format-check dashboard check

all:
	cd workflow && uv run snakemake --cores all --printshellcmds

dryrun:
	cd workflow && uv run snakemake --dry-run --printshellcmds

paper:
	$(MAKE) -C paper/current main

monitor:
	$(MAKE) -C paper/current monitor

test:
	uv run pytest

lint:
	uv run ruff check .

format:
	uv run ruff format .

format-check:
	uv run ruff format --check .

dashboard:
	uv run python dashboard/build.py

check: lint format-check test dryrun
