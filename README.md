# Project template

A simple template for research project repos. You can also use [data science and reproducible science cookie cutters](https://github.com/audreyr/cookiecutter#data-science).

## Project structure

This template contains the following folders and files. See `README.md` in each folder for more details and guidelines.

1. `src` for project source code (installed as editable package).
1. `tests` for unit tests.
1. `data` for raw & derived datasets.
1. `libs` for third-party or vendored packages.
1. `models` for trained models.
1. `notebooks` for (timestamped) experiment notebooks.
1. `paper` for manuscripts.
1. `results` for results (figures, tables, etc.)
1. `workflow` for workflow files and scripts.
1. `.gitignore` for temporary and binary files to be ignored by git (LaTeX, Python, Jupyter, data files, etc.)

## Python environment

This template uses [uv](https://docs.astral.sh/uv/) for Python environment management. Run the setup script for initial configuration:

```sh
./setup.sh          # Install dependencies and configure environment
```

### Key files

- `.python-version` — specifies the required Python release
- `.venv/` — virtual environment directory (created by uv)
- `pyproject.toml` — project metadata and dependency declarations
- `uv.lock` — reproducible dependency snapshot (commit to version control)
- `.envrc` — [direnv](https://direnv.net/) configuration for automatic venv activation

### Common commands

```sh
uv add PACKAGE      # Add dependency
uv sync             # Install from lockfile
uv run script.py    # Run script in virtual environment
```

See [Python environment setup](https://yyahn.com/wiki/Python/Environment%20setup/) for details.

## Linting and formatting

[ruff](https://docs.astral.sh/ruff/) is included as a dev dependency. VS Code settings (`.vscode/settings.json`) enable format on save.

### Pre-commit hooks

Install hooks to auto-run ruff and tests before commits:

```sh
uv add --dev pre-commit
uv run pre-commit install
```

## For AI coding agents

Use the following instructions to initialize. 

Commands:
- `uv sync` — install dependencies
- `uv run pytest` — run tests
- `uv run ruff check .` — lint
- `uv run ruff format .` — format
- `make all` — run Snakemake pipeline

Conventions:
- Write clean code accompanied by well-designed tests. 
- Use type hints for all function signatures. 
- Import project code as `from project_name import ...`. 
- Put reusable code in `src/`, not in notebooks or workflow scripts. 
- Timestamp experiment folders: `YYYYMMDD_description`. 
