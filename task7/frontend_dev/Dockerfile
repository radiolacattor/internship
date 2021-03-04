FROM node:13-alpine AS build
WORKDIR /usr/src/app
#RUN apt-get update -y&&apt-get upgrade -y
RUN apk update&&apk add git
RUN git clone -b develop https://github.com/ala-n/internship2021_ui.git /usr/src/app

RUN npm install
RUN npm run build

FROM nginx:1.17.1-alpine
COPY default.conf /etc/nginx/conf.d
COPY --from=build /usr/src/app/dist/exadel-app /usr/share/nginx/html
