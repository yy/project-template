"""Example script: summarize a processed CSV dataset.

Usage (called by Snakemake):
    python scripts/summarize.py <input.csv> <output.txt>

Replace this with your own analysis/summarization logic.
"""

import csv
import sys


def main(input_path: str, output_path: str) -> None:
    with open(input_path, newline="") as fin:
        reader = csv.DictReader(fin)
        rows = list(reader)

    with open(output_path, "w") as fout:
        fout.write(f"Total rows: {len(rows)}\n")
        if rows:
            fout.write(f"Columns: {', '.join(rows[0].keys())}\n")


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
