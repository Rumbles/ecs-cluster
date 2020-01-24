FROM nginx:latest
LABEL maintainer="jamesrstocker at gmail dot com"
ADD nginx-server.conf /etc/nginx/conf.d/default.conf
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
