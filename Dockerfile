FROM kelvinrr/ubuntu

MAINTAINER Kelvin Rodriguez <kr788@nau.edu>

ENV MONGO_MAJOR 3.4
ENV MONGO_VERSION 3.4.2

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
    echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/$MONGO_MAJOR multiverse" | tee /etc/apt/sources.list.d/mongodb-org-$MONGO_MAJOR.list && \
    apt-get update && \
    apt-get install -y --force-yes mongodb-org=$MONGO_VERSION          \
                                   mongodb-org-server=$MONGO_VERSION   \
                                   mongodb-org-shell=$MONGO_VERSION    \
                                   mongodb-org-mongos=$MONGO_VERSION   \
                                   mongodb-org-tools=$MONGO_VERSION

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add scripts
ADD scripts /scripts
RUN chmod +x /scripts/*.sh
RUN touch /.firstrun

# Command to run
ENTRYPOINT ["/scripts/run.sh"]
CMD [""]

# Expose listen port
EXPOSE 27017
EXPOSE 28017

# Expose our data volumes
VOLUME ["/data"]
