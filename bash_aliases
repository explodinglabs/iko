# Only fail fast in scripts, not interactive shell
if [[ $- != *i* ]]; then
  set -euo pipefail
fi

# Alias sqitch commands (all except "init" which is in bin)

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
