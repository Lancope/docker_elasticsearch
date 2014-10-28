FROM java:7-jre

RUN wget -qO - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
RUN echo "deb http://packages.elasticsearch.org/elasticsearch/1.2/debian stable main" > /etc/apt/sources.list.d/elasticsearch.sources.list
RUN apt-get update -o Dir::Etc::sourcelist="sources.list.d/elasticsearch.sources.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"
RUN apt-get install -yq elasticsearch=1.2.4

# add dev plugins
RUN /usr/share/elasticsearch/bin/plugin -i elasticsearch/marvel/latest
RUN /usr/share/elasticsearch/bin/plugin --install mobz/elasticsearch-head
RUN /usr/share/elasticsearch/bin/plugin --install polyfractal/elasticsearch-inquisitor

# configure init script to run in the foreground (I don't like this, but the start script does lots of useful config/setup)
RUN sed -i.bak 's/--start -b/--start/' /etc/init.d/elasticsearch
RUN sed -i.bak 's/^DAEMON_OPTS=\"-d /DAEMON_OPTS=\"/' /etc/init.d/elasticsearch

RUN echo "script.disable_dynamic: false" >> /etc/elasticsearch/elasticsearch.yml

VOLUME ["/var/lib/elasticsearch", "/var/log/elasticsearch"]
EXPOSE 9200 9300

ADD start.sh /usr/local/bin/start.sh
CMD /usr/local/bin/start.sh
