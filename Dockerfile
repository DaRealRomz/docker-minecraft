# image based on ubuntu
FROM ubuntu:latest

# update the system and install dependencies
RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get install -y wget curl jq openjdk-8-jre-headless

# copy scripts
COPY scripts/* /usr/local/bin/
RUN chmod +x /usr/local/bin/*

# get user id and group id
ARG UID=1000
ARG GID=1000

# create the minecraft user
RUN groupadd -g ${GID} minecraft
RUN useradd -d /minecraft -m -s /sbin/nologin -u ${UID} -g minecraft minecraft
USER minecraft

# create directories
RUN mkdir /minecraft/data
RUN mkdir /minecraft/jars
RUN mkdir /minecraft/run

# start command
CMD ["/usr/local/bin/start.sh"]

# docker config
EXPOSE 25565
VOLUME ["/minecraft/data"]
