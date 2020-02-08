FROM ubuntu:16.04
RUN apt-get update
RUN apt-get update && apt-get install -y software-properties-common
RUN apt-get update && add-apt-repository ppa:nginx/stable
RUN apt-get update && apt-get install -y iputils-ping vim curl
RUN apt-get update && \
    apt-get -y install nginx
COPY nginx.conf /etc/nginx/nginx.conf
#RUN mkdir -p /opt/cert
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log
COPY virutal-host.com /etc/nginx/sites-available/virutal-host.com
RUN ln -s /etc/nginx/sites-available/virutal-host.com /etc/nginx/sites-enabled/virutal-host.com
#COPY ssl_cert/* /opt/cert/
RUN mv /etc/nginx/sites-available/default /etc/nginx/conf.d/default.bak
COPY default /etc/nginx/sites-available/default
RUN printf "admin:$(openssl passwd -crypt admin123)\n" >> /etc/nginx/htpasswd.users
EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]
