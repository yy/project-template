Output from experiments: figures, tables, and other artifacts.

## Structure

```
results/
├── figures/       # Plots and visualizations
├── tables/        # CSV/LaTeX tables
├── numbers.csv    # every number the paper cites: name, value, format, source, description
├── numbers.tex    # the same numbers as LaTeX commands, rendered from numbers.csv
└── exports/       # Other outputs (embeddings, predictions, etc.)
```

Use timestamped subfolders for experiment runs if needed:
```
results/figures/20240115_baseline/
```

## Tips

- Generate figures programmatically from `workflow/` or notebooks
- Save both raster (PNG) and vector (PDF/SVG) formats for publications
- Keep figures referenced in `paper/` here for single source of truth
- Never type a computed number into the paper: add it to `workflow/scripts/paper_numbers.py`, which writes `numbers.csv`, and use its command (`\nExampleRows{}`) in the text
