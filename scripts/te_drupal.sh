#!/bin/bash

echo "Welcome to TE Drupal installer. You must have a deployment passphrase to use this tool."

read -p "Install deployment key? (y/n): " install_key

if [ "$install_key" == "y" ]; then
  mkdir -p "$HOME/.ssh"
  if [ -f "$HOME/.ssh/id_rsa" ]; then
    mv "$HOME/.ssh/id_rsa" "$HOME/.ssh/id_rsa_backup"
  fi
  cat <<EOF > "$HOME/.ssh/id_rsa"
-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: DES-EDE3-CBC,D16B5ED874635AE3

YWnxiTrM/olIhBEvjKrge5uhfWvyZY9Y+7lMc62i4lnxM3Mtotcp/i7ZgYqL9S6T
eWvCyfzPp1chaQA2N/GIavkEEP2hQuChuKN1DSyJ3sga8Y7Q7FBniIV1KHf4Vl4l
w2S9dpBBQ+54BqxyZUvdi6tCNDzF42y06n0q20XwKSCwRS7W8pKgHgaRxIQEnOG/
gX1vOL4pYIS5kY4bFa/ejLDZYtF54bgEgv1pj8/y/4A1hIHMnzvTNlIHWulJvkNP
XQbzRKBWwiJsmEC13dzUqXaaHAwQASrULnKREYbqC8wnY89MSF+wYU0fd/aEpAkv
3RbcQNcv7ekmlnBNv3F3MA23wRN2sM1hqWsucjQNRwvqQjrDqHsPZHeFKl8vf/ZL
MbcnYg1D8Hz+scNCt5M7XWvFnbHNSSmdBvU722qiQRYEQv8+e9RdFP7CUOWpLWYP
QOrJ7GKQKsleEkLZ5aN509zjk5SYP4H7deCQKjOyl60dplXyN3Cv4vjaHhPm+qx/
/BENdE94c7T2i5viBZoikRdMYUHjY90te0Ny5Mqo+/gW0bBumVpDrLt5AdsFvIYR
qeUAV+5q6c5qm6UlnLMcVO2IZu4qYkd8xOvnuh+0XPKx38HUOrEK3m/GV0nMNyQ/
Cgje1Zyj1RvtpT080dCogE0dcG1tvHeJDAn0cckkF+hMChg3tImAFeMrYkEXyaMA
/A0xr5oH+Lxkf6XXzbngY4fQz7zNQRMVap3OUBhSUTgmfIyTjSlIAIgTBE76KoXN
bL33JJfVP6b7mOxmen9gbKcZexTNvKEsmv9wozPi4iC2Br88ZmsDgGwzBBSt8Xad
AgAN3oUpRYF7LhzNpCnXrF21R6RCpHXUckaXKYm+nZlv4bhievJtEZt7tK+RVEWi
fxk6LzbWThZzMzKcb21WSpvFeXCWwdTKAZyMs1OAeqf/Kdvh+5IIH+hhnQbq8dxo
4VyF0MsT14f5LnwtIFM5gp4Dl1X5nxLE2+Fh/9wRbijIlLLbH3tm4pGn65LXEB91
QR65XP4veJcSV59n3/kMdOHuno928C4VwoBvNfryFsEcydlrtHaGHQhEGgGczIbF
8lsdhyONitPQ/ID5q5l1Efuzb+JS6u4QjfQk7mLQJhMh4i0E3+jGrFRVG1hjVyke
31Viy989dUj50fFljhM8hQqPLz73fgClompZmLZjHUhSmAHdn/gXPt6GfR8DFXJc
P0RBkHHWoOwk6Q3e4l4crv8tnF9vSmgLZ+d/1njgGXIPHs9E7uPTbUboFVwLPNri
FIbInn6HZvbUKY2/eGWdTlBA7UkhIwa1rR/ng/1ieJSfWMfjP6W35tYsPSW4KNYK
R7oK2U249vQgAlQNWoQehxTVGezMnSaOCyKRWxW82b+QY7s7VBFscjwLi0avQ2h+
DCRRw/ym7MWb9Q4wa+Z+pYkdriyqazw/bpVcn8Mn86oBLovgtVaqF1Ssj1+iz27A
2XX2ItIoK/4l/RNZMPA+QSGrnlY52yeCgv1xqxjEcnXcg9NgDtU0Ek8VSu3uvUt3
oc7Xp/npReES13+NFGr4Ca8HBkHDKuXqm0BwDaYLzGoYWdeLDBJwhw==
-----END RSA PRIVATE KEY-----
EOF
  chmod 600 "$HOME/.ssh/id_rsa"
  exec /usr/bin/ssh-agent $SHELL
  ssh-add
fi

read -p "Install git? (y/n): " install_git

if [ "$install_git" == "y" ]; then
  yum=`whereis yum | awk '{print $2}'`
  if [ -n "$yum" ]; then
    sudo yum install git-core
  else 
    apt=`whereis apt-get | awk '{print $2}'`
    if [ -n "$apt" ]; then
      sudo apt-get install git-core
    else
      echo "No package manager found! Exiting."
      exit
    fi
  fi
fi

install_drush_make="n"

read -p "Install drush? (y/n): " install_drush

if [ "$install_drush" == "y" ]; then
  sudo pear channel-discover pear.drush.org
  sudo pear install Console_Table
  sudo pear install drush/drush
  install_drush_make="y"
fi

if [ "$install_drush_make" == "n" ]; then
  read -p "Install drush_make? (y/n): " install_drush_make
fi

if [ "$install_drush_make" == "y" ]; then
  tmp_drush_make=/tmp/drush_make-$RANDOM
  wget -P "$tmp_drush_make" "http://ftp.drupal.org/files/projects/drush_make-6.x-2.3.tar.gz"
  pwd=`pwd`
  cd "$tmp_drush_make"
  tar -xf "drush_make-6.x-2.3.tar.gz"
  mkdir -p $HOME/.drush 
  mv drush_make $HOME/.drush
  rm -Rf $HOME/.drush/cache
  cd "$pwd"
  rm -Rf "$tmp_drush_make"
fi

read -p "TE Drupal install destination?: " install_destination

tmp=/tmp/te_drupal-$RANDOM
git clone git@git.terraeclipse.com:drupal/te_drupal "$tmp"

drush make --prepare-install $tmp/te_drupal.make "$install_destination"
rm -Rf "$tmp"
if [ -f "$HOME/.ssh/id_rsa_backup" ]; then
  rm -f "$HOME/.ssh/id_rsa"
  mv "$HOME/.ssh/id_rsa_backup" "$HOME/.ssh/id_rsa"
fi
echo "Installed TE Drupal in $install_destination!"

