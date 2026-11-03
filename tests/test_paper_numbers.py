"""Tests for rendering the numbers table as LaTeX commands."""

import csv

import pytest

from project_name.paper_numbers import FIELDS, format_value, write_tex


def write_table(path, rows) -> None:
    with open(path, "w", newline="") as fout:
        writer = csv.writer(fout)
        writer.writerow(FIELDS)
        writer.writerows(rows)


@pytest.mark.parametrize(
    ("value", "spec", "expected"),
    [("2133", ",.0f", "2{,}133"), ("0.559", ".0%", r"56\%"), ("0.288", "", "0.288")],
)
def test_format_value(value, spec, expected) -> None:
    assert format_value(value, spec) == expected


def test_writes_one_command_per_row(tmp_path) -> None:
    table, tex = tmp_path / "numbers.csv", tmp_path / "numbers.tex"
    write_table(table, [["nRows", "2133", ",.0f", "data.csv", "rows in the data"]])
    write_tex(table, tex)
    assert tex.read_text() == (
        "% Written from numbers.csv by project_name.paper_numbers.\n"
        "\\newcommand{\\nRows}{2{,}133}  % rows in the data (data.csv)\n"
    )


@pytest.mark.parametrize(
    ("names", "message"),
    [(["nRows2"], "letters only"), (["nRows", "nRows"], "more than once")],
)
def test_rejects_names_latex_cannot_use(tmp_path, names, message) -> None:
    table = tmp_path / "numbers.csv"
    write_table(table, [[name, "1", "", "data.csv", ""] for name in names])
    with pytest.raises(ValueError, match=message):
        write_tex(table, tmp_path / "numbers.tex")
