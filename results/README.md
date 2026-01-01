Output from experiments: figures, tables, and other artifacts.

## Structure

```
results/
├── figures/       # Plots and visualizations
├── tables/        # CSV/LaTeX tables
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
