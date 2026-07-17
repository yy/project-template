import subprocess
import sys
from pathlib import Path


def test_dashboard_builds_from_status_file(tmp_path: Path) -> None:
    output_path = tmp_path / "index.html"
    subprocess.run(
        [sys.executable, "dashboard/build.py", "--output", str(output_path)],
        check=True,
    )

    dashboard = output_path.read_text(encoding="utf-8")

    assert '<th scope="col">Owner</th>' in dashboard
    assert '<th scope="col">Next action</th>' in dashboard
    assert "Unassigned" in dashboard
