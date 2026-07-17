Workflow scripts for data processing, simulations, and figure generation.

Uses [Snakemake](https://snakemake.readthedocs.io/) for reproducible pipelines.

## Structure

```
workflow/
├── Snakefile            # Main workflow definition
├── config.yaml          # Project paths and parameters
├── scripts/             # Python scripts called by Snakemake
└── logs/                # Workflow logs (gitignored)
```

## Usage

```
make dryrun    # Preview what will run
make all       # Run the full pipeline
```

Or directly:
```
cd workflow
uv run snakemake --dry-run
uv run snakemake --cores all
```

## Tips

- Import from `src/project_name` in scripts for shared code
- Use `config.yaml` for paths and parameters
- Keep scripts focused; one script per output
