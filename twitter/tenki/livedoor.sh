#!/bin/sh

d=2

w3m -dump http://weather.livedoor.com/area/forecast/1310500 |
grep '降水確率' | grep -o '[0-9]*' |
while read pp; do
  LANG=en date -d "-$d days ago" "+%Y/%m/%d 00:00 $pp"
  d=$(($d + 1))
done
