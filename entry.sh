#!/bin/bash
set -euo pipefail

source /etc/bash_aliases

# If no arguments given, default to `shell`
if [[ $# -eq 0 ]]; then
  set -- shell
fi

# Execute the passed arguments as a command
# exec bash -c '"$@"' -- "$@"
"$@"
