#!/bin/bash
set -e

# ==== Configuration ====
VERSION=2.2.0
SRC_DIR=${PROJ_PATH}/ceres-solver-$VERSION
TARBALL=ceres-solver-$VERSION.tar.gz
URL=https://github.com/ceres-solver/ceres-solver/archive/refs/tags/$VERSION.tar.gz

# ==== Install dependencies ====
export DEBIAN_FRONTEND=noninteractive
DEBIAN_FRONTEND=noninteractive sudo apt install libeigen3-dev libgflags-dev libgoogle-glog-dev libatlas-base-dev libsuitesparse-dev -y

# ==== Download source ====
if [ ! -f $TARBALL ]; then
  echo "Downloading Ceres Solver $VERSION source..."
  wget -O $TARBALL $URL
fi

# ==== Extract ====
rm -rf $SRC_DIR
tar -xzf $TARBALL

# ==== Inject debian/ folder ====
cp -r "${PROJ_PATH}/debian" "${SRC_DIR}/debian"

# ==== Build ====
cd $SRC_DIR
mkdir -p build
mkdir install
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=../install/usr/local
make -j$(nproc)
make install
cd ..
mkdir -p ${SRC_DIR}/install/DEBIAN
cp  "${PROJ_PATH}/debian/control" "${SRC_DIR}/install/DEBIAN/control"
echo "REPO_PATH=$REPO_PATH"
echo "PROJ_PATH=$PROJ_PATH"
ls -al ${SRC_DIR}/install/DEBIAN
ls -al ${PROJ_PATH}/debian/
fakeroot dpkg-deb --build install ../ceres-solver_2.2.0.deb

# ==== Done ====
cd ..
echo "Build complete. DEB packages are in: $(pwd)"
