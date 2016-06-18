#!/bin/bash

F="$1"
echo "$F"
case "$F" in
  *.zip )
    mv "$F" "${F}.cbz"
    evince "$F.cbz"
    mv "$F.cbz" "${F}"
    ;;
  * )
    feh "$F"
    ;;
esac
