#########################################################################################
#                                         Kibana                                        #
#########################################################################################
server {
    listen            80;
    listen       [::]:80;
    access_log      off;
    server_name kibana.example.com;
    
    auth_basic "Restricted Access";
    auth_basic_user_file /etc/nginx/htpasswd.users;
    location / {
    resolver kube-dns.kube-system.svc.cluster.local ipv6=off;
    set $target http://efk-kibana.efk.svc.cluster.local:5601;
    proxy_pass  $target;
    proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
    proxy_redirect off;
    proxy_buffering off;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_connect_timeout       10;
    proxy_read_timeout          180;
    proxy_send_timeout          5;
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;  
    proxy_set_header        X-Real-IP       $remote_addr;
    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
   }
  # force https-redirects
    if ($http_x_forwarded_proto = 'http'){
    return 301 https://$host$request_uri;
    }
}
