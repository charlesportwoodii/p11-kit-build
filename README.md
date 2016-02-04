# p11-kit build

This repository allows you to build and package p11-kit

## Dependencies

```
apt-get install build-essential libgmp-dev libunbound-dev m4
```

# Building and Packaging
```
git clone https://github.com/charlesportwoodii/p11-kit-build
cd p11-kit-build

sudo make VERSION=<version>
# deb packages can be built with
# sudo make package VERSION=<version>
```
