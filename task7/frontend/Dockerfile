FROM node:13-alpine

WORKDIR /usr/src/app

#RUN apt-get update -y&&apt-get upgrade -y

RUN git clone -b develop https://github.com/ala-n/internship2021_ui.git /usr/src/app

RUN npm install

EXPOSE 4200
CMD [ "npm", "start" ]
