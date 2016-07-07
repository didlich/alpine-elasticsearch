
# use base image
FROM anapsix/alpine-java:jre8

# Set environment variables
ENV PKG_NAME elasticsearch
ENV ELASTICSEARCH_VERSION 1.7.1
ENV ELASTICSEARCH_URL https://download.elastic.co/$PKG_NAME/$PKG_NAME/$PKG_NAME-$ELASTICSEARCH_VERSION.tar.gz

# Download Elasticsearch
RUN apk update \
    && apk add openssl curl \
    && mkdir -p /opt \  
    && echo -O /tmp/$PKG_NAME-$ELASTICSEARCH_VERSION.tar.gz $ELASTICSEARCH_URL \
    && wget -O /tmp/$PKG_NAME-$ELASTICSEARCH_VERSION.tar.gz $ELASTICSEARCH_URL \
    && tar -xvzf /tmp/$PKG_NAME-$ELASTICSEARCH_VERSION.tar.gz -C /usr/share/ \
    && ln -s /usr/share/$PKG_NAME-$ELASTICSEARCH_VERSION /usr/share/$PKG_NAME \
    && rm -rf /tmp/*.tar.gz /var/cache/apk/* \
#    && mkdir /usr/share/elasticsearch \
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