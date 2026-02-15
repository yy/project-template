"""Example script: process a raw CSV dataset.

Usage (called by Snakemake):
    python scripts/process_data.py <input.csv> <output.csv>

Replace this with your own data-processing logic.
"""

import csv
import sys


def main(input_path: str, output_path: str) -> None:
    with open(input_path, newline="") as fin, open(output_path, "w", newline="") as fout:
        reader = csv.DictReader(fin)
        assert reader.fieldnames is not None
        writer = csv.DictWriter(fout, fieldnames=reader.fieldnames)
        writer.writeheader()
        for row in reader:
            # Example: pass rows through unchanged. Add your processing here.
            writer.writerow(row)


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
