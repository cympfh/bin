#!/bin/bash

if ls /tmp/mouse_off ; then
    xinput --set-prop "SynPS/2 Synaptics TouchPad" "Synaptics Off" 0
      rm /tmp/mouse_off
      else
          xinput --set-prop "SynPS/2 Synaptics TouchPad" "Synaptics Off" 1
            touch /tmp/mouse_off
            fi

# "SynPS/2 Synaptics TouchPad" の名前は
# $ xinput -list
# から
