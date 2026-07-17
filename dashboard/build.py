from __future__ import annotations

import html
import tomllib
from pathlib import Path
from typing import TypedDict


class Workstream(TypedDict):
    name: str
    status: str
    owner: str
    next_action: str


class DashboardStatus(TypedDict):
    project: str
    updated: str
    summary: str
    workstreams: list[Workstream]


DASHBOARD_DIR = Path(__file__).parent
STATUS_PATH = DASHBOARD_DIR / "status.toml"
OUTPUT_PATH = DASHBOARD_DIR / "index.html"


def escaped(value: str) -> str:
    return html.escape(value, quote=True)


def status_class(value: str) -> str:
    return "".join(character if character.isalnum() else "-" for character in value)


def render_row(workstream: Workstream) -> str:
    status = escaped(workstream["status"])
    css_class = status_class(workstream["status"].lower())
    return f"""
          <tr>
            <th scope="row">{escaped(workstream["name"])}</th>
            <td><span class="status status--{css_class}">{status}</span></td>
            <td>{escaped(workstream["owner"])}</td>
            <td>{escaped(workstream["next_action"])}</td>
          </tr>"""


def render_dashboard(data: DashboardStatus) -> str:
    rows = "".join(render_row(workstream) for workstream in data["workstreams"])
    return f"""<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{escaped(data["project"])} status</title>
  <style>
    :root {{
      color-scheme: light;
      font-family: Inter, ui-sans-serif, system-ui, sans-serif;
      color: #202622;
      background: #f4f5f1;
    }}
    * {{ box-sizing: border-box; }}
    body {{ margin: 0; }}
    main {{ width: min(960px, calc(100% - 2rem)); margin: 5rem auto; }}
    header {{ margin-bottom: 2rem; }}
    h1 {{ margin: 0 0 .5rem; font-size: clamp(2rem, 5vw, 3.5rem); }}
    .summary {{ max-width: 62ch; margin: 0; color: #505a53; font-size: 1.1rem; }}
    .updated {{ margin-top: 1rem; color: #737d75; font-size: .875rem; }}
    .table-wrap {{ overflow-x: auto; border: 1px solid #dfe3dc; border-radius: 12px; }}
    table {{ width: 100%; border-collapse: collapse; background: #fff; }}
    th, td {{ padding: 1rem; text-align: left; border-bottom: 1px solid #e8ebe6; }}
    thead th {{ color: #687169; font-size: .75rem; text-transform: uppercase; }}
    tbody th {{ min-width: 9rem; }}
    tbody tr:last-child > * {{ border-bottom: 0; }}
    .status {{ display: inline-block; padding: .3rem .55rem; border-radius: 999px;
      color: #475049; background: #ecefeb; font-size: .8rem; font-weight: 650;
      white-space: nowrap; }}
    .status--in-progress {{ color: #725100; background: #fff0bd; }}
    .status--blocked {{ color: #8a3029; background: #fde1de; }}
    .status--complete, .status--ready {{ color: #23633e; background: #dcefe3; }}
    @media (max-width: 600px) {{
      main {{ margin-block: 2rem; }}
      th, td {{ padding: .8rem; }}
    }}
  </style>
</head>
<body>
  <main>
    <header>
      <h1>{escaped(data["project"])}</h1>
      <p class="summary">{escaped(data["summary"])}</p>
      <p class="updated">Last updated: {escaped(data["updated"])}</p>
    </header>
    <div class="table-wrap">
      <table>
        <thead>
          <tr>
            <th scope="col">Workstream</th>
            <th scope="col">Status</th>
            <th scope="col">Owner</th>
            <th scope="col">Next action</th>
          </tr>
        </thead>
        <tbody>{rows}
        </tbody>
      </table>
    </div>
  </main>
</body>
</html>
"""


def main() -> None:
    with STATUS_PATH.open("rb") as status_file:
        data: DashboardStatus = tomllib.load(status_file)  # type: ignore[assignment]
    OUTPUT_PATH.write_text(render_dashboard(data), encoding="utf-8")
    print(f"Wrote {OUTPUT_PATH}")


if __name__ == "__main__":
    main()
