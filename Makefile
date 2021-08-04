## If you change this version, make sure you run 'make clean'
VERSION=20210802
RELEASE=1

ROOT:=$(shell pwd)
BUILDDIR:=$(ROOT)/build
DOWNLOADS:=$(ROOT)/downloads
DEBDEST:=$(BUILDDIR)/debs

include Makefile.common

# Configure githash, releases etc in here
include Makefile.settings

MAKEFILES := common settings

.PHONY: help shell setup debs clean distclean

help:
	@echo "Instructions:"
	@echo "  'make shell'     - gives you a shell in the basedocker container"
	@echo "  'make clean'     - Removes all packages and builds"
	@echo "  'make distclean' - Same as clean but also removes download cache"
	@echo "Building:"
	@echo "  'make debs'      - Build all the things"
	@echo "  'make stage1'    - Build all the debs required to build freeswitch"
	@echo "  'make fsdocker'  - Build stage1, build the fscontainer using those debs"
	@echo "  'make freeswitch'- Build freeswitch using the fsdocker container"

# Load all our associated makefiles
include $(wildcard includes/Makefile.*)

shell: setup $(BASEDOCKERTAG)
	docker run --rm $(VOLUMES) -it basedocker:$(VERSION) bash

setup: | /usr/local/ccache/ccache.conf $(BUILDSOURCE) $(BUILDDIR) $(DOWNLOADS) $(DEBDEST)


/usr/local/ccache/ccache.conf: ccache.conf
	mkdir -p $(@D) && cp $< $@

clean:
	rm -rf build $(DOCKERTAGS) $(DEBDEST)/ *docker/*deb basedocker/docbook-xsl-snapshot.zip testdocker/*gz

distclean: clean
	rm -rf downloads/

stage1: $(addprefix $(DEBDEST)/,$(SRCDEBS))
	@echo Stage 1 debs complete, build $(SRCDEBS)

debs: stage1 freeswitch

libssdocker/%.deb fsdocker/%.deb: $(DEBDEST)/%.deb
	cp $< $@

