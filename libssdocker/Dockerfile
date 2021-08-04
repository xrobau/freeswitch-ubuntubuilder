ARG VERSION
FROM basedocker:${VERSION}

ADD *deb /usr/local/
RUN ls -al /usr/local && apt-get -y install /usr/local/*deb && rm -f /usr/local/*deb


