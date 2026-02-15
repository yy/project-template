#!/usr/bin/env bash
set -euo pipefail

error=0

# Check uv
if command -v uv &> /dev/null; then
    echo "[OK] uv: $(uv --version)"
else
    echo "[MISSING] uv - Install: https://docs.astral.sh/uv/getting-started/installation/"
    error=1
fi

# Check direnv
if command -v direnv &> /dev/null; then
    echo "[OK] direnv: $(direnv --version)"
else
    echo "[MISSING] direnv - Install: https://direnv.net/docs/installation.html"
    error=1
fi

# Check direnv uv integration
direnvrc="${XDG_CONFIG_HOME:-$HOME/.config}/direnv/direnvrc"
if [[ -f "$direnvrc" ]] && grep -q "use_uv" "$direnvrc"; then
    echo "[OK] direnv uv integration"
else
    echo "[MISSING] direnv uv integration"
    echo "    Add to $direnvrc:"
    echo
    echo '    use_uv() {'
    echo '        [ -d .venv ] || uv venv'
    echo '        source .venv/bin/activate'
    echo '        [ -f uv.lock ] && uv sync'
    echo '    }'
    echo
    error=1
fi

if [[ $error -eq 1 ]]; then
    echo "Install/configure missing dependencies and run this script again."
    exit 1
fi

echo
echo "All prerequisites found. Setting up project..."

# Install Python packages
uv sync
echo "[OK] Python packages installed"

# Copy workflow config template if it doesn't exist yet
if [[ ! -f workflow/config.yaml ]]; then
    cp workflow/config.template.yaml workflow/config.yaml
    echo "[OK] Created workflow/config.yaml from template (edit as needed)"
else
    echo "[OK] workflow/config.yaml already exists"
fi

# Install pre-commit hooks
uv run pre-commit install
echo "[OK] Pre-commit hooks installed"

echo
echo "Setup complete. Run 'direnv allow' to enable automatic venv activation."
