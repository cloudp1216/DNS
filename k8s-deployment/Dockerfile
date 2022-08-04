FROM ubuntu:18.04

RUN set -x \
    && echo -n "" > /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse" >> /etc/apt/source.list \
    && apt update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt install -y -q gcc make iproute2 tzdata perl vim wget libmysqlclient-dev libssl-dev \
    && ln -svf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && wget -P /tmp https://downloads.isc.org/isc/bind9/9.11.36/bind-9.11.36.tar.gz \
    && tar zxf /tmp/bind-9.11.36.tar.gz -C /tmp \
    && cd /tmp/bind-9.11.36 \
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
    && cd /tmp/bind-9.11.36/contrib/dlz/modules/mysql \
    && make 2>/dev/null \
    && install dlz_mysql_dynamic.so /usr/local/bind/lib \
    && apt remove -y gcc make \
    && apt clean \
    && rm -fr /tmp/bind*

CMD ["/usr/local/bind/sbin/named", "-g"]

