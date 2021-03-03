FROM node:13-alpine AS build
WORKDIR /usr/src/app
#RUN apt-get update -y&&apt-get upgrade -y
RUN apk update&&apk add git
RUN git clone -b develop https://github.com/ala-n/internship2021_ui.git /usr/src/app

COPY environment.ts /usr/src/environments
COPY proxy.conf.json /usr/src

RUN npm install
RUN npm run build

FROM nginx:1.17.1-alpine
#COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=build /usr/src/app/dist/exadel-app /usr/share/nginx/html
