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
    log-info "Executing: $CMD"
    cat "$QFILE" | awk c++ > /tmp/tmpq
    mv /tmp/tmpq $QFILE
    $CMD
    log-info "Finished: $CMD with $?"
  else
    log-info "Error: pop-and-exec failed. $QFILE is empty."
    exit 1
  fi
}

list-and-exec() {
  if [ -s "$QFILE" ]; then
    NUM=$(cat -n "$QFILE" | fzf --reverse | awk '{ print $1 }')
    if [ "$NUM" ]; then
      CMD=$(cat "$QFILE" | awk "NR == $NUM")
      log-info "Executing: [$NUM] $CMD"
      cat "$QFILE" | awk "NR != $NUM" > /tmp/tmpq
      mv /tmp/tmpq $QFILE
      $CMD
      log-info "Finished: [$NUM] $CMD with $?"
    else
      log-info "No command executed."
    fi
  else
    log-info "Error: list-and-exec failed. $QFILE is empty."
    exit 1
  fi
}

log-info() {
  (
    date "+[%Y-%m-%d %H:%M:%S] " | tr -d '\r\n'
    echo -n "[INFO] "
    echo "$@"
  ) | tee -a .q.log >&2
}

case "$TASK" in
  PUSH )
    echo "$@" >> $QFILE
    log-info "Pushed $@ into $QFILE"
    ;;
  POP )
    pop-and-exec
    ;;
  LIST )
    list-and-exec
    ;;
esac
