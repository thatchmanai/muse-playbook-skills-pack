#!/usr/bin/env bash
# outward-scan.sh — mechanical preflight for ANY text a third party will read
# (email, message, post, article, deliverable — no short-text exception).
#
# FAIL terms block presenting the text as ready (exit 1).
# WARN terms are counted for a human look.
#
# Usage:
#   outward-scan.sh <file> [file...]
#   outward-scan.sh -                     (read stdin)
#   outward-scan.sh --config my-terms.conf <file>
#
# Terms file format (see scan-terms.example.conf):
#   [fail]            starts the FAIL section
#   [warn]            starts the WARN section
#   <grep -E regex>   one term per line; blank lines and #-comments ignored
# Default config: ./scan-terms.conf if present, else the example config
# shipped beside this script (so a fresh clone runs, with placeholder terms).
set -u

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config=""
files=()
while [ $# -gt 0 ]; do
  case "$1" in
    --config) config="$2"; shift 2 ;;
    *) files+=("$1"); shift ;;
  esac
done
if [ -z "$config" ]; then
  if [ -f "./scan-terms.conf" ]; then config="./scan-terms.conf";
  elif [ -f "$script_dir/../scan-terms.conf" ]; then config="$script_dir/../scan-terms.conf";
  else config="$script_dir/../scan-terms.example.conf"; fi
fi
if [ ! -f "$config" ]; then echo "ERROR: terms config not found: $config" >&2; exit 2; fi
if [ ${#files[@]} -eq 0 ]; then echo "Usage: outward-scan.sh [--config CONF] <file...|->" >&2; exit 2; fi

fail_terms=(); warn_terms=(); section=""
while IFS= read -r line || [ -n "$line" ]; do
  trimmed="$(printf '%s' "$line" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"
  case "$trimmed" in
    ""|\#*) continue ;;
    "[fail]") section="fail"; continue ;;
    "[warn]") section="warn"; continue ;;
  esac
  if [ "$section" = "fail" ]; then fail_terms+=("$trimmed");
  elif [ "$section" = "warn" ]; then warn_terms+=("$trimmed"); fi
done < "$config"

echo "Terms config: $config (${#fail_terms[@]} FAIL, ${#warn_terms[@]} WARN)"
status=0
for f in "${files[@]}"; do
  tmp_stdin=""
  if [ "$f" = "-" ]; then
    # Slurp stdin once: re-reading /dev/stdin per term hits EOF after the
    # first term and silently reports 0 for every later term.
    tmp_stdin="$(mktemp)"
    cat > "$tmp_stdin"
    src="$tmp_stdin"; label="(stdin)"
  else
    src="$f"; label="$f"
    if [ ! -f "$src" ]; then echo "ERROR: input file not found: $src" >&2; exit 2; fi
  fi
  echo "== $label"
  for t in "${fail_terms[@]}"; do
    n=$(grep -cE "$t" "$src" 2>/dev/null); grc=$?
    if [ $grc -gt 1 ]; then echo "ERROR: grep failed (exit $grc) for term /$t/ on $label - scan aborted, no result" >&2; [ -n "$tmp_stdin" ] && rm -f "$tmp_stdin"; exit 2; fi
    echo "  FAIL-term  /$t/ : $n line(s)"
    [ "${n:-0}" -gt 0 ] && status=1
  done
  for t in "${warn_terms[@]}"; do
    n=$(grep -cE "$t" "$src" 2>/dev/null); grc=$?
    if [ $grc -gt 1 ]; then echo "ERROR: grep failed (exit $grc) for term /$t/ on $label - scan aborted, no result" >&2; [ -n "$tmp_stdin" ] && rm -f "$tmp_stdin"; exit 2; fi
    echo "  WARN-term  /$t/ : $n line(s)"
  done
  [ -n "$tmp_stdin" ] && rm -f "$tmp_stdin"
done
if [ "$status" -eq 0 ]; then echo "RESULT: PASS (no FAIL terms)"; else echo "RESULT: BLOCKED (FAIL terms present)"; fi
exit $status
