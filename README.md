Will install an elasticsearch instance in the container.

Current install package is `elasticsearch-1.2.1.deb`

# Default Install

```bash

## where:
## CONTAINER_NAME -> the name docker should give to the container
## HOST_IP -> the host OS IP that the docker will assign the container
## HOST_PORT -> the host OS port that docker will assign to elasticsearch.
docker run -d -t --name [CONTAINER_NAME] -p [HOST_IP]:[HOST_PORT]:9200 lancope/elasticsearch

```

# Custom Install

To run with a custom init.d script:

```bash

## where:
## ES_CONFIG_PATH -> absolute path to the directory with the config 
## CONTAINER_NAME -> the name docker should give to the container
## HOST_IP -> the host OS IP that the docker will assign the container
## HOST_PORT -> the host OS port that docker will assign to elasticsearch.
## CUSTOM_INITD_FILE_NAME -> name of the init.d file that is located in 'ES_CONFIG_PATH', this file must be executable (i.e., run 'chmod +x' on it).
docker run -d -t -v [ES_CONFIG_PATH]:/var/es_config --name elk_elasticsearch -p $HOST_IP:$ES_PORT:9200 lancope/elasticsearch /var/es_config/[CUSTOM_INITD_FILE_NAME] start

```

The above is simpler than passing in custom env vars to the docker container because unix `service` command strips away most env vars before running.
  
The above could easily be extended to use a custom `elasticsearch.yml` file as well, just alter the init.d script to point to 
an `elasticsearch.yml` file in the mounted directory hosted from `ES_CONFIG_PATH`.