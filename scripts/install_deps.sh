#!/usr/bin/env bash
set -euo pipefail
PY=""
for C in /usr/local/bin/python3 /opt/homebrew/bin/python3 $(command -v python3 || echo) /usr/bin/python3; do
  if [ -x "$C" ]; then
    PY="$C"
    break
  fi
done
if [ -z "$PY" ]; then
  echo "No python3 found" >&2
  exit 1
fi
if [ "${USE_VENV:-0}" = "1" ]; then
  "$PY" -m venv .venv
  PY="$(pwd)/.venv/bin/python"
fi
"$PY" -m pip install --upgrade pip
PIP_ARGS=""
if [ -n "${PIP_INDEX_URL:-}" ]; then
  PIP_ARGS="-i ${PIP_INDEX_URL}"
fi
"$PY" -m pip install $PIP_ARGS python-docx
"$PY" - <<'PY'
import sys
print('python', sys.version.split()[0])
try:
    import docx
    print('docx', getattr(docx, '__version__', 'unknown'))
except Exception as e:
    print('docx import failed:', e)
PY
