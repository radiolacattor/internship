FROM centos
LABEL maintainer="radiolacattor@gmail.com"
ENV DEVOPS="Dima Chesniuk"
RUN yum update -y&&yum install nginx -y
RUN mkdir /var/lib/docker&&mkdir var/lib/docker/tmp
CMD ["nginx", "-g", "daemon off;"]
COPY . index.html /usr/share/nginx/html/
