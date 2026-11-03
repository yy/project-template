"""Collect every number the paper cites into one table.

Usage (called by Snakemake):
    python scripts/paper_numbers.py <example.processed.csv> <numbers.csv>

Each row is a number computed from a workflow output, with the format it takes
in the text; the numbers_tex rule turns the table into LaTeX commands, so the
paper writes \\nExampleRows{} instead of a typed "2". When you add a number,
add the output it reads as an input of the rule.
"""

import csv
import sys

from project_name.paper_numbers import FIELDS


def main(processed_path: str, numbers_path: str) -> None:
    source = "data/derived/example.processed.csv"
    with open(processed_path, newline="") as fin:
        rows = list(csv.DictReader(fin))
    numbers = [  # name, value, format (Python spec; empty = as is), source, description
        ("nExampleRows", len(rows), ",.0f", source, "rows in the example data"),
        (
            "exampleValueTotal",
            sum(int(row["value"]) for row in rows),
            ",.0f",
            source,
            "sum of the value column",
        ),
    ]
    with open(numbers_path, "w", newline="") as fout:
        writer = csv.writer(fout)
        writer.writerow(FIELDS)
        writer.writerows(numbers)


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
