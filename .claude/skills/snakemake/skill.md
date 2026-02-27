# Snakemake Style Guide

Follow these conventions whenever creating or modifying Snakemake workflows.

When starting a new project, copy `utils.smk` from this skill directory (`.claude/skills/snakemake/utils.smk`) to the project root.

---

## 1. Project Organization

```
project/
├── Snakefile                      # Main entry point: config, globals, params, includes
├── utils.smk                      # Custom utility functions (copy from this skill)
├── workflow/
│   ├── config.template.yaml       # Config template (users copy to config.yaml)
│   ├── rules/                     # Rule files, one per logical workflow stage
│   │   ├── stage_a.smk
│   │   ├── stage_b.smk
│   │   └── ...
│   ├── scripts_category_1/        # Scripts grouped by purpose (stats/, fitting/, plot/, etc.)
│   ├── scripts_category_2/
│   └── preprocessing/{dataset}/   # Dataset-specific ingestion, each with its own Snakefile
│       ├── Snakefile
│       └── scripts/
└── data/                          # DATA_DIR (path set in config.yaml)
    └── {dataset}/
        ├── preprocessed/          # Raw/cleaned inputs
        ├── derived/               # All computed outputs (models, simulations, etc.)
        └── plot_data/             # Aggregated data for figures
```

### Key Principles

- **Rules** go in `workflow/rules/*.smk`, grouped by logical workflow stage.
- **Scripts** go in `workflow/<category>/`, grouped by purpose (not by rule file). Multiple rule files can point to scripts in the same category directory.
- **Data flows through tiers**: `preprocessed/` (inputs) -> `derived/` (computed) -> `plot_data/` (for figures).
- **One config file** (`workflow/config.yaml`) holds all environment-specific paths. Provide a `config.template.yaml` as a checked-in template.

---

## 2. Main Snakefile Conventions

```python
from os.path import join as j    # Always alias join as j
import numpy as np

# Include utilities FIRST
include: "./utils.smk"

# Load config
configfile: "workflow/config.yaml"

# === Global constants (UPPER_CASE) ===
DATA_DIR = config["data_dir"]
DERIVED = "derived"
DATA_LIST = ["dataset_a", "dataset_b"]
AVAILABLE_GPUS = [1, 2, 3, 4, 5, 6]

# === Parameter dicts (lowercase, values always LISTS) ===
params_my_model = {
    "dim": [64],
    "lr": [0.001],
    "method": ["spherical"],
}

# === Paramspace objects (constructed from param dicts) ===
my_paramspace = to_paramspace(params_my_model)
# my_paramspace.wildcard_pattern == "dim~{dim}_lr~{lr}_method~{method}"

# === File path templates (UPPER_CASE, use j() and {wildcards}) ===
# Simple paths: use raw {wildcards}
INPUT_NET = j(DATA_DIR, "{data}", "preprocessed", "net.npz")
INPUT_TABLE = j(DATA_DIR, "{data}", "preprocessed", "table.csv")
# Parameterized paths: embed wildcard_pattern via f-string
MODEL_FILE = j(DATA_DIR, "{data}", DERIVED, f"model_{my_paramspace.wildcard_pattern}.pt")
# Expands to: data/{data}/derived/model_dim~{dim}_lr~{lr}_method~{method}.pt

# === Include sub-workflows ===
include: "workflow/rules/stage_a.smk"
include: "workflow/rules/stage_b.smk"

# === Master target rule ===
rule all:
    input:
        rules.stage_a_all.input,
        rules.stage_b_all.input,
```

### Naming Rules

| Thing | Convention | Example |
|-------|-----------|---------|
| File path constants | `UPPER_CASE` | `CITATION_NET`, `MODEL_FILE`, `FIG_DEGREE_DIST` |
| Parameter dicts | `lowercase_with_underscores` | `params_spherical_model` |
| Paramspace objects | `lowercase_with_underscores` | `spherical_model_paramspace` |
| Rule names | `snake_case` | `calc_degree_distribution`, `plot_citation_rate` |
| Wildcard names | `camelCase` or `snake_case` | `{data}`, `{sample}`, `{timeWindow}` |
| Dataset/constant lists | `UPPER_CASE` | `DATA_LIST`, `SIM_NET_SAMPLE_IDS` |

---

## 3. Utility Functions (utils.smk)

The project root must contain `utils.smk` (copy from `.claude/skills/snakemake/utils.smk`). Include it at the top of every Snakefile with `include: "./utils.smk"`.

It provides these functions:

### `to_paramspace(dict_or_list_of_dicts)` — Create a Paramspace

Converts parameter dicts into a Snakemake `Paramspace`. Generates the Cartesian product of all values. The resulting `wildcard_pattern` uses `~` as the key-value separator.

**This is the standard way to create parameterized file paths.** The three-step flow:

```python
# Step 1: Define parameter dict (values are always lists)
params_my_model = {
    "dim": [64, 128],
    "c0": [5, 20],
}

# Step 2: Create paramspace
my_paramspace = to_paramspace(params_my_model)
# my_paramspace.wildcard_pattern == "dim~{dim}_c0~{c0}"

# Step 3: Use wildcard_pattern in file path constants
MODEL_FILE = j(DATA_DIR, "{data}", DERIVED, f"model_{my_paramspace.wildcard_pattern}.pt")
# Produces: data/{data}/derived/model_dim~{dim}_c0~{c0}.pt
```

Accepts a single dict or a list of dicts (merged):

```python
ps = to_paramspace([{"dim": [64]}, {"c0": [20]}])  # Same as single merged dict
```

### `expand(filename, *param_dicts, **params)` — Expand file paths

Custom replacement for Snakemake's built-in `expand()`. **Always use this instead of Snakemake's.**

Key difference: unfilled wildcards remain as `{name}` (via `partial_format`) instead of raising an error. This enables staged expansion where Snakemake resolves remaining wildcards at runtime.

```python
# Basic (like Snakemake expand, but with partial_format support)
expand(FILENAME, data=DATA_LIST, sample=[0, 1, 2])

# With param dict as positional arg (expands all combinations from the dict)
expand(FILENAME, params_my_model, data=DATA_LIST)

# Multiple param dicts + extra keyword params
expand(FILENAME, params_dict_a, params_dict_b, sample=SAMPLE_IDS)
```

### `partial_format(template, **kwargs)` — Partial wildcard substitution

Fill in some wildcards, leave the rest untouched:

```python
partial_format("net_{data}_model~{model}_sample~{sample}.npz", data="aps")
# Returns: "net_aps_model~{model}_sample~{sample}.npz"
```

### `make_filename(prefix, ext, names)` — Build filename templates

```python
make_filename("model", "pt", ["dim", "c0"])
# Returns: "model_dim={dim}_c0={c0}.pt"
```

---

## 4. Filename & Parameter Conventions

### Filenames Encode Parameters with `~`

Parameters in filenames use `key~value` pairs separated by `_`:

```
model_dim~64_c0~20.pt
net_model~PA_sample~0.npz
stats_timeWindow~5.csv
```

This comes from `Paramspace` with `filename_params="*"`. Never manually construct these patterns — always use `to_paramspace()` and its `wildcard_pattern`.

### Parameter Dicts: Values Are Always Lists

Even single values must be wrapped in a list:

```python
params = {
    "dim": [64],              # Single value — still a list
    "c0": [5, 10, 20],        # Sweep — multiple values
    "method": ["spherical"],   # String value
}
```

### File Path Templates: Always UPPER_CASE

```python
# Define as module-level constants in the .smk file or Snakefile
TRAIN_NET = j(DATA_DIR, "{data}", DERIVED, "prediction", "train_net-{t_train}.npz")
SIM_NET_FILE = j(DATA_DIR, "{data}", DERIVED, "simulated_networks",
    f"net_{my_paramspace.wildcard_pattern}_sample~{{sample}}.npz")
#                                                       ^^ double braces for literal {sample} in f-string

FIG_DEGREE_DIST = j(FIG_DIR, "{data}", "degree-dist.pdf")
```

### Expanding for Target Rules

```python
rule stage_a_all:
    input:
        expand(OUTPUT_FILE, data=DATA_LIST),
        expand(SIM_NET_FILE, params_my_model, data=DATA_LIST, sample=SAMPLE_IDS),
```

---

## 5. Writing Rules

### Basic Rule

```python
rule calc_something:
    input:
        net_file = INPUT_NET,                          # Always use NAMED inputs
        table_file = INPUT_TABLE,
    output:
        output_file = OUTPUT_SOMETHING                 # Always use NAMED outputs
    params:
        groupby = lambda wildcards: (                  # Lambda for conditional params
            "category" if wildcards.data == "dataset_a" else None
        ),
    script:
        "../scripts_dir/calc-something.py"             # Relative to the .smk file
```

### Rules with Resources

```python
rule fit_model:
    input:
        net_file = INPUT_NET,
    output:
        output_file = MODEL_FILE
    params:
        dim = lambda wildcards: wildcards.dim,         # Forward wildcards as params
        c0 = lambda wildcards: wildcards.c0,
        gpus = AVAILABLE_GPUS,                         # Pass GPU list to script
    resources:
        gpu = 1                                        # Snakemake tracks GPU allocation
    threads: 4
    script:
        "../fitting/fit-model.py"
```

### Lambda Wildcards

Use `lambda wildcards:` to pass wildcard values or compute conditional params:

```python
params:
    dim = lambda wildcards: wildcards.dim,             # Pass wildcard directly
    label = lambda wildcards: "Legal" if wildcards.data == "caselaw" else "Science",
    resolution = lambda wildcards: 5 if wildcards.data in ["aps", "caselaw"] else 1,
    static_param = "fixed_value",                      # No lambda needed for constants
```

### Wildcard Constraints

```python
rule generate_network_ltcm:
    wildcard_constraints:
        model = "LTCM"
    input: ...
    output: ...
```

### Master Aggregation Rules

Every `.smk` file defines one master rule that collects all its outputs. The main Snakefile's `rule all:` references them:

```python
# In workflow/rules/stage_a.smk:
rule stage_a_all:
    input:
        expand(OUTPUT_A, data=DATA_LIST),
        expand(OUTPUT_B, data=DATA_LIST),

# In Snakefile:
rule all:
    input:
        rules.stage_a_all.input,
        rules.stage_b_all.input,
```

---

## 6. Rule Reuse (`use rule ... as ... with:`)

Reuse a rule's script with different inputs/outputs/params. The `script:` is always inherited.

```python
# Original rule
rule calc_stat:
    input:
        net_file = EMPIRICAL_NET,
        table_file = EMPIRICAL_TABLE,
    output:
        output_file = EMPIRICAL_STAT
    params:
        label = "Empirical",
    script:
        "../stats/calc-stat.py"

# Reuse for simulated data
use rule calc_stat as calc_stat_simulated with:
    input:
        net_file = SIMULATED_NET,
        table_file = SIMULATED_TABLE,
    params:
        label = "Simulated",
    output:
        output_file = SIMULATED_STAT

# Reuse for baseline model
use rule calc_stat as calc_stat_baseline with:
    input:
        net_file = BASELINE_NET,
        table_file = BASELINE_TABLE,
    params:
        label = lambda wildcards: wildcards.model,
    output:
        output_file = BASELINE_STAT
```

**What gets inherited:** `script:`, `threads:`, `resources:` carry over unless explicitly overridden. `input:`, `output:`, `params:` are replaced for the specified names.

**When to use:** Same computation on different data (empirical vs simulated), same statistic across multiple models, same analysis with different parameters.

---

## 7. Script Convention

All workflow scripts must work both inside Snakemake and interactively. Use this pattern:

```python
import sys

if "snakemake" in sys.modules:
    # === Snakemake mode ===
    input_file = snakemake.input["input_file"]
    output_file = snakemake.output["output_file"]

    # Params are STRINGS — convert types explicitly
    dim = int(snakemake.params["dim"])
    use_feature = snakemake.params["use_feature"] == "True"   # Boolean
    threshold = float(snakemake.params["threshold"])
    gpu_list = snakemake.params["gpus"]                       # Lists pass through as-is
else:
    # === Interactive/testing mode ===
    input_file = "../data/sample_input.npz"
    output_file = "../data/sample_output.csv"
    dim = 64
    use_feature = True
    threshold = 0.5

# === Main logic (identical in both modes) ===
import numpy as np
# ... rest of script ...
```

### Type Conversion Table

| Python Type | Arrives as in Snakemake | Convert with |
|-------------|------------------------|--------------|
| `bool` | `"True"` / `"False"` | `== "True"` |
| `int` | `"64"` | `int()` |
| `float` | `"0.001"` | `float()` |
| `list` | Python list | No conversion |
| `None` | `None` | `is None` |

### Script Location

Scripts are referenced relative to the `.smk` file that defines the rule:

```python
# In workflow/rules/analysis.smk:
script: "../stats/calc-stat.py"        # -> workflow/stats/calc-stat.py
script: "../plot/plot-figure.py"       # -> workflow/plot/plot-figure.py
script: "../fitting/fit-model.py"      # -> workflow/fitting/fit-model.py
```

---

## 8. Recipes

### Add a New Computation

1. Write the script in the appropriate `workflow/<category>/` directory, using the snakemake/interactive pattern from Section 7.
2. Define the output path as an UPPER_CASE constant in the `.smk` file. Use `to_paramspace().wildcard_pattern` if it depends on model parameters.
3. Write the rule with named inputs/outputs.
4. Add to the master aggregation rule with `expand()`.
5. Optionally reuse the rule for simulated data via `use rule ... as ... with:`.

### Add a New Parameter to a Model

1. Add the key-value pair to the parameter dict in `Snakefile` (value must be a list).
2. All file paths using that dict's `to_paramspace().wildcard_pattern` automatically include the new parameter.
3. Forward the wildcard in the rule's `params:` block: `new_param = lambda wildcards: wildcards.new_param`.
4. Read and convert it in the script: `new_param = int(snakemake.params["new_param"])`.

### Add a New Dataset

1. Create `workflow/preprocessing/{dataset}/Snakefile` with ingestion rules.
2. Include it from the main Snakefile.
3. Add the dataset name to `DATA_LIST`.
4. Ensure the preprocessed directory has the expected files.

### Add a New Plot

1. Write the script in `workflow/plot/`.
2. Define `FIG_SOMETHING = j(FIG_DIR, "{data}", "something.pdf")`.
3. Write a rule that takes computed data as input and the figure path as output.
4. Add to the figures master rule.

---

## 9. Checklist

- [ ] File path constants are UPPER_CASE
- [ ] Parameter dict values are always lists
- [ ] Use custom `expand()` from `utils.smk`, not Snakemake's built-in
- [ ] Use `to_paramspace()` + `.wildcard_pattern` for parameterized paths (never hand-build `key~value` strings)
- [ ] Rule inputs and outputs are named (not positional)
- [ ] Scripts use `if "snakemake" in sys.modules:` with an `else` block for interactive use
- [ ] Boolean/int/float params are converted from strings in scripts
- [ ] `j()` (alias for `os.path.join`) is used for all paths
- [ ] Each `.smk` file has a master aggregation rule (`rule stage_all:`)
- [ ] Rule reuse via `use rule X as Y with:` instead of duplicating scripts
- [ ] Double braces `{{wildcard}}` when embedding wildcards inside f-strings
