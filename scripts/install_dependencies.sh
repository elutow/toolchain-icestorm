# Install dependencies script

set -eu

if [ $ARCH == "linux_x86_64" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz \
                          xdot pkg-config python3 libboost-all-dev zlib1g-dev \
                          libeigen3-dev gperf autoconf libgmp-dev cmake qt5-default \
                          gcc g++
  sudo apt-get autoremove -y
  gcc --version
  g++ --version
fi

if [ $ARCH == "linux_i686" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev:i386 \
                          gawk tcl-dev:i386 libffi-dev:i386 git mercurial graphviz \
                          xdot pkg-config python3 libboost-all-dev:i386 zlib1g-dev:i386 \
                          libeigen3-dev:i386 gperf autoconf libgmp-dev:i386 cmake qt5-default \
                          gcc-multilib g++-multilib
  sudo apt-get autoremove -y
  gcc --version
  g++ --version
fi

if [ $ARCH == "linux_armv7l" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev:armhf \
                          gawk tcl-dev:armhf libffi-dev:armhf git mercurial graphviz \
                          xdot pkg-config python3 libboost-all-dev:armhf zlib1g-dev:armhf \
                          libeigen3-dev:armhf gperf autoconf libgmp-dev:armhf cmake qt5-default \
                          gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf \
                          binfmt-support qemu-user-static
  sudo apt-get autoremove -y
  arm-linux-gnueabihf-gcc --version
  arm-linux-gnueabihf-g++ --version
fi

if [ $ARCH == "linux_aarch64" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev:arm64 libffi-dev:arm64 git mercurial graphviz \
                          xdot pkg-config python3 libboost-all-dev:arm64 zlib1g-dev:arm64 \
                          libeigen3-dev:arm64 gperf autoconf libgmp-dev:arm64 cmake qt5-default \
                          gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
                          binfmt-support qemu-user-static
  sudo apt-get autoremove -y
  aarch64-linux-gnu-gcc --version
  aarch64-linux-gnu-g++ --version
fi

if [ $ARCH == "windows_x86" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev:i386 libffi-dev:i386 git mercurial graphviz \
                          xdot pkg-config python3 libboost-all-dev:i386 zlib1g-dev \
                          libeigen3-dev:i386 gperf autoconf libgmp-dev:i386 cmake qt5-default \
                          gcc-mingw-w64 gc++-mingw-w64 wine-development
                          #mingw-w64 mingw-w64-tools
  sudo apt-get autoremove -y
  i686-w64-mingw32-gcc --version
  i686-w64-mingw32-g++ --version
fi

if [ $ARCH == "windows_amd64" ]; then
  sudo apt-get install -y build-essential bison flex libreadline-dev \
                          gawk tcl-dev libffi-dev git mercurial graphviz \
                          xdot pkg-config python3 libboost-all-dev zlib1g-dev \
                          libeigen3-dev gperf autoconf libgmp-dev cmake qt5-default \
                          gcc-mingw-w64 gc++-mingw-w64 wine-development
                          #mingw-w64 mingw-w64-tools
  sudo apt-get autoremove -y
  x86_64-w64-mingw32-gcc --version
  x86_64-w64-mingw32-g++ --version
fi

if [ $ARCH == "darwin" ]; then
  # Be more verbose for CI debugging
  set -ux
  which -s brew
  if [[ $? != 0 ]] ; then
    # Install Homebrew
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    brew update
  fi
  DEPS="bison flex gawk libffi git mercurial graphviz \
        pkg-config python3 libusb libftdi gnu-sed wget \
        llvm tcl-tk xdot cmake boost boost-python3 qt5 eigen"
  brew install --force $DEPS
  brew upgrade python
  brew link --overwrite --force $DEPS
  # Determine command paths for CI debugging
  which gsed
  which clang
else
  cp $WORK_DIR/build-data/lib/$ARCH/libftdi1.a $WORK_DIR/build-data/lib/$ARCH/libftdi.a
fi
