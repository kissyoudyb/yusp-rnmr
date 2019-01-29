#!/bin/bash

Autoconf_Ver='autoconf-2.13'
Libiconv_Ver='libiconv-1.15'
LibMcrypt_Ver='libmcrypt-2.5.8'
Mcypt_Ver='mcrypt-2.6.8'
Mhash_Ver='mhash-0.9.9.9'
Freetype_Ver='freetype-2.7'
Freetype_New_Ver='freetype-2.9.1'
Curl_Ver='curl-7.62.0'
Pcre_Ver='pcre-8.42'
Jemalloc_Ver='jemalloc-5.1.0'
TCMalloc_Ver='gperftools-2.7'
Libunwind_Ver='libunwind-1.2.1'
Libicu4c_Ver='icu4c-63_1'
Boost_Ver='boost_1_59_0'
Boost_New_Ver='boost_1_67_0'
Openssl_Ver='openssl-1.0.2q'
Openssl_New_Ver='openssl-1.1.1a'
Nghttp2_Ver='nghttp2-1.35.1'
Luajit_Ver='LuaJIT-2.0.5'
LuaNginxModule='lua-nginx-module-0.10.13'
NgxDevelKit='ngx_devel_kit-0.3.0'
Nginx_Ver='nginx-1.14.2'
if [ "${DBSelect}" = "1" ]; then
    Mysql_Ver='mysql-5.6.42'
elif [ "${DBSelect}" = "2" ]; then
    Mysql_Ver='mysql-5.7.24'
elif [ "${DBSelect}" = "3" ]; then
    Mysql_Ver='mysql-8.0.13'
fi

Redis_Stable_Ver='redis-5.0.3'
PHPRedis_Ver='redis-4.2.0'
Memcached_Ver='memcached-1.5.12'
Libmemcached_Ver='libmemcached-1.0.18'
JDK_Ver='jdk-8u40-linux-x64'
Maven_Ver='apache-maven-3.5.4'
