#!/bin/bash
# Run as root, like:
#   # curl https://raw.githubusercontent.com/piroor/system-admin-girl-handson/master/scripts/setup-front.sh | bash

STATIC_IP_ADDRESS=192.168.0.100


echo 'Setting up this computer as the "front"...'


echo 'Downloading scripts to configure connections...'

curl -O https://raw.githubusercontent.com/piroor/system-admin-girl-handson/master/scripts/allow-ssh.sh
chmod +x ~/allow-ssh.sh

curl -O https://raw.githubusercontent.com/piroor/system-admin-girl-handson/master/scripts/disallow-ssh.sh
chmod +x ~/disallow-ssh.sh


echo 'Creating a new user "user"...'

# rootでログインせずに済むように、作業用のユーザーを作成する。
# 名前は「user」、パスワードも「user」。
# ログイン後に自分でpasswdコマンドを実行してパスワードを変更する事を強く推奨。
useradd user
if [ $? = 0 ]
then
  echo "user" | passwd user --stdin
fi

# 鍵認証できるように、公開鍵の設定をしておく。
mkdir -p ~user/.ssh
cp ~/.ssh/authorized_keys ~user/.ssh/
chown -R user:user ~user/.ssh
chmod 600 ~user/.ssh/authorized_keys


echo 'Activating eth1...'
# インターフェースを有効化するために必要な設定を作成する。
# See: https://www.conoha.jp/guide/guide.php?g=36

# NICのMACアドレスをifconfigの出力から取り出す。
ETH1_MAC_ADDRESS=$(ifconfig eth1 | grep HWaddr | sed -r -e 's/^.* ([0-9A-Z:]+)/\1/')
echo "Detected MAC Address of eth1: $ETH1_MAC_ADDRESS"

ETH1_CONFIG=/etc/sysconfig/network-scripts/ifcfg-eth1
echo 'DEVICE="eth1"'                 >  $ETH1_CONFIG
echo "HWADDR=\"$ETH1_MAC_ADDRESS\""  >> $ETH1_CONFIG
echo 'BOOTPROTO="static"'            >> $ETH1_CONFIG
echo "IPADDR=\"$STATIC_IP_ADDRESS\"" >> $ETH1_CONFIG
echo 'NETMASK="255.255.255.0"'       >> $ETH1_CONFIG
echo 'NM_CONTROLLED="no"'            >> $ETH1_CONFIG
echo 'TYPE="Ethernet"'               >> $ETH1_CONFIG
echo 'ONBOOT="yes"'                  >> $ETH1_CONFIG

echo 'Restarting interfaces...'
service network restart


echo 'Configuring sshd...'
# SSH経由での直接のrootログインを禁止する。
# パスワード認証を許可する。（話を簡単にするため）

SSHD_CONFIG=/etc/ssh/sshd_config
SSHD_CONFIG_BACKUP=~/sshd_config.bak.$(date +%Y-%m-%d_%H-%M-%S)

mv $SSHD_CONFIG $SSHD_CONFIG_BACKUP
cat $SSHD_CONFIG_BACKUP | \
  sed -r -e 's/^# *PermitRootLogin +yes/PermitRootLogin no/' \
         -e 's/^( *PasswordAuthentication +no)/#\1/' \
         -e 's/^#( *PasswordAuthentication +yes)/\1/' \
  > $SSHD_CONFIG

service sshd restart


echo 'Done.'
