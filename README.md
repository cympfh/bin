# my ~/bin

```bash
export PATH=$PATH:/home/cympfh/bin
export PATH=$PATH:/home/cympfh/bin/stuff
export PATH=$PATH:/home/cympfh/git/twurl/bin
```


## atq

ロケールは +9:00 で決め打ち

```
   atq 2:20:00 '(echo `date`; sleep 1; date)'
(echo `date`; sleep 1; date)
2016年 1月 5日 火曜日 02:20:00 JST
2016年  1月  5日 火曜日 02:20:01 JST
```

## shuf

行をシャッフルする

```
   seq 100 | shuf
```

NB. `sort -R` はシャッフルではない.

## xr

xrandr をちょっとだけ楽に叩く.
mode (解像度) を peco 使って選択する.

