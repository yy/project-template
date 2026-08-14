Use `main.tex` for the paper and `supp.tex` for supplementary material.

The local `Makefile` uses Latexmk for fast standalone paper builds:

```sh
make main          # Build the main paper once
make monitor       # Rebuild the main paper after each source change
make supp          # Build the supplement
make cover         # Build the cover document
make clean         # Remove generated LaTeX files
```

The project Snakefile invokes `make main` here after its declared analysis outputs are ready, making `main.pdf` the final pipeline target. Keep a single `main.tex` by default; split it into section files only when simultaneous editing makes that useful. For asynchronous work, a single file plus pull requests may be simpler.
