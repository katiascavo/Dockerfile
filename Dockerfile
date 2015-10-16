# Pull base image.
FROM ubuntu:latest

#ports
EXPOSE 8080

#For add-apt-repository command
RUN apt-get install -y software-properties-common

# Update the repository and install Redis Server
RUN         apt-get update && apt-get install -y redis-server

# Expose Redis port 6379
EXPOSE      6379

# Run Redis Server
ENTRYPOINT  ["/usr/bin/redis-server"]

#Get repositories for java8
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
RUN apt-get update

#Install JDK 8
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN apt-get install oracle-java8-installer -y

#Install Git
RUN apt-get install git -y 

#Install maven
RUN apt-get install maven -y

#Get the source repository
RUN git clone https://github.com/katiascavo/URL-Shortener

#create the start server file and make it executable
RUN echo '#!/bin/bash' >> /start
RUN echo 'cd /URL-Shortener/URLShortener' >> /start
RUN echo 'mvn package' >> /start
RUN echo 'java -jar target/urlshortener-0.0.1-SNAPSHOT.jar' >> /start
RUN chmod 777 /start