#!/bin/bash
set -e

# ==== Configuration ====
VERSION=2.2.0
SRC_DIR=ceres-solver-$VERSION
TARBALL=ceres-solver-$VERSION.tar.gz
URL=https://github.com/ceres-solver/ceres-solver/archive/refs/tags/$VERSION.tar.gz

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
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
cd ..
debuild -us -uc

# ==== Done ====
cd ..
echo "Build complete. DEB packages are in: $(pwd)"
