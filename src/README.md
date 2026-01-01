Project source code. Installed as an editable package via `pyproject.toml`.

Rename `project_name/` to match your project and update the package name in `pyproject.toml`.

## Structure

```
src/
└── project_name/
    ├── __init__.py
    ├── data.py        # Data loading and processing
    ├── models.py      # Model definitions
    ├── utils.py       # Shared utilities
    └── ...
```

## Usage

In notebooks:
```python
from project_name import data, models
```

In workflow scripts:
```python
from project_name.utils import some_function
```

Move reusable code from notebooks here. Keep notebooks for exploration, keep `src/` for tested, reusable code.
