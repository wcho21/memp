#!/usr/bin/env sh

function help {
  echo "Usage: <process-name> <log-file-name>"
  exit 1
}

if [[ -z $1 ]]; then
  help
fi
PROC=$1

if [[ -z $2 ]]; then
  help
fi
FILE=$2

LIST_PROC="ps -o rss,comm"
DROP_FIRST_LINE="awk '{if (NR!=1) {print}}'"
FILTER_PROC="grep $PROC"
SUMMARIZE="awk 'BEGIN {sum = 0; procs} {sum += \$1; if (procs == \"\") procs = \$2; else procs = procs \", \" \$2} END {print sum \" KiB (\" procs \")\"}'"
LOG="tee -a $FILE"

watch -n 1 "$LIST_PROC | $DROP_FIRST_LINE | $FILTER_PROC | $SUMMARIZE | $LOG"