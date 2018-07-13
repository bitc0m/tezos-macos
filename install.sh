#!/bin/sh

WORK=$HOME/Builds/build-essential
PREFIX=$HOME/local
export PATH="$PREFIX/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin"

mkdir -p $WORK/src

cd $WORK/src
curl -O -L ftp://ftp.gnu.org/gnu/m4/m4-latest.tar.xz
curl -O -L ftp://ftp.gnu.org/gnu/autoconf/autoconf-latest.tar.xz
curl -O -L ftp://ftp.gnu.org/gnu/automake/automake-1.16.tar.xz
curl -O -L ftp://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.xz
curl -O -L https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz
curl -O -L https://pkg-config.freedesktop.org/releases/pkg-config-0.29.2.tar.gz
curl https://github.com/ocaml/opam/releases/download/2.0.0-rc3/opam-2.0.0-rc3-x86_64-darwin > $PREFIX/opam

cd $WORK

# m4
tar xf src/m4-*
cd m4-*
./configure\
    --prefix=$PREFIX
make clean && make -j4 && make install-strip
cd $WORK
rm -fr m4-*

# autoconf
tar xf src/autoconf-2*
cd autoconf-2*
./configure\
    --prefix=$PREFIX\
    --disable-debug
make clean && make -j4 && make install-strip
cd $WORK
rm -fr autoconf-2*

# automake
tar xf src/automake-*
cd automake-*
./configure\
    --prefix=$PREFIX
    --disable-debug
make clean && make -j4 && make install-strip
cd $WORK
rm -fr automake-*

# libtool
tar xf src/libtool-*
cd libtool-*
./configure\
    --prefix=$PREFIX
make clean && make -j4 && make install-strip
cd $WORK
rm -fr libtool-*

# gmp
tar xf src/gmp-*
cd gmp-*
./configure\
    --prefix=$PREFIX
make clean && make -j4 && make install-strip
cd $WORK
rm -fr gmp-*

# pkg-conf
tar zxvf src/pkg-config-*
cd pkg-config-*
./configure --with-internal-glib\
    --prefix=$PREFIX
make clean && make -j4 && make install-strip
cd $WORK
rm -fr pkg-config-*

# hidapi
unzip src/hidapi-*
cd hidapi-*\mac
./configure \
    --prefix=$PREFIX
make clean && make -j4 && make install-strip
cd $WORK
rm -fr hidapi-*

#make opam executable
sudo chmod a+x $PREFIX/opam

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
