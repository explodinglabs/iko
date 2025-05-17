#!/bin/bash
set -e

source /etc/bash_aliases

# Execute the passed arguments as a command
exec bash -c '"$@"' -- "$@"
