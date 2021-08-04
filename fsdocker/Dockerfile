ARG VERSION
FROM basedocker:${VERSION}

RUN apt-get -y install python-all-dev

ENV FS_FILES_DIR=/usr/local/build/SOURCES

ADD alldebs.tar.gz /usr/local/

RUN apt-get -y install /usr/local/*.deb


