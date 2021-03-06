#!/bin/sh
PREFIX=/usr/local/bin
sudo chown -R $(whoami):admin $PREFIX

#download copy of linux opam 2.0.0 (RC4 final) build and save as /usr/local/bin/opam
/usr/bin/curl "https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh" | bash -s

# m4
brew install m4
brew link m4

# autoconf
brew install autoconf
brew link autoconf

# automake
brew install automake
brew link automake

# libtool
brew install libtool
brew link libtool

# gmp
brew install gmp
brew link gmp

# pkg-conf
brew install pkg-config
brew link pkg-config

# hidapi
brew install hidapi
brew link hidapi

# libevent
brew install libevent

#make opam executable
sudo chmod a+x $PREFIX/opam

#initiate Opam
$PREFIX/opam init -y --compiler=4.06.1

#evalute configuration environment
eval $(opam env)

git clone -b betanet https://gitlab.com/tezos/tezos.git & wait
{ sleep 5; echo waking up after 5 seconds; } & wait
cd tezos

#build dependencies
make build-deps

#evaluate
eval $(opam env)

#build 
make
