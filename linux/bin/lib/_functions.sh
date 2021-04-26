#!/usr/bin/env bash
#
# Utilities functions

# Example Usage: concat "," "$arr[@]"
# result: 1,2,3,4
function concat() {
  local IFS="$1"
  shift
  echo "$*"
}

function styled() (
  die() {
    local _ret="${2:-1}"
    test "${_PRINT_HELP:-no}" = yes && print_help >&2
    echo -e "$1" >&2
    exit "${_ret}"
  }

  begins_with_short_option() {
    local first_option all_short_options='bduikgch'
    first_option="${1:0:1}"
    test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
  }

  _positionals=()
  _arg_bold="off"
  _arg_dim="off"
  _arg_underline="off"
  _arg_italic="off"
  _arg_blink="off"
  _arg_background=
  _arg_color=

  print_help() {
    printf 'Style the text outputted to terminal.\n'
    printf '\e[43m  CAUTION  \e[0m \e[33mIt depends on the ability of terminal to display them!\e[0m\n'
    printf '\n'
    printf 'USAGE:\n'
    printf '\t%s [OPTIONS] <ARGUMENT>\n' "$(basename "$0")"
    printf '\n'
    printf 'ARGUMENT:\n'
    printf '\t%s\n' "<text>                           : The text that want styling"
    printf '\n'
    printf 'OPTIONS:\n'
    printf '\t%s\n' "-b, --bold, --no-bold            : Make it bolder (font) / brighter (color)"
    printf '\t%s\n' "-d, --dim, --no-dim              : Make it dimmer"
    printf '\t%s\n' "-u, --underline, --no-underline  : Make it underlined"
    printf '\t%s\n' "-i, --italic, --no-italic        : Make it italic"
    printf '\t%s\n' "-k, --blink, --no-blink          : Make it blink"
    printf '\t%s\n' "-g, --background                 : Set the background"
    printf '\t%s\n' "-c, --color                      : Set the color"
    printf '\t%s\n' "-h, --help                       : Prints help"
  }

  parse_commandline() {
    _positionals_count=0
    while test $# -gt 0; do
      _key="$1"
      case "$_key" in
      -b | --no-bold | --bold)
        _arg_bold="on"
        test "${1:0:5}" = "--no-" && _arg_bold="off"
        ;;
      -b*)
        _arg_bold="on"
        _next="${_key##-b}"
        if test -n "$_next" -a "$_next" != "$_key"; then
          { begins_with_short_option "$_next" && shift && set -- "-b" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
        fi
        ;;
      -d | --no-dim | --dim)
        _arg_dim="on"
        test "${1:0:5}" = "--no-" && _arg_dim="off"
        ;;
      -d*)
        _arg_dim="on"
        _next="${_key##-d}"
        if test -n "$_next" -a "$_next" != "$_key"; then
          { begins_with_short_option "$_next" && shift && set -- "-d" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
        fi
        ;;
      -u | --no-underline | --underline)
        _arg_underline="on"
        test "${1:0:5}" = "--no-" && _arg_underline="off"
        ;;
      -u*)
        _arg_underline="on"
        _next="${_key##-u}"
        if test -n "$_next" -a "$_next" != "$_key"; then
          { begins_with_short_option "$_next" && shift && set -- "-u" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
        fi
        ;;
      -i | --no-italic | --italic)
        _arg_italic="on"
        test "${1:0:5}" = "--no-" && _arg_italic="off"
        ;;
      -i*)
        _arg_italic="on"
        _next="${_key##-i}"
        if test -n "$_next" -a "$_next" != "$_key"; then
          { begins_with_short_option "$_next" && shift && set -- "-i" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
        fi
        ;;
      -k | --no-blink | --blink)
        _arg_blink="on"
        test "${1:0:5}" = "--no-" && _arg_blink="off"
        ;;
      -k*)
        _arg_blink="on"
        _next="${_key##-k}"
        if test -n "$_next" -a "$_next" != "$_key"; then
          { begins_with_short_option "$_next" && shift && set -- "-k" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
        fi
        ;;
      -g | --background)
        test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
        _arg_background="$2"
        shift
        ;;
      --background=*)
        _arg_background="${_key##--background=}"
        ;;
      -g*)
        _arg_background="${_key##-g}"
        ;;
      -c | --color)
        test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
        _arg_color="$2"
        shift
        ;;
      --color=*)
        _arg_color="${_key##--color=}"
        ;;
      -c*)
        _arg_color="${_key##-c}"
        ;;
      -h | --help)
        print_help
        exit 0
        ;;
      -h*)
        print_help
        exit 0
        ;;
      *)
        _last_positional="$1"
        _positionals+=("$_last_positional")
        _positionals_count=$((_positionals_count + 1))
        ;;
      esac
      shift
    done
  }

  handle_passed_args_count() {
    local _required_args_string="'text'"
    test "${_positionals_count}" -ge 1 || _PRINT_HELP=yes die "FATAL ERROR: Not enough positional arguments - we require exactly 1 (namely: $_required_args_string), but got only ${_positionals_count}." 1
    test "${_positionals_count}" -le 1 || _PRINT_HELP=yes die "FATAL ERROR: There were spurious positional arguments --- we expect exactly 1 (namely: $_required_args_string), but got ${_positionals_count} (the last one was: '${_last_positional}')." 1
  }

  assign_positional_args() {
    local _positional_name _shift_for=$1
    _positional_names="_arg_text "

    shift "$_shift_for"
    for _positional_name in ${_positional_names}; do
      test $# -gt 0 || break
      eval "$_positional_name=\${1}" || die "Error during argument parsing, possibly an Argbash bug." 1
      shift
    done
  }

  parse_commandline "$@"
  handle_passed_args_count
  assign_positional_args 1 "${_positionals[@]}"

  [ $_arg_bold = "on" ] && _bold=1
  [ $_arg_dim = "on" ] && _dim=2
  [ $_arg_italic = "on" ] && _italic=3
  [ $_arg_underline = "on" ] && _underline=4
  [ $_arg_blink = "on" ] && _blink=5

  if [[ -n ${_arg_background} ]]; then
    if [[ "$_arg_background" =~ ^[Bb]lack$ ]]; then
      _background=40
    elif [[ "$_arg_background" =~ ^[Rr]ed$ ]]; then
      _background=41
    elif [[ "$_arg_background" =~ ^[Gg]reen$ ]]; then
      _background=42
    elif [[ "$_arg_background" =~ ^[Yy]ellow$ ]]; then
      _background=43
    elif [[ "$_arg_background" =~ ^[Bb]lue$ ]]; then
      _background=44
    elif [[ "$_arg_background" =~ ^([Mm]agenta|[Pp]urple)$ ]]; then
      _background=45
    elif [[ "$_arg_background" =~ ^[Cc]yan$ ]]; then
      _background=46
    elif [[ "$_arg_background" =~ ^[Ww]hite$ ]]; then
      _background=47
    elif [[ "$_arg_background" =~ ([Ll]|[Bb]r)ight(_|-| |)[Bb]lack ]]; then
      _background=100
    elif [[ "$_arg_background" =~ ([Ll]|[Bb]r)ight(_|-| |)[Rr]ed ]]; then
      _background=101
    elif [[ "$_arg_background" =~ ([Ll]|[Bb]r)ight(_|-| |)[Gg]reen ]]; then
      _background=102
    elif [[ "$_arg_background" =~ ([Ll]|[Bb]r)ight(_|-| |)[Yy]ellow ]]; then
      _background=103
    elif [[ "$_arg_background" =~ ([Ll]|[Bb]r)ight(_|-| |)[Bb]lue ]]; then
      _background=104
    elif [[ "$_arg_background" =~ ([Ll]|[Bb]r)ight(_|-| |)([Mm]agenta|[Pp]urple) ]]; then
      _background=105
    elif [[ "$_arg_background" =~ ([Ll]|[Bb]r)ight(_|-| |)[Cc]yan ]]; then
      _background=106
    elif [[ "$_arg_background" =~ ([Ll]|[Bb]r)ight(_|-| |)[Ww]hite ]]; then
      _background=107
    else
      die "Invalid color.\nAccepted value is the color name of 8/16-colors terminal." 1
    fi
  fi

  if [[ -n ${_arg_color} ]]; then
    if [[ "$_arg_color" =~ ^[Bb]lack$ ]]; then
      _color=30
    elif [[ "$_arg_color" =~ ^[Rr]ed$ ]]; then
      _color=31
    elif [[ "$_arg_color" =~ ^[Gg]reen$ ]]; then
      _color=32
    elif [[ "$_arg_color" =~ ^[Yy]ellow$ ]]; then
      _color=33
    elif [[ "$_arg_color" =~ ^[Bb]lue$ ]]; then
      _color=34
    elif [[ "$_arg_color" =~ ^([Mm]agenta|[Pp]urple)$ ]]; then
      _color=35
    elif [[ "$_arg_color" =~ ^[Cc]yan$ ]]; then
      _color=36
    elif [[ "$_arg_color" =~ ^[Ww]hite$ ]]; then
      _color=37
    elif [[ "$_arg_color" =~ ([Ll]|[Bb]r)ight(_|-| |)[Bb]lack ]]; then
      _color=90
    elif [[ "$_arg_color" =~ ([Ll]|[Bb]r)ight(_|-| |)[Rr]ed ]]; then
      _color=91
    elif [[ "$_arg_color" =~ ([Ll]|[Bb]r)ight(_|-| |)[Gg]reen ]]; then
      _color=92
    elif [[ "$_arg_color" =~ ([Ll]|[Bb]r)ight(_|-| |)[Yy]ellow ]]; then
      _color=93
    elif [[ "$_arg_color" =~ ([Ll]|[Bb]r)ight(_|-| |)[Bb]lue ]]; then
      _color=94
    elif [[ "$_arg_color" =~ ([Ll]|[Bb]r)ight(_|-| |)([Mm]agenta|[Pp]urple) ]]; then
      _color=95
    elif [[ "$_arg_color" =~ ([Ll]|[Bb]r)ight(_|-| |)[Cc]yan ]]; then
      _color=96
    elif [[ "$_arg_color" =~ ([Ll]|[Bb]r)ight(_|-| |)[Ww]hite ]]; then
      _color=97
    else
      die "Invalid color.\nAccepted value is the color name of 8/16-colors terminal." 1
    fi
  fi

  # shellcheck disable=SC2206
  _format=(${_bold:-} ${_dim:-} ${_italic:-} ${_underline:-} ${_blink:-} ${_background:-} ${_color:-})

  _style=$(concat ";" "${_format[@]}")

  echo -e "\e[${_style:-}m${_arg_text:?}\e[0m"
)

function info() {
  printf "\n\t\e%s $1 ℹ\n" "$(styled -bc lightblue "==>")"
}

function step() {
  printf "\n\t\e%s $1 👟\n" "$(styled -bc purple "==>")"
}

function success() {
  printf "\n\t\e%s $1 ✔\n" "$(styled -bc green "==>")"
}

function fail() {
  printf "\n\t\e%s $1 ❌\n" "$(styled -bc red "==>")"
  exit 1
}
