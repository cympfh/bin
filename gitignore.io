#!/bin/bash

help() {
    cat <<EOM
NAME
  gitignore.io

SYNOPSIS
  gitignore.io <subcommand> <options>

SUBCOMMANDS

  help
    displays this

  list
    list up all available templates

  show <template-name>
    show the gitignore template

EOM
    exit
}

show-template-list() {
    curl -s https://www.toptal.com/developers/gitignore/dropdown/templates.json |
        jq -r '.[].id'
}

show-template() {
    curl -s "https://www.toptal.com/developers/gitignore/api/$1"
}

if [ $# -eq 0 ]; then
    help
fi

case "$1" in
    list )
        show-template-list
        ;;
    show )
        show-template "$2"
        ;;
    * )
      help
        ;;
esac
