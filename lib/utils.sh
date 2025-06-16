# Utility functions

get_options() {
  local -n _result=$1
  shift
  _result=()
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --*=*|-?=*) _result+=("$1") ;;
      --*|-?)    _result+=("$1") ;;
    esac
    shift
  done
}

get_positionals() {
  local -n _out=$1
  shift

  local arg
  local seen_double_dash=0
  _out=()

  for arg in "$@"; do
    if [[ "$arg" == -- ]]; then
      seen_double_dash=1
      continue
    fi
    if [[ $seen_double_dash == 1 || "$arg" != -* ]]; then
      _out+=("$arg")
    fi
  done
}

get_positionals_as() {
  local -a args=()
  local -a names=()
  local -a values=()
  local found_separator=0

  while [[ $# -gt 0 ]]; do
    if [[ "$1" == "--" ]]; then
      found_separator=1
      shift
      break
    fi
    args+=("$1")
    shift
  done

  if [[ $found_separator -eq 0 ]]; then
    echo "❌ error: expected '--' to separate args and variable names." >&2
    return 1
  fi

  # Remaining arguments are the variable names
  while [[ $# -gt 0 ]]; do
    names+=("$1")
    shift
  done

  # Filter only positional arguments (not starting with '-') from args
  local seen_double_dash=0
  for arg in "${args[@]}"; do
    if [[ "$arg" == "--" ]]; then
      seen_double_dash=1
      continue
    fi
    if [[ "$arg" != -* || $seen_double_dash -eq 1 ]]; then
      values+=("$arg")
    fi
  done

  # Assign positionals to the provided variable names (globally)
  for i in "${!names[@]}"; do
    local var="${names[$i]}"
    if [[ $i -lt ${#values[@]} ]]; then
      val="${values[$i]}"
    else
      val=""
    fi
    printf -v "$var" %s "$val"
  done
}

extract_schema() {
  # Extract the schema from a db object. Give the empty string if it's not
  # schema-qualified.
  #
  # Examples:
  #   "api.login" -> "api"
  #   "login" -> ""
  local input="${1:-}"
  if [[ "$input" == *.* ]]; then
    echo "${input%%.*}"
  else
    echo ""
  fi
}

strip_schema() {
  # Strip the schema from a db object.
  #
  # Examples:
  #   "api.login" -> "login"
  #   "login" -> "login"
  echo "${1:-}" | cut -d . -f2
}

show_files() {
  # batcat adds ^M chars to the output unless --paging=never is used
  batcat --style=plain --paging=never deploy/${1}.sql
}
