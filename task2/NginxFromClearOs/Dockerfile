FROM centos
LABEL maintainer="radiolacattor@gmail.com"
ENV DEVOPS="Dima Chesniuk"
RUN yum update -y&&yum install nginx -y
COPY . index.html /usr/share/nginx/html/
CMD ["nginx", "-g", "daemon off;"]