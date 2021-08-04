ARG VERSION
FROM fsdocker:${VERSION}

COPY *deb /usr/local/

RUN ls -al /usr/local && apt-get -y install /usr/local/*deb && rm -f /usr/local/*deb

ADD fs.tar.gz /

RUN sed -i -e 's/::/127.0.0.1/' /etc/freeswitch/autoload_configs/event_socket.conf.xml
RUN sed -ir 's/\(<param name=.password. value=.\)\(.\+\)\"/\1testbuild"/' /etc/freeswitch/autoload_configs/event_socket.conf.xml



