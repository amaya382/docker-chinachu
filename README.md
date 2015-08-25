## About this

dockerコンテナ上でchinachuの実行環境を提供する


## Environment

* PT3(ドライバを変更することで他デバイスに対応可?)
* pcsc


## How to build(既存の設定ファイルを予め反映したい場合のみ)

``` shell
$ cd docker-chinachu
# cp -R /path/to/existing/conf/and/data chinachu #[OPT] chinachuディレクトリ下に既存の設定ファイルやdataをコピー
$ docker build -t amaya382/chinachu:{version} .
```

既存の設定やdataを`docker-chinachu/chinachu`ディレクトリに入れておくことで, ビルド時にコンテナ内に反映される


## How to run

``` shell
$ ./prepare.sh #ホスト側のセットアップ
$ reboot #要再起動
$ docker run -d --name chinachu \
--privileged \
-p 10772:10772 \
-v /dev/:/dev/ \
-v /var/run/pcscd/pcscd.comm:/var/run/pcscd/pcscd.comm \
-v /path/to/save/on/host/:/home/chinachu/chinachu/recorded/ \
amaya382/chinachu:lastest
```

* PT3でない場合は, `prepare.sh`内でPT3のドライバ部分を適宜置き換える
* パスやポートは, `chinachu/config.json`や環境に合わせて適宜変更
* ビルド時に既存の設定やdataを入れていない場合, 初回起動時は, コンテナに接続して設定(主に`wuiUsers`や`tuners`等)を調整し, コミットしておく. または`-v`でホスト側に置いた設定ファイルを使う


## References

* [PT3 地デジ・ＢＳ録画環境を Docker コンテナ内に押し込める](http://qiita.com/knaka/items/829979912b7bbb529bdc)
* [docker-chinachu](https://github.com/ACUVE/docker-chinachu)
