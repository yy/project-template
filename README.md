# Project template

A simple template for research project repos. You can also use [data science and reproducible science cookie cutters](https://github.com/audreyr/cookiecutter#data-science).

## Project structure

This template contains the following folders and files. See `README.md` in each folder for more details and guidelines.

1. `data` for raw & derived datasets.
1. `libs` for libraries for the project.
1. `models` for trained models.
1. `notebooks` for (timestamped) experiment notebooks.
1. `paper` for manuscripts.
1. `results` for results (figures, tables, etc.)
1. `workflow` for workflow files and scripts.
1. `.gitignore` for temporary and binary files to be ignored by git (LaTeX, Python, Jupyter, data files, etc.)

## Using Python virtual environment

Use `uv` to create a virtual environment.

```sh
uv venv
```

`.envrc` allows automatic activation of virtual environment. See [direnv](https://yyiki.org/search/Software/direnv).

Create `pyproject.toml` file and add necessary packages.

```sh
uv init
uv add PACKAGE_NAME
```

Once `pyproject.toml` file is created, you can use `uv sync` to synchronize the virtual environment.

```sh
uv sync
```

If you want to add the local project package and keep it editable, use `uv add -e` command.

```sh
uv add . --editable
```
