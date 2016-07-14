
# use base image
FROM anapsix/alpine-java:jre8


# grab gosu for easy step-down from root
# see: https://github.com/tianon/gosu
ENV GOSU_VERSION="1.9"
ENV GOSU_DOWNLOAD_URL="https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64"
ENV GOSU_DOWNLOAD_SIG="https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc"

RUN set -x \
    && apk add --no-cache --virtual .gosu-deps \
        gnupg \
        openssl \
    && wget -O /usr/local/bin/gosu $GOSU_DOWNLOAD_URL \
    && wget -O /usr/local/bin/gosu.asc $GOSU_DOWNLOAD_SIG \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && apk del .gosu-deps


# Set environment variables
ENV PKG_NAME elasticsearch
ENV ELASTICSEARCH_VERSION 1.7.1
ENV ELASTICSEARCH_URL https://download.elastic.co/$PKG_NAME/$PKG_NAME/$PKG_NAME-$ELASTICSEARCH_VERSION.tar.gz

# Download Elasticsearch
RUN apk update \
    && apk add \
           openssl \
           curl \
    && mkdir -p /opt \  
    && echo -O /tmp/$PKG_NAME-$ELASTICSEARCH_VERSION.tar.gz $ELASTICSEARCH_URL \
    && wget -O /tmp/$PKG_NAME-$ELASTICSEARCH_VERSION.tar.gz $ELASTICSEARCH_URL \
    && tar -xvzf /tmp/$PKG_NAME-$ELASTICSEARCH_VERSION.tar.gz -C /usr/share/ \
    && ln -s /usr/share/$PKG_NAME-$ELASTICSEARCH_VERSION /usr/share/$PKG_NAME \
    && rm -rf /tmp/*.tar.gz /var/cache/apk/* \
    && chown nobody /usr/share/elasticsearch \
    && apk del curl \
    && rm -rf /var/cache/apk/*

ENV PATH /usr/share/elasticsearch/bin:$PATH

WORKDIR /usr/share/elasticsearch

RUN set -ex \
	&& for path in \
		./data \
		./logs \
		./config \
		./config/scripts \
	; do \
		mkdir -p "$path"; \
		chown -R nobody:nobody "$path"; \
done

# Add files
COPY config ./config
COPY docker-entrypoint.sh /

# Specify Volume
VOLUME ["/usr/share/elasticsearch/data"]

# Exposes
EXPOSE 9200
EXPOSE 9300

USER nobody

# CMD
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["elasticsearch"]