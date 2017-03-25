# THIS PROJECT IS DEPRECATED
# HIGHLY RECOMMENDED TO USE OFFICIAL IMAGE
# https://github.com/Chinachu/docker-mirakurun-chinachu
# OR OUR NEW PROJECT
# https://github.com/amaya382/docker-mirakurun-chinachu-encoder INSTEAD

## About this

dockerコンテナ上でchinachuの実行環境を提供する


## Requirements

* PT3(ドライバと設定を変更することで他デバイスに対応可)
* pcsc


## How to run

``` shell
$ cd docker-chinachu
$ ./setup.sh #ホスト側のセットアップ
$ reboot #要再起動
$ cd docker-chinachu
$ docker run -d --name chinachu \
  -p 10772:10772 \
  -v `pwd`/chinachu-data:/root/chinachu-data \
  -v `pwd`/recorded:/root/chinachu/recorded \
  -v /var/run/pcscd/pcscd.comm:/var/run/pcscd/pcscd.comm \
  --device=/dev/pt3video0:/dev/pt3video0 \
  --device=/dev/pt3video1:/dev/pt3video1 \
  --device=/dev/pt3video2:/dev/pt3video2 \
  --device=/dev/pt3video3:/dev/pt3video3 \
  amaya382/chinachu
```

* PT3でない場合は, `setup.sh`でのドライバ / `config.json`の設定 / run時のdeviceオプション を適宜置き換える
* その他, パスやポート等の設定は適宜書き換える


## References

* [PT3 地デジ・ＢＳ録画環境を Docker コンテナ内に押し込める](http://qiita.com/knaka/items/829979912b7bbb529bdc)
* [docker-chinachu](https://github.com/ACUVE/docker-chinachu)
