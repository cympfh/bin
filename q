#!/bin/bash

QFILE=.q

usage() {
  cat <<EOM
q - command queue

SYNOPSIS
  Push a command to queue:
    $ q -- echo 1

  Pop and Execute from queue
    $ q

  List and Execute
    $ q -l
EOM
}

TASK=

if [ $# -eq 0 ]; then
  TASK=POP
else
  case "$1" in
    --help | -h )
      usage
      exit
      ;;
    -- )
      shift
      TASK=PUSH
      ;;
    -l )
      TASK=LIST
      ;;
    * )
      TASK=PUSH
      ;;
  esac
fi

pop-and-exec() {
  if [ -s "$QFILE" ]; then
    CMD=$(head -1 "$QFILE")
    echo "Executing: $CMD" >&2
    cat "$QFILE" | awk c++ > /tmp/tmpq
    mv /tmp/tmpq $QFILE
    $CMD
  else
    echo "Error: $QFILE is empty." >&2
    exit 1
  fi
}

list-and-exec() {
  if [ -s "$QFILE" ]; then
    NUM=$(cat -n "$QFILE" | fzf --reverse | awk '{ print $1 }')
    if [ "$NUM" ]; then
      CMD=$(cat "$QFILE" | awk "NR == $NUM")
      echo "Executing: [$NUM] $CMD" >&2
      cat "$QFILE" | awk "NR != $NUM" > /tmp/tmpq
      mv /tmp/tmpq $QFILE
      $CMD
    else
      echo "No command executed." >&2
    fi
  else
    echo "Error: $QFILE is empty." >&2
    exit 1
  fi
}

case "$TASK" in
  PUSH )
    echo "$@" >> $QFILE
    ;;
  POP )
    pop-and-exec
    ;;
  LIST )
    list-and-exec
    ;;
esac
