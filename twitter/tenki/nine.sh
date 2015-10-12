#!/bin/sh

curl -s http://sx9.jp/weather/tokyo-hongo.js |
grep ' \(0\|1\), ' |
sed 's/ *data.setValue([0-9]*,//g' | sed 's/);//g' | sed 's/[ \t]//g' |
sed 's#0,.\([0-9]*\)月\([0-9]*\)日\([0-9]*\)時\([0-9]*\)分.*#2015/\1/\2 \3:\4 #' |
sed 's#1,\([0-9]*\)#\1@#' |
tr -d '\n' | sed 's/@/\n/g'
