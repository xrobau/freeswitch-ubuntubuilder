ARG VERSION
FROM basedocker:${VERSION}

ADD *deb /usr/local/
RUN ls -al /usr/local/*deb && apt-get -y install /usr/local/*deb


