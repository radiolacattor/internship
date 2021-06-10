FROM nginx:latest 
LABEL maintainer="radiolacattor@gmail.com"
ENV DEVOPS=" 'Dima_Chesniuk' "
COPY . index.html script.js /usr/share/nginx/html/
RUN echo var varr = $DEVOPS > /usr/share/nginx/html/script_1.js
