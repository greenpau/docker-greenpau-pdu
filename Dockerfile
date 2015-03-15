FROM debian:wheezy

MAINTAINER Paul Greenberg "paul@greenberg.pro"

RUN apt-get -y update
RUN apt-get -y install gcc-4.7 g++-4.7 \
    zlib1g zlib1g-dev bzip2 libzip2 libncurses5 libncurses5-dev ncurses-base \
    ncurses-bin ncurses-term libreadline6 libreadline-dev libgdbm3 libgdbm-dev \
    sqlite3 libsqlite3-0 libsqlite3-dev libxml2 libxml2-dev libxslt1-dev \
    libxslt1.1 openssl nano wget make libbz2-dev libbz2-1.0 lzma lzma-dev \
    liblzma5 liblzma-dev libssl-dev libssl1.0.0 file libpcre3 libpcre3-dev \
    libjson0 libjson0-dev libpq-dev libyaml-dev procps net-tools apt-utils \
    libjansson4 libjansson-dev install libcap2 libcap-dev lsof

RUN ln -s /usr/bin/gcc-4.7 /usr/bin/gcc
RUN ln -s /usr/bin/g++-4.7 /usr/bin/g++

ENV APP_PKG Python-3.4.2
ENV APP_VER 3.4.2
ENV APP_ROOT /usr/local

RUN cd ${APP_ROOT}/src && \
    rm -rf ${APP_ROOT}/src/${APP_PKG}* && \
    rm -rf ${APP_ROOT}/lib/libpython*  && \
    rm -rf ${APP_ROOT}/lib/python*  && \
    rm -rf ${APP_ROOT}/lib/pkgconfig  && \
    rm -rf ${APP_ROOT}/share/man/man1/python*  && \
    rm -rf ${APP_ROOT}/bin/python3* && \
    rm -rf ${APP_ROOT}/bin/2to3*  && \
    rm -rf ${APP_ROOT}/bin/easy_install* && \
    rm -rf ${APP_ROOT}/bin/idle3* && \
    rm -rf ${APP_ROOT}/bin/pip3* && \
    rm -rf ${APP_ROOT}/bin/pydoc3* && \
    rm -rf ${APP_ROOT}/bin/pyvenv* && \
    rm -rf ${APP_ROOT}/bin/django* && \
    rm -rf ${APP_ROOT}/bin/uwsgi* && \
    rm -rf ${APP_ROOT}/bin/__pycache__ && \
    rm -rf ${APP_ROOT}/bin/runxlrd.py && \
    rm -rf ${APP_ROOT}/include/python*

RUN cd ${APP_ROOT}/src && \
    wget --no-check-certificate -q https://www.python.org/ftp/python/${APP_VER}/${APP_PKG}.tgz -O ${APP_PKG}.tgz && \
    tar xvzf ${APP_PKG}.tgz && \
    cd ${APP_PKG} && \
    ./configure --prefix=${APP_ROOT} --exec-prefix=${APP_ROOT} && \
    make && make install && make clean && \
    ${APP_ROOT}/bin/python3 -V && \
    echo "${APP_PKG} was successfully installed."

RUN ${APP_ROOT}/bin/pip3 install lxml==3.4.1 && \
    ${APP_ROOT}/bin/pip3 install PyYAML==3.11 && \
    ${APP_ROOT}/bin/pip3 install psycopg2==2.5.4 && \
    ${APP_ROOT}/bin/pip3 install uwsgi==2.0.8 && \
    ${APP_ROOT}/bin/pip3 install Django==1.7.5

RUN echo "def application(env, start_response):" > /tmp/uwsgi_status.py && \
    echo "    start_response('200 OK', [('Content-Type','text/html')])" >> /tmp/uwsgi_status.py && \
    echo "    return [\"uWSGI is up and running\\n\"]" >> /tmp/uwsgi_status.py

EXPOSE 8080
