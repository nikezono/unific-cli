Unific-cli
---
[![Build Status](https://travis-ci.org/nikezono/unific-cli.png)](https://travis-ci.org/nikezono/unific-cli)

Command line interface - http://unific.net

![Image](http://gyazo.com/9c7d373fe37393e927c6a7de81b0018e.png)

### これはなに

* [Unific](http://unific.net)のCLIインターフェースです
* コンソールで動作するRSSリーダです

### Usage

     npm install -g unific-cli
     unific-cli -s nikezono # Example

### How To Edit RSS Feeds

Go [Unific.net](http://unific.net),and create your repository.

##### E.g
     http://unific.net/nikezono # nikezono's repo
     http://unific.net/eurofootball # social reader about eurofootball
     http://unific.net/1f39-11e3-8224 # your secret repo

Any authentification is required.


### Options
    -s, --stream [value]  -  select Streamname(e.g.'nikezono')
    -u, --nourl [Bool]    -  Don't show articles url
    -f, --feed [Bool]     -  show feedname

### 開発計画

* `0.1.0` -> ニュースが降ってくる
* `1.0.0` -> クリック/選択するとLynxとかで記事が読める
* `1.1.0` -> ログイン機能
* `1.2.0` -> 記事追加/削除できる
* `1.3.0` -> Star付けられる
* `1.4.0` -> ReadItLater付けられる
* `1.5.0` -> Star付けられる

など

