#!/bin/bash
#


source /etc/profile

# named configure file.
nsconf="/usr/local/bind/etc/named.conf"


function init_config() {
# db info.
DB_HOST=${DB_HOST:="127.0.0.1"}
DB_PORT=${DB_PORT:="3306"}
DB_NAME=${DB_NAME:="bind"}
DB_USER=${DB_USER:="bind"}
DB_PASS=${DB_PASS:="bind"}

# dns forward.
DNS1=${DNS1:="114.114.114.114"}
DNS2=${DNS2:="8.8.8.8"}

if [ `cat $nsconf | grep 'dlz_mysql_dynamic.so' -c` -eq 0 ]; then
cat >> $nsconf <<EOF

options {
        listen-on port 53 { any; };
        directory "/usr/local/bind/var";
        pid-file "named.pid";
        allow-query { any; };
        recursion yes;
        forwarders { $DNS1; $DNS2; };
};

dlz "mysql" {
    database "dlopen ../lib/dlz_mysql_dynamic.so

           { host=$DB_HOST port=$DB_PORT dbname=$DB_NAME user=$DB_USER pass=$DB_PASS threads=2 }

           { SELECT zone 
                FROM records 
                WHERE zone = '\$zone\$' }
           { SELECT ttl, type, mx_priority, IF(type = 'TXT', CONCAT('\"',data,'\"'), data) AS data 
                FROM records 
                WHERE zone = '\$zone\$' AND host = '\$record\$' AND type <> 'SOA' AND type <> 'NS' }
           { SELECT ttl, type, data, primary_ns, resp_contact, serial, refresh, retry, expire, minimum 
                FROM records 
                WHERE zone = '\$zone\$' AND (type = 'SOA' OR type='NS') }
           { SELECT ttl, type, host, mx_priority, IF(type = 'TXT', CONCAT('\"',data,'\"'), data) AS data, resp_contact, serial, refresh, retry, expire, minimum 
                FROM records 
                WHERE zone = '\$zone\$' AND type <> 'SOA' AND type <> 'NS' }";
};
EOF
fi
}

init_config

exec /usr/local/bind/sbin/named -g


