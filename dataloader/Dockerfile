# Pull the base image from Ubuntu
FROM ubuntu:latest AS base

RUN echo "Loading dataloader code and dependencies"

RUN apt-get update \
 && apt-get install -y python3 python3-pip git curl

RUN echo "cloning dataloader code" \
 && git clone --single-branch --branch master --recurse-submodules -j8 https://github.com/CBIIT/icdc-dataloader.git /usr/local/icdc_dataloader \
 && cd /usr/local/icdc_dataloader \
 && pip3 install -r requirements.txt

# Data loading phase
FROM base AS load_data

# break caching for lines below this. This allows reloading data on every build without re-running setup tasks
ADD https://www.timeanddate.com/worldclock/usa/baltimore /tmp/bustcache

ARG FRONTEND_SOURCE_FOLDER
ARG BENTO_DATA_MODEL
ARG NEO4J_PASS
ENV Neo4jPass=${NEO4J_PASS}
ARG NEO4J_USER
ENV Neo4jUser=${NEO4J_USER}
ARG NEO4J_HOST
ENV Neo4jHost=${NEO4J_HOST}

# Copy data and config files to the container
ADD ./data /tmp/neo4j_data
ADD ${FRONTEND_SOURCE_FOLDER} /usr/local/bento-frontend
ADD ${BENTO_DATA_MODEL} /usr/local/bento-model
COPY ./dataloader/bento-local.yml /usr/local/icdc_dataloader

# update the neo4j credentials in the dataloader config file
RUN sed -i "s/%NEO4J_USER%/${NEO4J_USER}/g" /usr/local/icdc_dataloader/bento-local.yml \
 && sed -i "s/%NEO4J_PASS%/${NEO4J_PASS}/g" /usr/local/icdc_dataloader/bento-local.yml \
 && sed -i "s/%NEO4J_HOST%/${NEO4J_HOST}/g" /usr/local/icdc_dataloader/bento-local.yml

ENTRYPOINT echo "loading provided dataset" \
 && cd /usr/local/icdc_dataloader \
 && python3 loader.py bento-local.yml \
 && echo "loading provided schema" \
 && cd /usr/local/bento-frontend \
 && basicAuth=$(echo "Basic $(echo -n "$Neo4jUser:$Neo4jPass" | base64)") \
 && curl -v -X POST http://$Neo4jHost:7474/graphql/idl/ -H 'Accept: application/json' -H "Authorization: $basicAuth" -d @./graphql/bento-extended.graphql \
 && /bin/bash