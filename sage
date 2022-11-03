#!/bin/bash

OPTS=
if [ -d ~/.sage ]; then
    OPTS="-v $HOME/.sage:/home/sage/.sage"
fi

if [ $# -eq 0 ]; then
    docker run -it --rm $OPTS sagemath/sagemath
else
    case "$1" in
        *.sage )
            docker run -it --rm $OPTS -v "$PWD:/home/sage/work" sagemath/sagemath "sage /home/sage/work/$1"
            ;;
    esac
fi
