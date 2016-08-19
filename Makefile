SHELL := /bin/bash

# Dependency Versions
VERSION?=0.23.2
RELEASEVER?=1

# Bash data
SCRIPTPATH=$(shell pwd -P)
CORES=$(shell grep -c ^processor /proc/cpuinfo)
RELEASE=$(shell lsb_release --codename | cut -f2)

major=$(shell echo $(VERSION) | cut -d. -f1)
minor=$(shell echo $(VERSION) | cut -d. -f2)
micro=$(shell echo $(VERSION) | cut -d. -f3)

build: clean p11kit

clean:
	rm -rf /tmp/p11-kit-$(VERSION).tar.xz
	rm -rf /tmp/p11-kit-$(VERSION)

p11kit:
	cd /tmp && \
	wget http://p11-glue.freedesktop.org/releases/p11-kit-$(VERSION).tar.gz && \
	tar -xf p11-kit-$(VERSION).tar.gz && \
	cd p11-kit-$(VERSION) && \
	./configure \
		--prefix=/usr \
		--mandir=/usr/share/man/gnutls/p11-kit/$(VERSION) \
		--infodir=/usr/share/info/gnutls/p11-kit/$(VERSION) \
	    --docdir=/usr/share/doc/gnutls/p11-kit/$(VERSION) && \
	make -j$(CORES) && \
	make install

fpm_debian:
	echo "Packaging p11-kit-23 for Debian"

	cd /tmp/p11-kit-$(VERSION) && make install DESTDIR=/tmp/p11-kit-23-$(VERSION)-install

	fpm -s dir \
		-t deb \
		-n p11-kit-23 \
		-v $(VERSION)-$(RELEASEVER)~$(shell lsb_release --codename | cut -f2) \
		-C /tmp/p11-kit-23-$(VERSION)-install \
		-p p11-kit-23_$(VERSION)-$(RELEASEVER)~$(shell lsb_release --codename | cut -f2)_$(shell arch).deb \
		-m "charlesportwoodii@erianna.com" \
		--license "GPLv3" \
		--url https://github.com/charlesportwoodii/p11-kit-23-build \
		--description "p11-kit-23" \
		--deb-systemd-restart-after-upgrade

fpm_rpm:
	echo "Packaging p11-kit-23 for RPM"

	cd /tmp/p11-kit-$(VERSION) && make install DESTDIR=/tmp/p11-kit-23-$(VERSION)-install

	fpm -s dir \
		-t rpm \
		-n p11-kit-23 \
		-v $(VERSION)_$(RELEASEVER) \
		-C /tmp/p11-kit-23-$(VERSION)-install \
		-p p11-kit-23_$(VERSION)-$(RELEASEVER)_$(shell arch).rpm \
		-m "charlesportwoodii@erianna.com" \
		--license "GPLv3" \
		--url https://github.com/charlesportwoodii/p11-kit-23-build \
		--description "p11-kit-23" \
		--vendor "Charles R. Portwood II" \
		--rpm-digest sha384 \
		--rpm-compression gzip