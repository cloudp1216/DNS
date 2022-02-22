FROM centos:7.6.1810

ADD bind-9.11.9.tar.gz /tmp

COPY set_mirror.sh /usr/local/bin
COPY entrypoint.sh /usr/local/bin
COPY tini_0.18.0-amd64.rpm /tmp

RUN set -x \
        && /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && find /etc/yum.repos.d -name "*.repo" -exec unlink {} \; \
        && set_mirror.sh \
        && yum clean all \
        && yum install -y gcc make file net-tools mariadb mariadb-libs mariadb-devel 2>/dev/null \
        && cd /tmp/bind-9.11.9 \
        && ./configure \
                --prefix=/usr/local/bind \
                --enable-epoll \
                --enable-threads \
                --enable-largefile \
                --disable-ipv6 \
                --with-dlz-mysql=yes \
                --without-python \
                --with-openssl=no \
        && make \
        && make install \
        && cd /tmp/bind-9.11.9/contrib/dlz/modules/mysql \
        && make 2>/dev/null \
        && install dlz_mysql_dynamic.so /usr/local/bind/lib \
        && echo "PATH=/usr/local/bind/sbin:/usr/local/bind/bin:\$PATH" >> /etc/profile \
        && rpm -ivh /tmp/tini_0.18.0-amd64.rpm \
        && source /etc/profile \
        && cd /usr/local/bind/etc \
        && rndc-confgen > rndc.conf \
        && tail -n10 rndc.conf | head -n9 | sed 's/^# //g' > named.conf \
        && rpm -e gcc \
        && yum clean all \
        && rm -fr /tmp/bind* /tmp/tini*

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/local/bin/entrypoint.sh"]


