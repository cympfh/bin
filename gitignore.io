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

  search <keyword>
    search templates with a keyword (grep)

  show <templates...>
    show your .gitignore

EOM
    exit
}

show-template-list() {
    curl -s https://www.gitignore.io/dropdown/templates.json |
        jq -r '.[].id'
}

show-template() {
    ids=$(echo "$@" | sed 's/^ *//g; s/ *$//g; s/  */ /g; s/ /,/g')
    curl -s "https://www.gitignore.io/api/${ids}"
}

if [ $# -eq 0 ]; then
    help
fi

case "$1" in
    help )
        help
        ;;
    search )
        if [ -z "$2" ]; then
            echo "No keyword specified"
            exit 1
        fi
        show-template-list | grep -i --color "$2"
        ;;
    show )
        shift
        show-template $@
        ;;
esac
