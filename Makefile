## If you change this version, make sure you run 'make clean'
VERSION=20210802
RELEASE=1

BUILDDIR=$(shell pwd)/build
DOWNLOADS=$(shell pwd)/downloads
DEBDEST=$(BUILDDIR)/debs

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

# This autoloads anything matching Makefile.*, excluding common, which
# we have already loaded
define doinclude =
$(warning Loading $1)
$(eval include $1)
$(eval MAKEFILES += $1)
endef
AUTOLOAD:=$(foreach m,$(wildcard includes/Makefile.*),$(eval $(call doinclude,$(m))))

debug:
	@echo $(MAKEFILES)

shell: setup $(BASEDOCKERTAG)
	docker run --rm $(VOLUMES) -it basedocker:$(VERSION) bash

setup: | /usr/local/ccache/ccache.conf $(BUILDSOURCE) $(BUILDDIR) $(DOWNLOADS) $(DEBDEST)

clean:
	rm -rf build $(DOCKERTAGS) $(DEBDEST)/ *docker/*deb basedocker/docbook-xsl-snapshot.zip testdocker/*gz

distclean: clean
	rm -rf downloads/

stage1: $(addprefix $(DEBDEST)/,$(SRCDEBS))
	@echo Stage 1

debs: stage1

libssdocker/%.deb fsdocker/%.deb: $(DEBDEST)/%.deb
	cp $< $@
