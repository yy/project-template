# Project instructions

## Setup and checks

- Run `uv sync` to install dependencies.
- Run `make check` before considering a change complete.
- Use `make all` to run the Snakemake workflow.

## Conventions

- Write clean code with focused tests.
- Use type hints for all function signatures.
- Import project code as `from project_name import ...`.
- Put reusable code in `src/`, not in notebooks or workflow scripts.
- Timestamp experiment folders as `YYYYMMDD_description`.

## Project status

After meaningful project work, update `dashboard/status.toml` with verified status, ownership, and next actions.
Use `Unassigned` rather than guessing an owner.
Run `make dashboard` to regenerate the local HTML view.
