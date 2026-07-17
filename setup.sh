#!/usr/bin/env bash
set -euo pipefail

# Check uv
if command -v uv &> /dev/null; then
    echo "[OK] uv: $(uv --version)"
else
    echo "[MISSING] uv - Install: https://docs.astral.sh/uv/getting-started/installation/"
    exit 1
fi

echo
echo "All prerequisites found. Setting up project..."

# Install Python packages
uv sync
echo "[OK] Python packages installed"

# Install pre-commit hooks unless Git uses a shared hook directory
if git config --get core.hooksPath > /dev/null; then
    echo "[SKIP] Git uses a configured hooks directory; not installing local hooks"
else
    uv run pre-commit install
    echo "[OK] Pre-commit hooks installed"
fi

echo
echo "Setup complete. Run 'make check' to verify the project."
if command -v direnv &> /dev/null; then
    echo "Optional: run 'direnv allow' to add .venv/bin to your shell PATH."
fi
