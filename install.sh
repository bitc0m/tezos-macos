#!/bin/sh

#assign user rights to /usr/local/bin
sudo mkdir /usr/local/lib /usr/local/include
sudo /usr/sbin/chown -R $(whoami):admin /usr/local/bin /usr/local/share /usr/local/lib /usr/local/include /usr/local/sbin

#check for pkg-conf
if ! pkgconf_loc="$(type -p "pkg-config")" || [[ -z $pkgconf_loc ]]; then 
  tar -zxvf <(curl -sL https://pkg-config.freedesktop.org/releases/pkg-config-0.29.2.tar.gz) &>/dev/null && mv ./pkg-config-0.29.2 ./pkg-conf 
  (cd ./pkg-conf && ./configure --with-internal-glib && make && make install)
fi

#check for gmp
gmp_h=/usr/local/include/gmp.h
if [ ! -f $gmp_h ]; then 
  tar -xf <(curl -sL https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz) &>/dev/null && mv ./gmp-6.1.2 ./gmp
  (cd ./gmp && ./configure --with-internal-glib &>/dev/null && make &>/dev/null && make install)
fi

#download Gitlab Repo for betanet
curl -o /usr/local/bin/opam -L https://github.com/ocaml/opam/releases/download/2.0.0-rc3/opam-2.0.0-rc3-x86_64-darwin

#make opam executable
sudo chmod a+x /usr/local/bin/opam

#initiate Opam
opam init -y --compiler=4.06.1

#evalute configuration environment
eval `opam config env`


git clone -b betanet https://gitlab.com/tezos/tezos.git & wait
{ sleep 5; echo waking up after 5 seconds; } & wait
cd tezos

#install packages if not already
sudo apt-get install gmp

#build dependencies
make build-deps

#evaluate
eval $(opam env)

#build 
make
