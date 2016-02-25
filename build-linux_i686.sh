##############################
# Icestorm toolchain builder #
##############################

# Generate toolchain-icestorm.tar.gz from source code
# sources: http://www.clifford.at/icestorm/
# This tarball can be unpacked in ~/.platformio/packages

NAME=toolchain-icestorm
ARCH=linux_i686
VERSION=6
PACKNAME=$NAME-$ARCH-$VERSION
TCDIR=$PWD/dist/$NAME
TARBALL=$PWD/dist/$PACKNAME.tar.gz

# Store current dir
WORK=$PWD

nproc=2

# Enter into the code directory
mkdir -p dist; cd dist

# Install dependencies
sudo apt-get install build-essential clang bison flex libreadline-dev \
                     gawk tcl-dev libffi-dev git mercurial graphviz   \
                     xdot pkg-config python python3 libftdi-dev

# Install Icestorm
git -C icestorm pull || git clone https://github.com/cliffordwolf/icestorm.git icestorm
cd icestorm
if [ "$1" == "clean" ]; then
    make clean
fi
cp $WORK/packages/build_i686/Makefile.icetools Makefile
cp $WORK/packages/build_i686/Makefile.iceprog iceprog/Makefile
cp $WORK/packages/build_i686/Makefile.icetime icetime/Makefile
cp $WORK/packages/build_i686/Makefile.icepack icepack/Makefile
make 
make install DESTDIR=$TCDIR PREFIX=""
cd ..

# Install Arachne-PNR
git -C arachne-pnr pull || git clone https://github.com/cseed/arachne-pnr.git arachne-pnr
cd arachne-pnr
if [ "$1" == "clean" ]; then
    make clean
fi
cp $WORK/packages/build_x86_64/Makefile.arachne Makefile
make 
make install DESTDIR=$TCDIR PREFIX="" ICEBOX="$TCDIR/share/icebox"
cd ..

# Install Yosys
git -C yosys pull || git clone https://github.com/cliffordwolf/yosys.git yosys
cd yosys
if [ "$1" == "clean" ]; then
    make clean
fi
cp $WORK/packages/build_x86_64/Makefile.yosys Makefile
make  || exit 1
make install DESTDIR=$TCDIR PREFIX=""
cd ..

# Package tarball
tar -czvf $TARBALL $NAME