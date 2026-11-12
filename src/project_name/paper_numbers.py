r"""The numbers the paper cites: a CSV table, rendered as LaTeX commands.

The workflow's paper_numbers rule writes results/numbers.csv, one row per number
(name, value, format, source, description). This module renders it as
results/numbers.tex, one ``\newcommand`` per row, which the paper inputs:

    python -m project_name.paper_numbers results/numbers.csv results/numbers.tex
"""

import csv
import sys
from pathlib import Path

FIELDS = ["name", "value", "format", "source", "description"]


def format_value(value: str, spec: str) -> str:
    r"""Apply a Python format spec to the value and escape the result for LaTeX.

    ``",.0f"`` turns 2133 into ``2{,}133``; ``".0%"`` turns 0.559 into ``56\%``.
    An empty spec keeps the value as written.
    """
    text = format(float(value), spec) if spec else value
    return text.replace(",", "{,}").replace("%", r"\%")


def write_tex(numbers_csv: str | Path, tex_path: str | Path) -> None:
    """Write one LaTeX command per row of the numbers table.

    Names must be letters only (LaTeX's rule) and unique. The paper fails to
    build if its text uses a name the table does not define.
    """
    with open(numbers_csv, newline="") as fin:
        rows = list(csv.DictReader(fin))
    names = [row["name"] for row in rows]
    bad = [name for name in names if not (name.isascii() and name.isalpha())]
    if bad:
        raise ValueError(f"LaTeX command names must be letters only: {bad}")
    twice = sorted({name for name in names if names.count(name) > 1})
    if twice:
        raise ValueError(f"names defined more than once: {twice}")
    lines = [f"% Written from {Path(numbers_csv).name} by project_name.paper_numbers."]
    for row in rows:
        value = format_value(row["value"], row["format"])
        lines.append(
            f"\\newcommand{{\\{row['name']}}}{{{value}}}"
            f"  % {row['description']} ({row['source']})"
        )
    Path(tex_path).parent.mkdir(parents=True, exist_ok=True)
    Path(tex_path).write_text("\n".join(lines) + "\n")


if __name__ == "__main__":
    write_tex(sys.argv[1], sys.argv[2])
