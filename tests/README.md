Tests for `src/project_name`.

## Running tests

```
uv run pytest
```

With coverage:
```
uv run pytest --cov=project_name
```

## Structure

Mirror the `src/` structure:
```
tests/
├── __init__.py
├── test_data.py      # Tests for src/project_name/data.py
├── test_models.py    # Tests for src/project_name/models.py
└── ...
```

## Writing tests

```python
from project_name import data

def test_load_data():
    result = data.load("sample.csv")
    assert result is not None
```
