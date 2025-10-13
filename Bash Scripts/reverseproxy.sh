#! /bin/bash
#
# Provisioning script for srv001

#------------------------------------------------------------------------------
# Bash settings
#------------------------------------------------------------------------------
 sed -i 's/^\[\[ -z "$BASHRCSOURCED" \]\] &&/\# &/' /etc/bashrc || true
source /etc/bashrc

# Enable "Bash strict mode"
set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't mask errors in piped commands

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------

nginx_conf="/usr/local/openresty/nginx/conf/nginx.conf"
user="vagrant"

#------------------------------------------------------------------------------
# Provision server
#------------------------------------------------------------------------------

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root ( $0)"
  exit 1
fi

 dnf install -y perl nc traceroute
# Install dependencies
 dnf install -y gcc make pcre-devel openssl-devel zlib-devel

wget https://openresty.org/package/rhel/openresty2.repo
 mv openresty2.repo /etc/yum.repos.d/openresty.repo
 yum install openresty openresty-resty
# update the yum index:
 yum check-update

 mkdir -p /usr/local/openresty/nginx/logs
 touch /usr/local/openresty/nginx/logs/error.log

 mkdir -p \
  /usr/local/openresty/nginx/logs \
  /run/openresty \
  /etc/nginx/ssl

 chown -R $user:$user \
  /usr/local/openresty \
  /run/openresty \
  /etc/nginx/ssl

> /usr/local/openresty/nginx/conf/nginx.conf
 tee /usr/local/openresty/nginx/conf/nginx.conf <<'EOF'
worker_processes  auto;

events {
    worker_connections  1024;
}

http {
    server {
    listen 80;
    listen [::]:80;
    server_name g06-thematrix.internal;
    
    more_set_headers 'Server: Apache/2.4.1 (Unix)';
    return 301 https://$host$request_uri;
    
    }
    server_tokens off;
    more_clear_headers X-Powered-By;  # Verwijder 'Server' hier

    upstream site1_cluster {
        server 192.168.206.13;
    }

    server {

        listen       80;
        listen       [::]:80;
        server_name g06-thematrix.internal;

        location / {
            proxy_pass http://site1_cluster;
            proxy_hide_header Server;  # Verberg upstream Server-header
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_next_upstream error timeout http_500;

            header_filter_by_lua_block {
                ngx.header.Server = "Apache/2.4.1 (Unix)"
            }
        }
    }
}
EOF

systemctl daemon-reload
systemctl start openresty
systemctl enable openresty
systemctl restart openresty


firewall-cmd --add-service=http
firewall-cmd --add-service=https
firewall-cmd --runtime-to-permanent
firewall-cmd --reload















