# 試して覚えよう！ SSHポートフォワーディング

[「まんがでわかるLinux シス管系女子」発売記念！ 作者と学ぶ コマンドライン ハンズオン勉強会](https://system-admin-girl.doorkeeper.jp/events/22836)用の発表資料です。

[印刷用資料](printable-sheets/printable.pdf)もあります。
これには、ハンズオンのためのメモ記入領域と、SSHポートフォワードのチートシートが含まれています。

## 作者向け

### 表示

    rake

### rabbirackを使用して携帯端末から操作する

    gem install rabbirack
    rabbirack rackup -- --host 0.0.0.0

この状態で、携帯端末で http://(ip address):10102/ を訪問する。

### 公開

    rake publish

## 閲覧者向け

### インストール

    gem install rabbit-slide-Piro-system-admin-girl-handson

### 表示

    rabbit rabbit-slide-Piro-system-admin-girl-handson.gem

