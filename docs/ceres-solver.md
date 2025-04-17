## 🔧Dependencies (Ubuntu)

```bash
sudo apt install cmake build-essential pkg-config libeigen3-dev \
    libgflags-dev libgoogle-glog-dev libatlas-base-dev libsuitesparse-dev curl -y
```

## Get deb packages

```bash
curl -s https://api.github.com/repos/xxl1998/PackX/releases/latest \
| grep "browser_download_url.*\.deb" \
| cut -d '"' -f 4 \
| xargs wget -c
```

## 📥 Install .deb Package

```bash
sudo dpkg -i ceres-solver_2.2.0_amd64.deb
```

## 🚀 Compile and Run Test Code

```bash
cd projects/ceres-solver/test
mkdir build && cd build
cmake ..
make
./ceres_test
```
