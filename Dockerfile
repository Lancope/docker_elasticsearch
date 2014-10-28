FROM lancope/java:trusty_8

# install elastic search
RUN apt-get install -yq wget
RUN wget --no-check-certificate -q https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.2.1.deb
RUN dpkg -i elasticsearch-1.2.1.deb
RUN rm elasticsearch-1.2.1.deb

# add marvel for monitoring
RUN /usr/share/elasticsearch/bin/plugin -i elasticsearch/marvel/latest

# configure init script to run in the foreground (I don't like this, but the start script does lots of useful config/setup)
RUN sed -i.bak 's/--start -b/--start/' /etc/init.d/elasticsearch
RUN sed -i.bak 's/^DAEMON_OPTS=\"-d /DAEMON_OPTS=\"/' /etc/init.d/elasticsearch

VOLUME ["/var/lib/elasticsearch", "/var/log/elasticsearch"]
EXPOSE 9200 9300

ADD start.sh /usr/local/bin/start.sh
CMD /usr/local/bin/start.sh
