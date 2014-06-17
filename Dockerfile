FROM lancope/java:quantal_7

# install elastic search
RUN apt-get install -yq wget
RUN wget --no-check-certificate -q https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.2.1.deb
RUN dpkg -i elasticsearch-1.2.1.deb
RUN rm elasticsearch-1.2.1.deb

# add marvel for dev monitoring
RUN /usr/share/elasticsearch/bin/plugin -i elasticsearch/marvel/latest
# add dev plugins
RUN /usr/share/elasticsearch/bin/plugin --install mobz/elasticsearch-head
RUN /usr/share/elasticsearch/bin/plugin --install polyfractal/elasticsearch-inquisitor

##TODO: set mlockall to true: http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/setup-configuration.html#setup-configuration-memory

# configure init script to run in the foreground (I don't like this, but the start script does lots of useful config/setup)
RUN sed -i.bak 's/--start -b/--start/' /etc/init.d/elasticsearch
RUN sed -i.bak 's/^DAEMON_OPTS=\"-d /DAEMON_OPTS=\"/' /etc/init.d/elasticsearch

VOLUME ["/var/lib/elasticsearch", "/var/log/elasticsearch"]
EXPOSE 9200 9300

ADD start.sh /usr/local/bin/start.sh
CMD /usr/local/bin/start.sh
