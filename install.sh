#!/bin/sh

#assign user rights to /usr/local/bin
sudo /usr/sbin/chown -R $(whoami) /usr/local/bin

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

#build dependencies
make build-deps

#evaluate
eval $(opam env)

#build 
make
