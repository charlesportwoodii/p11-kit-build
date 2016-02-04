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
		--mandir=/usr/share/man/gnutls-$(VERSION) \
		--infodir=/usr/share/info/gnutls-$(VERSION) \
	    --docdir=/usr/share/doc/gnutls-$(VERSION) && \
	make -j$(CORES) && \
	make install

package:
	cd /tmp/p11-kit-$(VERSION) && \
	checkinstall \
	    -D \
	    --fstrans \
	    -pkgrelease "$(RELEASEVER)"-"$(RELEASE)" \
	    -pkgrelease "$(RELEASEVER)"~"$(RELEASE)" \
	    -pkgname "p11-kit-23" \
	    -pkglicense GPLv3 \
	    -pkggroup GPG \
	    -maintainer charlesportwoodii@ethreal.net \
	    -provides "p11-kit-23" \
	    -requires "" \
	    -replaces "p11-kit" \
	    -pakdir /tmp \
	    -y