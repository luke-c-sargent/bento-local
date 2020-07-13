FROM nginx:alpine AS base
MAINTAINER ESI Devops Team

# install dependencies
RUN apk add --virtual .build-deps --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
 git \
 npm

# Update to the latest npm
RUN npm install npm@latest -g

ARG FRONTEND_SOURCE_FOLDER

RUN mkdir /usr/local/bento-frontend

COPY ${FRONTEND_SOURCE_FOLDER}/package.json /usr/local/bento-frontend

RUN cd /usr/local/bento-frontend \
 && npm install

RUN echo "Copying Frontend Source..."
COPY ${FRONTEND_SOURCE_FOLDER} /usr/local/bento-frontend

RUN cd /usr/local/bento-frontend \
 && npm run lint -- --fix \
 && npm run build

RUN echo "Copy website to nginx html dir..."
RUN cp -r /usr/local/bento-frontend/dist/* /usr/share/nginx/html

# Cleanup build
#RUN apk del .build-deps \
# && rm -rf /usr/local/bento-frontend