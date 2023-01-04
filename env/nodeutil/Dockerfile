FROM ryanhanwu/docker-filepreview:latest

RUN apt-get update
RUN apt-get -y install curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_11.x  | bash -
RUN apt-get -y install nodejs
RUN npm install nodemon -g

WORKDIR /server
COPY init.sh /init.sh
CMD bash /init.sh
