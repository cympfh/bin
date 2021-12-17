#!/bin/bash

OPTS=
if [ -d ~/.sage ]; then
    OPTS="-v $HOME/.sage:/home/sage/.sage"
fi

docker run -it --rm $OPTS sagemath/sagemath
