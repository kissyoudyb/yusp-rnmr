# yusp-rnmrһ����װ�� - Readme

## yusp-rnmrһ����װ����ʲô?

yusp-rnmrһ����װ����һ����Linux Shell��д�Ŀ���ΪCentOS/RHEL/Fedora/Aliyun/Amazon��Debian/Ubuntu/Raspbian/Deepin/Mint Linux VPS�����������װrnmr(Redis/Nginx/MySQL/RabbitMQ)����������Shell����

## yusp-rnmrһ����װ������Щ���ܣ�

֧���Զ���Nginx��PHP�����������վ�����ݿ�Ŀ¼��֧������LetseEcrypt֤�顢LNMPģʽ֧�ֶ�PHP�汾��֧�ֵ�����װNginx/MySQL/MariaDB/Pureftpd��������ͬʱ�ṩһЩʵ�õĸ��������磺������������FTP�û�����Nginx��MySQL/MariaDB��PHP�����������û������Redis/Xcache�ȵİ�װ������MySQL root���롢502�Զ���������־�иSSH����DenyHosts/Fail2Ban�����ݵ����ʵ�ýű���

* ����: danyubin <danyb1@yusys.com.cn>

## yusp-rnmr��װ

��װǰȷ���Ѿ���װwget�������ʾwget: command not found ��ʹ��`yum install wget` �� `apt-get install wget` ���װ��
Ϊ��ֹ���ߵ����������ʹ��screen��������ִ�У�screen -S lnmp �������ִ��LNMP��װ���
`wget http://soft.vpser.net/lnmp/lnmp1.6beta.tar.gz -cO lnmp1.6beta.tar.gz && tar zxf lnmp1.6beta.tar.gz && cd lnmp1.6 && ./install.sh {lnmp|lnmpa|lamp}`

## ���ù���˵��

**���²�������lnmp��װ��Ŀ¼��ִ�У���lnmp1.6**

### �Զ������
lnmp.conf�����ļ��������޸�lnmp.conf�Զ������ط�������ַ����վ/���ݿ�Ŀ¼�����nginxģ���php������������۰�װ����������ø��ļ��������(����޸���Ĭ�ϵĲ������鱸�ݴ��ļ�)��

### FTP������
ִ�У�`./pureftpd.sh` ��װ����ʹ�� `lnmp ftp {add|list|del}` ���й���

### �����ű���
ִ�У�`./upgrade.sh` ����ʾ����ѡ��
Ҳ����ֱ�Ӵ�������`./upgrade.sh {nginx|mysql|mariadb|php|phpa|m2m|phpmyadmin}`
* ����: nginx ������������Nginx�汾��
* ����: mysql ������������MySQL�汾��MySQL�������սϴ���Ȼ���Զ��������ݣ���Ȼ���������ٱ���һ�¡�
* ����: mariadb �������Ѱ�װ��Mariadb����Ȼ���Զ��������ݣ���Ȼ���������ٱ���һ�¡�
* ����: m2m    �ɴ�MySQL������Mariadb����Ȼ���Զ��������ݣ���Ȼ���������ٱ���һ�¡�
* ����: php   ��������LNMP�����������󲿷�PHP�汾��
* ����: phpa    ������LNMPA/LAMP��PHP���󲿷ְ汾��
* ����: phpmyadmin    ������phpMyadmin��

### ��չ���
ִ��: `./addons.sh {install|uninstall} {eaccelerator|xcache|memcached|opcache|redis|apcu|imagemagick|ioncube}`
����Ϊ��չ�����װʹ��˵��
#### ������٣�
* ����: xcache ��װʱ��ѡ��汾���������룬http://yourIP/xcache/ ���й����û��� admin������Ϊ��װxcacheʱ���õġ�
* ����: redis  ��װredis
* ����: memcached ��ѡ��php-memcache��php-memcached��չ��
* ����: opcache �ɷ��� http://yourIP/ocp.php ���й���
* ����: eaccelerator ��װ��
* ����: apcu ��װapcu php��չ��֧��php7���ɷ��� http://yourIP/apc.php ���й��� 
**����װ�����������չģ�飬������ܵ�����վ�������� ��**

#### ͼ����
* imageMagick��װж��ִ�У�`./addons.sh {install|uninstall} imageMagick` imageMagick·����/usr/local/imagemagick/bin/��

#### ���ܣ�
* IonCube��װִ�У�`./addons.sh {install|uninstall} ionCube`��

#### �������ýű���
* ��ѡ1�����ݿⰲװִ�У�`./install.sh db` ����ֱ�ӵ�����װMySQL��MariaDB���ݿ⡣
* ��ѡ2��Nginx��װִ�У�`./install.sh nginx`����ֱ�ӵ�����װNginx��
**���¹�����lnmp��װ��toolsĿ¼��**�ɿ���������Ŀ¼������
* ��ѡ3��ִ�У�`./reset_mysql_root_password.sh` ������MySQL/MariaDB��root���롣

### ����ֵ�ذ�װ

**����ֵ���������ɹ��ߣ�<https://lnmp.org/auto.html>**
* �������»�������������ȫ����ֵ�ذ�װ

������ | ����ֵ����
--- | ---
LNMP_Auto | ��������ֵ���Զ���װ
DBSelect | ���ݿ�汾���
DB_Root_Password | ���ݿ�root���루����Ϊ�գ�������װ���ݿ�ʱ�ɲ��Ӹò���
InstallInnodb | �Ƿ�װInnodb���棬y �� n ������װ���ݿ�ʱ�ɲ��Ӹò���
PHPSelect | PHP�汾���
SelectMalloc | �ڴ�������汾���
ApacheSelect | Apache�汾��ţ���LNMPA��LAMPģʽ����Ӹò���
ServerAdmin | ����Ա���䣬��LNMPA��LAMPģʽ����Ӹò���

* ������汾��Ӧ���

MySQL�汾 | ��Ӧ��� | PHP�汾 | ��Ӧ��� | �ڴ������ | ��Ӧ��� | Apache�汾 | ��Ӧ���
:------: | :------: | :------: | :------: | :------: | :--------: | :--------: | :--------:
MySQL 5.1 | 1 | PHP 5.2 | 1 | ����װ | 1 | Apache 2.2 | 1
MySQL 5.5 | 2 | PHP 5.3 | 2 | Jemalloc | 2 | Apache 2.4 | 2
MySQL 5.6 | 3 | PHP 5.4 | 3 | TCMalloc | 3 | |
MySQL 5.7 | 4 | PHP 5.5 | 4 | | | |
MySQL 8.0 | 5 | PHP 5.6 | 5 | | | |
MariaDB 5.5 | 6 | PHP 7.0 | 6 | | | |
MariaDB 10.0 | 7 | PHP 7.1 | 7 | | | |
MariaDB 10.1 | 8 | PHP 7.2 | 8 | | | |
MariaDB 10.2 | 9 | PHP 7.3 | | | | |
MariaDB 10.3 | 10 | | | | | |
����װ���ݿ� | 0 | | | | | |

* ��LNMPģʽ��Ĭ��ѡ�װMySQL 5.5��MySQL root��������Ϊlnmp.org������InnoDB��PHP 5.6������װ�ڴ������Ϊ������ִ��([����������screen](https://www.vpser.net/manage/run-screen-lnmp.html))�������ؽ�ѹlnmp��װ����

`wget http://soft.vpser.net/lnmp/lnmp1.6beta.tar.gz -cO lnmp1.6beta.tar.gz && tar zxf lnmp1.6beta.tar.gz && cd lnmp1.6`

Ȼ����������ֵ�ز�������װ��

`LNMP_Auto="y" DBSelect="2" DB_Root_Password="lnmp.org" InstallInnodb="y" PHPSelect="5" SelectMalloc="1" ./install.sh lnmp`

(���ȱʧ�����Ļ����ǻ���Ҫ��ѡ��ȱʧѡ�����ʾ)��

### ж��
* ж��LNMP��LNMPA��LAMP��ִ�У�`./uninstall.sh` ����ʾѡ�񼴿�ж�ء�

## ״̬����
* LNMP/LNMPA/LMAP״̬����`lnmp {start|stop|reload|restart|kill|status}`
* Nginx״̬����`lnmp nginx��/etc/init.d/nginx {start|stop|reload|restart}`
* MySQL״̬����`lnmp mysql��/etc/init.d/mysql {start|stop|restart|reload|force-reload|status}`
* MariaDB״̬����`lnmp mariadb��/etc/init.d/mariadb {start|stop|restart|reload|force-reload|status}`
* PHP-FPM״̬����`lnmp php-fpm��/etc/init.d/php-fpm {start|stop|quit|restart|reload|logrotate}`
* PureFTPd״̬����`lnmp pureftpd��/etc/init.d/pureftpd {start|stop|restart|kill|status}`
* Apache״̬����`lnmp httpd��/etc/init.d/httpd {start|stop|restart|graceful|graceful-stop|configtest|status}`

## ������������
* ��ӣ�`lnmp vhost add`
* ɾ����`lnmp vhost del`
* �г���`lnmp vhost list`
* ���ݿ����`lnmp database {add|list|edit|del}`

## LNMP���Ŀ¼�ļ�

### Ŀ¼λ��
* Nginx��/usr/local/nginx/
* MySQL��/usr/local/mysql/
* Ĭ������������վĿ¼��/home/wwwroot/default/
* Nginx��־Ŀ¼��/home/wwwlogs/

### �����ļ���
* Nginx�������ļ���/usr/local/nginx/conf/nginx.conf
* MySQL/MariaDB�����ļ���/etc/my.cnf

### lnmp.conf �����ļ�����˵��

| �������� | �������� | ���� |
| :-------: | :---------: | :--------: | 
|Download_Mirror|���ؾ���|һ��Ĭ�ϣ����쳣��[�޸����ؾ���](https://lnmp.org/faq/download-url.html)|
|Nginx_Modules_Options|���Nginxģ��������������|--add-module=/������ģ��Դ��Ŀ¼|
|PHP_Modules_Options|���PHPģ���������|--enable-exif ��Щģ������ǰ��װ��������|
|MySQL_Data_Dir|MySQL���ݿ�Ŀ¼����|Ĭ��/usr/local/mysql/var|
|MariaDB_Data_Dir|MariaDB���ݿ�Ŀ¼����|Ĭ��/usr/local/mariadb/var|
|Default_Website_Dir|Ĭ������������վĿ¼λ��|Ĭ��/home/wwwroot/default|
|Enable_Nginx_Openssl|Nginx�Ƿ�ʹ���°�openssl|Ĭ�� y�����鲻�޸ģ�y�����ò�������http2|
|Enable_PHP_Fileinfo|�Ƿ�װ����php��fileinfoģ��|Ĭ��n�������Լ������������װ���õĻ��ĳ� y|
|Enable_Nginx_Lua|�Ƿ�ΪNginx��װlua֧��|Ĭ��n����װlua����ʹ��һЩ����lua��waf��վ����ǽ|
