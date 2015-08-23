## About this

dockerコンテナ上でchinachuの実行環境を提供する


## Environment

* Ubuntu想定
* PT3(ドライバを変更することで他デバイスに対応可?)
* pcsc


## How to build

``` shell
cd docker-chinachu
# cp -R /path/to/existing/conf/and/data chinachu #[OPT] chinachuディレクトリ下に既存の設定ファイルやdataをコピー
docker build -t amaya/chinachu:{version} .
```

既存の設定やdataを`docker-chinachu/chinachu`ディレクトリに入れておくことで, ビルド時にコンテナ内に反映される


## How to run

``` shell
./prepare.sh #ホスト側のセットアップ
reboot #要再起動
docker run -d --name chinachu \
 --privileged \
 -v /dev/:/dev/ \
 -v /var/run/pcscd/pcscd.comm:/var/run/pcscd/pcscd.comm \
 -v /path/to/save/on/host:/path/to/save/in/container \
 amaya/chinachu:{version}
```

* ホストにdockerが未インストールなら, `prepare.sh`内で要インストール
* PT3でない場合は, `prepare.sh`内でPT3のドライバ部分を適宜置き換える
* `/path/to/save/in/container`は`recordedDir`にあたるパスをホストの任意のパスにマウントする
* ビルド時に既存の設定やdataを入れていない場合, 初回起動時は, コンテナに接続して設定(主に`wuiUsers`や`tuners`等)を調整し, コミットしておく


## References

* [PT3 地デジ・ＢＳ録画環境を Docker コンテナ内に押し込める](http://qiita.com/knaka/items/829979912b7bbb529bdc)
* [docker-chinachu](https://github.com/ACUVE/docker-chinachu)
