# Utility functions


# usage: get_options options "$@" -- var1 var2 var3 ...
get_options() {
  local -n _opts=$1; shift
  local -a raw_args=()
  local -a names=()
  local -a values=()

  # Split on '--'
  while [[ $# -gt 0 ]]; do
    if [[ "$1" == "--" ]]; then
      shift
      break
    fi
    raw_args+=("$1")
    shift
  done

  # Remaining args are variable names
  names=("$@")

  # Parse options from raw_args
  _opts=()
  while [[ ${#raw_args[@]} -gt 0 ]]; do
    case "${raw_args[0]}" in
      --*=*)
        _opts+=("${raw_args[0]}")
        raw_args=("${raw_args[@]:1}")
        ;;
      --*|-?)
        if [[ ${#raw_args[@]} -gt 1 && "${raw_args[1]}" != "-"* ]]; then
          _opts+=("${raw_args[0]}" "${raw_args[1]}")
          raw_args=("${raw_args[@]:2}")
        else
          _opts+=("${raw_args[0]}")
          raw_args=("${raw_args[@]:1}")
        fi
        ;;
      *)
        break
        ;;
    esac
  done

  # Remaining elements in raw_args are the positionals
  values=("${raw_args[@]}")

  # Assign values to named variables
  for i in "${!names[@]}"; do
    local var="${names[$i]}"
    local val="${values[$i]:-}"
    printf -v "$var" %s "$val"
  done
}

# usage: get_opt "${options[@]}" --change -c
get_opt() {
  local -a opts=("${@:1:$(($#-2))}")
  local primary="${@: -2:1}"
  local fallback="${@: -1}"

  for ((i = 0; i < ${#opts[@]}; i++)); do
    if [[ "${opts[i]}" == "$primary" || "${opts[i]}" == "$fallback" ]]; then
      if (( i + 1 < ${#opts[@]} )); then
        echo "${opts[i+1]}"
        return 0
      fi
    fi
  done

  return 1
}


# Parse an optionally-qualified identifiers
#
# Example:
#   >>> parse_identifier "api.users" -- schema table

parse_identifier() {
  local input="$1"
  shift
  [[ "$1" == "--" ]] && shift
  local -n out_schema="$1"
  local -n out_object="$2"

  if [[ "$input" == *.* ]]; then
    out_schema="${input%%.*}"
    out_object="${input##*.}"
  else
    out_schema=""
    out_object="$input"
  fi
}

# Parse an optionally-qualified a 2- or 3- part identifier (such as a column)
#
# Example:
#   >>> parse_identifier "api.users.name" -- schema table column


parse_column_identifier() {
  local input="$1"
  shift
  [[ "$1" == "--" ]] && shift
  local -n out_schema="$1"
  local -n out_table="$2"
  local -n out_column="$3"

  local count
  count=$(awk -F. '{print NF}' <<< "$input")

  if (( count == 3 )); then
    out_schema="${input%%.*}"
    out_table="$(cut -d. -f2 <<< "$input")"
    out_column="${input##*.}"
  elif (( count == 2 )); then
    out_schema=""
    out_table="${input%%.*}"
    out_column="${input##*.}"
  else
    out_schema=""
    out_table=""
    out_column=""
  fi
}

show_files() {
  # batcat adds ^M chars to the output unless --paging=never is used
  batcat --style=plain --paging=never deploy/${1}.sql
}
