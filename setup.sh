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
echo "All dependencies installed. Run:"
echo "  uv sync        # Install Python packages"
echo "  direnv allow   # Enable automatic venv activation"
