FROM ubuntu:noble

ARG VERSION
ENV VERSION=${VERSION}

RUN echo Base container version ${VERSION} is used as a trigger to invalidate cache and rebuild.

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install ccache
COPY ccache.conf /usr/local/ccache/
ENV PATH=/usr/lib/ccache/:usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV CCACHE_CONFIGPATH=/usr/local/ccache/ccache.conf

# Standard packages
RUN apt-get -y install build-essential autoconf libtool libtool-bin vim xz-utils \
	devscripts cowbuilder git screen ccache debhelper libtiff-dev libjpeg-dev \
	doxygen autotools-dev xsltproc libxml2-utils docbook-xsl docbook \
	xz-utils pkgconf uuid uuid-dev cmake libssl-dev libcurl4-openssl-dev \
	libjansson-dev libjansson4 software-properties-common check libglib2.0-dev \
	graphviz libuuid1

# These are all required to build freeswitch later, but there's no need to redownload
# them every time, so grab them now.
RUN apt-get -y install libedit-dev libsqlite3-dev libtiff5-dev yasm libogg-dev libspeex-dev \
	libspeexdsp-dev unixodbc-dev libpq-dev libncurses5-dev erlang-dev \
	libtpl-dev libexpat1-dev libgdbm-dev libdb-dev bison libavformat-dev libswscale-dev
RUN apt-get -y install libopencv-dev libldns-dev libhiredis-dev ladspa-sdk \
	libmemcached-dev libsoundtouch-dev libopencore-amrnb-dev libcodec2-dev libopus-dev \
	libmariadb-dev libldap2-dev libasound2-dev portaudio19-dev libperl-dev
RUN apt-get -y install librabbitmq-dev libsnmp-dev libmagickcore-dev libopusfile-dev libvorbis-dev \
	libmp3lame-dev libmpg123-dev libshout3-dev libsndfile1-dev libflac-dev libvlc-dev \
	default-jdk liblua5.2-dev libmono-2.0-dev mono-mcs libyaml-dev libnode-dev erlang-dev \
	flite1-dev libgdbm-compat-dev autoconf-archive

# This is run last to make sure everything is set back to python2, from python3
#RUN apt-get -y install python2-dev dh-python
#RUN update-alternatives --install /usr/bin/python python /usr/bin/python2 1

# Let my people paste!
RUN echo "bind 'set enable-bracketed-paste off'" >> /etc/bash.bashrc

# This is for spandsp wanting to create documents using a recent docbook publication
COPY docbook-xsl-snapshot.zip /usr/local
RUN cd /usr/local && unzip docbook-xsl-snapshot.zip && rm -f docbook-xsl-snapshot.zip
RUN xmlcatalog --noout --add "delegateSystem" "https://cdn.docbook.org/release/xsl/current/" "file:///usr/local/docbook-xsl-snapshot/catalog.xml" /etc/xml/catalog
RUN xmlcatalog --noout --add "delegateURI" "https://cdn.docbook.org/release/xsl/current/" "file:///usr/local/docbook-xsl-snapshot/catalog.xml" /etc/xml/catalog

# Hack dh_builddeb to always use -Zxz
RUN sed -i 's/"--build/"-Zxz", "--build/' /usr/bin/dh_builddeb

ARG CPUTUNE
# This outputs to stdout so the cache will be invalidated when it changes.
RUN echo "CPUTune set to ${CPUTUNE}"
RUN if [ "${CPUTUNE}" ]; then echo "APPEND CFLAGS ${CPUTUNE}\nAPPEND CXXFLAGS ${CPUTUNE}\n" > /etc/dpkg/buildflags.conf; fi

WORKDIR /usr/local/build


