#!/usr/bin/env bash
# Emits the Authorization header for the bundled MinTo MCP server, reusing
# the JWT that `minto-cli login` already stores on disk.
set -euo pipefail

token_file="${HOME}/.minto/token"

if [[ ! -f "$token_file" ]]; then
  echo "MinTo token not found at ${token_file}. Run 'minto-cli login' first." >&2
  exit 1
fi

token="$(cat "$token_file")"
printf '{"Authorization": "Bearer %s"}\n' "$token"
