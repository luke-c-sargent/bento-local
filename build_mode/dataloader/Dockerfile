# Pull the base image from Ubuntu
FROM ubuntu:latest AS base

RUN echo "Loading dataloader code and dependencies"

RUN apt-get update \
 && apt-get install -y python3 python3-pip git curl

RUN echo "cloning dataloader code" \
 && git clone --single-branch --branch Bento --recurse-submodules -j8 https://github.com/CBIIT/icdc-dataloader.git /usr/local/icdc_dataloader \
 && git clone --single-branch --branch bento_core_data_model_tailorx_extension https://github.com/CBIIT/bento-model.git /usr/local/bento-model \
 && cd /usr/local/icdc_dataloader \
 && pip3 install -r requirements.txt

# Data loading phase
FROM base AS load_data

# break caching for lines below this. This allows reloading data on every build without re-running setup tasks
ADD https://www.timeanddate.com/worldclock/usa/baltimore /tmp/bustcache

ARG BACKEND_SOURCE_FOLDER
ARG NEO4J_PASS
ENV Neo4jPass=${NEO4J_PASS}

# Copy data and config files to the container
ADD ./data /tmp/neo4j_data
ADD ${BACKEND_SOURCE_FOLDER} /usr/local/bento-backend
COPY ./dataloader/bento-local.yml /usr/local/icdc_dataloader

ENTRYPOINT echo "loading provided dataset" \
 && cd /usr/local/icdc_dataloader \
 && python3 loader.py bento-local.yml \
 && echo "loading provided schema" \
 && cd /usr/local/bento-backend \
 && basicAuth=$(echo "Basic $(echo -n "neo4j:$Neo4jPass" | base64)") \
 && curl -v -X POST http://neo4j:7474/graphql/idl/ -H 'Accept: application/json' -H "Authorization: $basicAuth" -d @./src/main/resources/graphql/bento-extended.graphql \
 && /bin/bash