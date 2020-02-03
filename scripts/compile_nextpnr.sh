# -- Compile nextpnr script

set -eux

NEXTPNR=nextpnr
NEXTPNR_ARCH=ice40
NEXTPNR_BIN=$NExTPNR-$NEXTPNR_ARCH
COMMIT=aed93a9390dd909111ab4526e7f3df8d24a2ee0a
GIT_NEXTPNR=https://github.com/YosysHQ/nextpnr.git

# -- Setup
. $WORK_DIR/scripts/build_setup.sh

cd $UPSTREAM_DIR

# -- Clone the sources from github
test -e $NEXTPNR || git clone $GIT_NEXTPNR $NEXTPNR
git -C $NEXTPNR pull
git -C $NEXTPNR checkout $COMMIT
git -C $NEXTPNR log -1

# -- Copy the upstream sources into the build directory
rsync -a $NEXTPNR $BUILD_DIR --exclude .git

cd $BUILD_DIR/$NEXTPNR

# -- Compile it
cmake -DARCH=ice40 -DICEBOX_ROOT="../icestorm/share/icebox" -DBUILD_PYTHON=OFF -DBUILD_GUI=OFF -DSTATIC_BUILD=ON .
make -j$J

EXE_O=
if [ -f bin/$NEXTPNR_BIN.exe ]; then
  EXE_O=.exe
fi

# -- Test the generated executables
test -e share/$NEXTPNR/chipdb-1k.bin || exit 1
test -e share/$NEXTPNR/chipdb-5k.bin || exit 1
test -e share/$NEXTPNR/chipdb-8k.bin || exit 1
test -e share/$NEXTPNR/chipdb-384.bin || exit 1
test -e share/$NEXTPNR/chipdb-lm4k.bin || exit 1
test_bin bin/$NEXTPNR_BIN$EXE_O

# -- Copy the executable to the bin dir
cp bin/$NEXTPNR_BIN$EXE_O $PACKAGE_DIR/$NAME/bin/$NEXTPNR_BIN$EXE

# -- Copy the chipdb*.bin data files
mkdir -p $PACKAGE_DIR/$NAME/share/$NEXTPNR
cp -r share/$NEXTPNR/chipdb*.bin $PACKAGE_DIR/$NAME/share/$NEXTPNR
