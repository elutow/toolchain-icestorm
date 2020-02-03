# -- Compile nextpnr script

set -eux

NEXTPNR=nextpnr
NEXTPNR_ARCH=ice40
NEXTPNR_BIN=$NEXTPNR-$NEXTPNR_ARCH
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
# NOTE: We are assuming compile_icestorm.sh is already invoked
cmake -DARCH=ice40 -DICEBOX_ROOT="$PACKAGE_DIR/$NAME/share/icebox" -DBUILD_PYTHON=ON -DBUILD_GUI=OFF -DSTATIC_BUILD=ON -DCMAKE_INSTALL_PREFIX="$PACKAGE_DIR/$NAME" $CMAKE_ARCHFLAGS .
make -j$J
make install

EXE_O=
if [ -f $PACKAGE_DIR/$NAME/bin/$NEXTPNR_BIN.exe ]; then
  EXE_O=.exe
fi

# -- Test the generated executables
test_bin $PACKAGE_DIR/$NAME/bin/$NEXTPNR_BIN$EXE_O
