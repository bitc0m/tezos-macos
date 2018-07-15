#!/bin/sh
PREFIX=/usr/local/bin
sudo chown -R $(whoami):admin $PREFIX

#curl -o $PREFIX/opam -L https://github.com/ocaml/opam/releases/download/2.0.0-rc3/opam-2.0.0-rc3-x86_64-darwin
curl -O -L https://mmonit.com/monit/dist/monit-5.25.2.tar.gz

# monit
tar xf src/monit-*
cd monit-*
./configure\
    --prefix=$PREFIX
make clean && make -j4 && make install-strip
cd $WORK
rm -fr monit-*
