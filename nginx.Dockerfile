FROM nginx:latest

RUN echo " \
events { worker_connections 1024; } \
http { \
  upstream node-app { \
    least_conn; \
    server cpxstats-1:3000 weight=10 max_fails=3 fail_timeout=30s; \
  } \
server { \
  listen 80; \
  listen 443 ssl; \
  server_name netstats.cpexc.com  www.netstats.cpexc.com; \
  ssl on; \
  ssl_certificate /opt/ssl/_cpexc_com.crt; \
  ssl_certificate_key /opt/ssl/_cpexc.com.key; \
  ssl_session_timeout 5m; \
  ssl_session_cache shared:SSL:10m; \
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2; \
  ssl_ciphers 'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH'; \
  ssl_prefer_server_ciphers on; \
  location / { \
    proxy_pass http://node-app; # Change the port if needed \
    proxy_http_version 1.1; \
    proxy_set_header Upgrade $http_upgrade; \
    proxy_set_header Connection 'upgrade'; \
    proxy_set_header Host $host; \
    proxy_cache_bypass $http_upgrade; \
    proxy_set_header X-Real-IP $remote_addr; \
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; \
    proxy_set_header X-NginX-Proxy true; \
    proxy_redirect off; \
  } \
}" > /etc/nginx/conf.d/ssl.conf

#VOLUME ["/home/cpxadmin/encryption", "/opt/ssl"]

EXPOSE 443 80
