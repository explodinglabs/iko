#!/bin/bash
# Custom iko commands live in 'bin'.
# This file only aliases raw sqitch commands not overridden

# Only fail fast in scripts, not interactive shell
if [[ $- != *i* ]]; then
  set -euo pipefail
fi

# Set prompt if running interactively
if [[ $- == *i* ]]; then
  export PS1="✨\e[96mikō>\[\e[0m\] "
fi

# Alias sqitch commands
# Note "init" is in bin/init.

sqitch_commands=(
  config
  engine
  target
  help
  add
  bundle
  checkout
  check
  plan
  rebase
  rework
  show
  tag
  deploy
  log
  revert
  status
  upgrade
  verify
)

for cmd in "${sqitch_commands[@]}"; do
  eval "
  function $cmd {
    sqitch $cmd \"\$@\"
  }"
done
