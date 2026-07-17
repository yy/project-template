import subprocess
import sys
from pathlib import Path


def test_dashboard_builds_from_status_file() -> None:
    subprocess.run([sys.executable, "dashboard/build.py"], check=True)

    dashboard = Path("dashboard/index.html").read_text(encoding="utf-8")

    assert '<th scope="col">Owner</th>' in dashboard
    assert '<th scope="col">Next action</th>' in dashboard
    assert "Unassigned" in dashboard
