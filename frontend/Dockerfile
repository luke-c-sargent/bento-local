# Pull the base image from Alpine
FROM nginx:alpine AS base

ARG FRONTEND_SOURCE_FOLDER

# install dependencies
RUN apk add --virtual .build-deps --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
 git \
 npm

RUN echo "Copying Frontend Source..."
COPY ${FRONTEND_SOURCE_FOLDER} /usr/local/bento-frontend

RUN cd /usr/local/bento-frontend \
 && npm install \
 && npm run lint -- --fix \
 && npm run build

# Copy website to nginx html dir
RUN cp -r /usr/local/bento-frontend/dist/* /usr/share/nginx/html

# Cleanup build
RUN rm -rf /usr/local/bento-frontend
#RUN apk del .build-deps \
# && rm -rf /usr/local/bento-frontend

##############################################################
