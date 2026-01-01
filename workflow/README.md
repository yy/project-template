Workflow scripts for data processing, simulations, and figure generation.

Uses [Snakemake](https://snakemake.readthedocs.io/) for reproducible pipelines.

## Structure

```
workflow/
├── Snakefile            # Main workflow definition
├── config.template.yaml # Copy to config.yaml and customize
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
snakemake -n -r -p          # Dry run
snakemake --cores all -r -p # Run with all cores
```

## Tips

- Import from `src/project_name` in scripts for shared code
- Use `config.yaml` for paths and parameters
- Keep scripts focused; one script per output
