#!/bin/sh
PREFIX=/usr/local/bin
WORK=$HOME/src
mkdir -p $WORK

curl -O -L https://mmonit.com/monit/dist/monit-5.25.2.tar.gz

# monit
tar xf monit-*
cd monit-*
./configure --without-ssl\
    --prefix=$PREFIX
make clean && make -j4 && make install-strip
cd $WORK
rm -fr monit-*
cd $HOME
rm -rf $WORK
