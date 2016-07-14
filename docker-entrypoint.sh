#!/bin/sh

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-9001}

echo "Starting with UID : $USER_ID"
addgroup -g $USER_ID user && adduser -D -G user -s /bin/false -u $USER_ID user
export HOME=/home/user


# ElasticSearch Docker Entrypoint as per:
# https://github.com/docker-library/elasticsearch
# Apache Licensed: https://github.com/docker-library/elasticsearch/blob/dce83166a2636abfac110a4555cdf17fd554ae91/LICENSE

set -e

# Add elasticsearch as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- elasticsearch "$@"
fi


# Drop root privileges if we are running elasticsearch
chown -R user:user /usr/share/elasticsearch
chown -R user:user /usr/share/$PKG_NAME-$ELASTICSEARCH_VERSION
#chown -R user:user /usr/share/elasticsearch/data
exec /usr/local/bin/gosu user "$@"